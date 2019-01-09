
import UIKit
import PlayKit
import PlayKitUtils
import PlayKitKava
import PlayKitProviders

fileprivate let SERVER_BASE_URL = "https://cdnapisec.kaltura.com"
fileprivate let PARTNER_ID = 1424501
fileprivate let ENTRY_ID = "1_djnefl4e"

class ViewController: UIViewController {

    enum State {
        case idle, playing, paused, ended
    }
    
    var entryId: String?
    var ks: String?
    var player: Player! // Created in viewDidLoad
    var state: State = .idle {
        didSet {
            let title: String
            switch state {
            case .idle:
                title = "|>"
            case .playing:
                title = "||"
            case .paused:
                title = "|>"
            case .ended:
                title = "<>"
            }
            playPauseButton.setTitle(title, for: .normal)
        }
    }
    
    @IBOutlet weak var playerContainer: PlayerView!
    @IBOutlet weak var playheadSlider: UISlider!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.state = .idle

        self.player = try! PlayKitManager.shared.loadPlayer(pluginConfig: createPluginConfig())
        self.setupPlayer()
        
        entryId = ENTRY_ID
        loadMedia()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
/************************/
// MARK: - Player Setup
/***********************/
    func setupPlayer() {
        
        self.player?.view = self.playerContainer
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        
        func format(_ time: TimeInterval) -> String {
            if let s = formatter.string(from: time) {
                return s.count > 7 ? s : "0" + s
            } else {
                return "00:00:00"
            }
        }

        // Observe media progress to update UI
        self.player?.addPeriodicObserver(interval: 0.2, observeOn: DispatchQueue.main, using: { (pos) in
            self.playheadSlider.value = Float(pos)
            self.positionLabel.text = format(pos)
        })
        
        // Observe duration to update UI
        self.player?.addObserver(self, events: [PlayerEvent.durationChanged], block: { (event) in
            if let e = event as? PlayerEvent.DurationChanged, let d = e.duration as? TimeInterval {
                self.playheadSlider.maximumValue = Float(d)
                self.durationLabel.text = format(d)
            }
        })

        // Observe play/pause to update UI
        self.player?.addObserver(self, events: [PlayerEvent.play, PlayerEvent.ended, PlayerEvent.pause], block: { (event) in
            switch event {
            case is PlayerEvent.Play, is PlayerEvent.Playing:
                self.state = .playing
                
            case is PlayerEvent.Pause:
                self.state = .paused
                
            case is PlayerEvent.Ended:
                self.state = .ended
                
            default:
                break
            }
            if let e = event as? PlayerEvent.DurationChanged, let d = e.duration as? TimeInterval {
                self.playheadSlider.maximumValue = Float(d)
                self.durationLabel.text = format(d)
            }
        })
    }
    
    func createPluginConfig() -> PluginConfig? {
        return PluginConfig(config: [KavaPlugin.pluginName: createKavaConfig()])
    }
    
    // Create Kava config using the current entryId and KS
    // Depending on backend setup, some of the optional (nil) parameters may be required as well.
    func createKavaConfig() -> KavaPluginConfig {
        return KavaPluginConfig(partnerId: PARTNER_ID, entryId: entryId, ks: ks, playbackContext: nil, referrer: nil, applicationVersion: nil, playlistId: nil, customVar1: nil, customVar2: nil, customVar3: nil)
    }
    
    // Load 
    func loadMedia() {
        let sessionProvider = SimpleSessionProvider(serverURL: SERVER_BASE_URL, partnerId: Int64(PARTNER_ID), ks: ks)
        let mediaProvider: OVPMediaProvider = OVPMediaProvider(sessionProvider)
        mediaProvider.entryId = entryId
        mediaProvider.loadMedia { (mediaEntry, error) in
            if let me = mediaEntry, error == nil {
                // create media config
                let mediaConfig = MediaConfig(mediaEntry: me, startTime: 0.0)
                
                // Update Kava config
                self.player.updatePluginConfig(pluginName: KavaPlugin.pluginName, config: self.createKavaConfig())

                // prepare the player
                self.player.prepare(mediaConfig)      
                
                self.state = .paused
            }
        }
    }
    
/************************/
// MARK: - Actions
/***********************/
    
    @IBAction func playTouched(_ sender: Any) {
        guard let player = self.player else {
            print("player is not set")
            return
        }
        
        switch state {
        case .playing:
            player.pause()
        case .idle:
            player.play()
        case .paused:
            player.play()
        case .ended:
            player.seek(to: 0)
            player.play()
        }
    }
    
    @IBAction func playheadValueChanged(_ sender: Any) {
        guard let player = self.player else {
            print("player is not set")
            return
        }
        
        if state == .ended && playheadSlider.value < playheadSlider.maximumValue {
            state = .paused
        }
        player.currentTime = TimeInterval(playheadSlider.value)
    }
}
