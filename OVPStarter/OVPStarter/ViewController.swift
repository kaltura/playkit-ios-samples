import UIKit
import PlayKit
import PlayKitUtils
import PlayKitKava
import PlayKitProviders

// VOD
fileprivate let SERVER_BASE_URL = "https://cdnapisec.kaltura.com"
fileprivate let PARTNER_ID = 1424501
fileprivate let ENTRY_ID = "1_djnefl4e"

// Live DVR
//fileprivate let SERVER_BASE_URL = "https://cdnapisec.kaltura.com"
//fileprivate let PARTNER_ID = 1740481
//fileprivate let ENTRY_ID = "1_fdv46dba"

// Live
//fileprivate let SERVER_BASE_URL = "http://qa-apache-php7.dev.kaltura.com/"
//fileprivate let PARTNER_ID = 1091
//fileprivate let ENTRY_ID = "0_f8re4ujs"

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

        // 2. Load the player
        do {
            self.player = try PlayKitManager.shared.loadPlayer(pluginConfig: createPluginConfig())
            // 3. Register events if have ones.
            // Event registeration must be after loading the player successfully to make sure events are added,
            // and before prepare to make sure no events are missed (when calling prepare player starts buffering and sending events)
            self.addPlayerEventObservations()
            
            // 4. Prepare the player (can be called at a later stage, preparing starts buffering the video)
            self.setupPlayer()
        } catch let e {
            // Error loading the player
            print("error:", e.localizedDescription)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // Remove observers
        self.removePlayerEventObservations()
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
        
        entryId = ENTRY_ID
        loadMedia()
    }
    
    func addPlayerEventObservations() {
        // Observe duration and currentTime to update UI
        self.player?.addObserver(self, events: [PlayerEvent.durationChanged, PlayerEvent.playheadUpdate], block: { (event) in
            switch event {
            case is PlayerEvent.DurationChanged:
                if let playerEvent = event as? PlayerEvent, let d = playerEvent.duration as? TimeInterval {
                    self.durationLabel.text = self.format(d)
                }
            case is PlayerEvent.PlayheadUpdate:
                if let playerEvent = event as? PlayerEvent, let currentTime = playerEvent.currentTime {
                    self.playheadSlider.value = Float(self.player.currentTime / self.player.duration)
                    self.positionLabel.text = self.format(currentTime.doubleValue)
                }
            default:
                break
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
        })
    }
    
    func removePlayerEventObservations() {
        self.player?.removeObserver(self, events: [PlayerEvent.durationChanged,
                                                   PlayerEvent.playheadUpdate,
                                                   PlayerEvent.play,
                                                   PlayerEvent.ended,
                                                   PlayerEvent.pause])
    }
    
    func format(_ time: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        
        if let s = formatter.string(from: time) {
            return s.count > 7 ? s : "0" + s
        } else {
            return "00:00:00"
        }
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
                
                self.playheadSlider.isEnabled = (me.mediaType != .live)
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
            player.replay()
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
        player.currentTime = player.duration * Double(playheadSlider.value)
        positionLabel.text = format(player.currentTime)
    }
}
