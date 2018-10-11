
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
        
        self.player?.addPeriodicObserver(interval: 0.2, observeOn: DispatchQueue.main, using: { (pos) in
            self.playheadSlider.value = Float(pos)
            print("pos:\(pos)")
        })
                
        self.player?.addObserver(self, events: [PlayerEvent.durationChanged], block: { (event) in
            if let e = event as? PlayerEvent.DurationChanged, let d = e.duration {
                self.playheadSlider.maximumValue = Float(truncating: d)
            }
        })
    }
    
    func createPluginConfig() -> PluginConfig? {
        return nil
//        return PluginConfig(config: [KavaPlugin.pluginName: createKavaConfig()])
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
//            self.playheadTimer?.invalidate()
//            self.playheadTimer = nil

        } else {
            player.play()
//            self.playheadTimer = PKTimer.every(0.5) { (timer) in
//                self.playheadSlider.value = Float(player.currentTime)
//            }
        }
//        
//        
//        if !(player.isPlaying) {
//            self.playheadTimer = PKTimer.every(0.5) { (timer) in
//                self.playheadSlider.value = Float(player.currentTime / player.duration)
//            }
//            player.play()
//        }
    }
    
//    @IBAction func pauseTouched(_ sender: Any) {
//        guard let player = self.player else {
//            print("player is not set")
//            return
//        }
//        
//        self.playheadTimer?.invalidate()
//        self.playheadTimer = nil
//        player.pause()
//    }
    
    @IBAction func playheadValueChanged(_ sender: Any) {
        guard let player = self.player else {
            print("player is not set")
            return
        }
        
        player.currentTime = TimeInterval(playheadSlider.value)
        
//        let slider = sender as! UISlider
        
//        print("playhead value:", slider.value)
//        player.currentTime = player.duration * Double(slider.value)
    }
}
