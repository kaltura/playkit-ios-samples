
import UIKit
import PlayKit
import PlayKitUtils
import PlayKitKava

fileprivate let SERVER_BASE_URL = "https://cdnapisec.kaltura.com"
fileprivate let PARTNER_ID = 1424501
fileprivate let ENTRY_ID = "1_djnefl4e"

class ViewController: UIViewController {
    var entryId: String?
    var ks: String?
    var player: Player?

    var playheadTimer: Timer?
    
    @IBOutlet weak var playerContainer: PlayerView!
    @IBOutlet weak var playheadSlider: UISlider!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.playheadSlider.isContinuous = false;
        
        try! self.setupPlayer()
        
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
    func setupPlayer() throws {
        self.player = try PlayKitManager.shared.loadPlayer(pluginConfig: createPluginConfig())
        
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

        self.player?.addPeriodicObserver(interval: 0.2, observeOn: DispatchQueue.main, using: { (pos) in
            self.playheadSlider.value = Float(pos)
            self.positionLabel.text = format(pos)
        })
        
        self.player?.addObserver(self, events: [PlayerEvent.durationChanged], block: { (event) in
            if let e = event as? PlayerEvent.DurationChanged, let d = e.duration as? TimeInterval {
                self.playheadSlider.maximumValue = Float(d)
                self.durationLabel.text = format(d)
            }
        })
    }
    
    func createPluginConfig() -> PluginConfig? {
        return PluginConfig(config: [KavaPlugin.pluginName: createKavaConfig()])
    }
    
    func createKavaConfig() -> KavaPluginConfig {
        return KavaPluginConfig(partnerId: PARTNER_ID, entryId: entryId, ks: ks, playbackContext: nil, referrer: nil, applicationVersion: nil, playlistId: nil, customVar1: nil, customVar2: nil, customVar3: nil)
    }
        
    func loadMedia() {
        let sessionProvider = SimpleSessionProvider(serverURL: SERVER_BASE_URL, partnerId: Int64(PARTNER_ID), ks: ks)
        let mediaProvider: OVPMediaProvider = OVPMediaProvider(sessionProvider)
        mediaProvider.entryId = entryId
        mediaProvider.loadMedia { (mediaEntry, error) in
            if let me = mediaEntry, error == nil {
                // create media config
                let mediaConfig = MediaConfig(mediaEntry: me, startTime: 0.0)
                
                // prepare the player
                self.player!.prepare(mediaConfig)
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
        
        if player.isPlaying {
            player.pause()
        } else {
            player.play()
        }
    }
    
    @IBAction func playheadValueChanged(_ sender: Any) {
        guard let player = self.player else {
            print("player is not set")
            return
        }
        
        player.currentTime = TimeInterval(playheadSlider.value)
    }
}
