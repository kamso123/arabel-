//
//  LiveViewController.swift
//  arabelFM1.0
//
//  Created by Admin on 18/10/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import AVKit

class LiveViewController: UIViewController {

    var player: AVPlayer?
    var playerItem : AVPlayerItem?
    var timer: Timer?
    
    var playerFr: AVPlayer?
    var playerItemFr : AVPlayerItem?
    var timerFr: Timer?
    
    @IBOutlet weak var button_menu: UIBarButtonItem!
    @IBOutlet weak var trackSlider: UISlider!
    @IBOutlet weak var trackSliderFr: UISlider!
    
    
    @IBOutlet weak var button_ar: UIButton!
    @IBOutlet weak var button_fr: UIButton!
    
    @IBOutlet weak var debutTemps: UILabel!
    @IBOutlet weak var finTemps: UILabel!
    @IBOutlet weak var debutTempsFr: UILabel!
    @IBOutlet weak var finTempsFr: UILabel!
    
    /// Charge le podcast de l'émission en question.
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        button_menu.target = revealViewController()
        button_menu.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    
        getAudioAr()
        getAudioFr()
        debutTemps.text = "00:00"
        debutTempsFr.text = "00:00"
      
    }
    
    /// instancie la rediffusion flash en arabe.
    func getAudioAr() {
        
        let url = NSURL(string: "https://www.arabel.fm/infoauto/last-flash-AR.mp3")
        playerItem = AVPlayerItem(url: url! as URL)
        player = AVPlayer(playerItem: playerItem!)
        
        
        let duration : CMTime = (self.player?.currentItem!.asset.duration)!
        let seconds : Float64 = CMTimeGetSeconds(duration)
        let maxTime : Float = Float(seconds)
        self.trackSlider.maximumValue = maxTime
 
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(LiveViewController.audioSliderUpdate), userInfo: nil, repeats: true)
        
    }
    
    /// instancie la rediffusion flash en français.
    func getAudioFr() {
        
        let url = NSURL(string: "https://www.arabel.fm/infoauto/last-flash-FR.mp3")
        playerItemFr = AVPlayerItem(url: url! as URL)
        playerFr = AVPlayer(playerItem: playerItemFr!)
        
        
        let duration : CMTime = (self.playerFr?.currentItem!.asset.duration)!
        let seconds : Float64 = CMTimeGetSeconds(duration)
        let maxTime : Float = Float(seconds)
        self.trackSliderFr.maximumValue = maxTime
        
        self.timerFr = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(LiveViewController.audioSliderUpdateFr), userInfo: nil, repeats: true)
        
    }
    
    /**
     Notifie le contrôleur de vue que sa vue est sur le point d'être ajoutée à une hiérarchie de vues.
     
     - Parameter animated: toutes les animations sont configurées pour montrer la vue. Si c'est vrai, la vue est ajoutée à la fenêtre à l'aide d'une animation
     */
      override func viewWillAppear(_ animated: Bool) {
        
     super.viewWillAppear(animated)
     NotificationCenter.default.addObserver(self, selector: #selector(LiveViewController.finishedPlayingAr), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerItem)
        
         NotificationCenter.default.addObserver(self, selector: #selector(LiveViewController.finishedPlayingFr), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerItemFr)
     
     }
    
    /**
     Notifie le contrôleur de vue que sa vue est sur le point d'être supprimée d'une hiérarchie de vues.
     
     - Parameter animated: toutes les animations sont configurées pour montrer la vue. Si vrai, la disparition de la vue est en cours d'animation
     */
     override func viewWillDisappear(_ animated: Bool) {
        
     super.viewWillAppear(animated)
     // remove the timer
     self.timer?.invalidate()
     self.timerFr?.invalidate()
     // remove the observer when leaving page
     NotificationCenter.default.removeObserver(player?.currentItem! as Any)
     NotificationCenter.default.removeObserver(playerFr?.currentItem! as Any)
     }
    
    
     /// permet de changer l'animation du bouton. Elle est enregistrer comme observeur par la fonction viewWillAppear.
    @objc func finishedPlayingAr() {
        
        self.button_ar.setImage(UIImage(named: "playFlash.png"), for: UIControl.State.normal)
        let seconds : Int64 = 0
        let preferredTimeScale : Int32 = 1
        let seekTime : CMTime = CMTimeMake(value: seconds, timescale: preferredTimeScale)
        
        playerItem!.seek(to: seekTime)
    }
    
    /// permet de changer l'animation du bouton. Elle est enregistrer comme observeur par la fonction viewWillAppear.
    @objc func finishedPlayingFr() {
        
        self.button_fr.setImage(UIImage(named: "playFlash.png"), for: UIControl.State.normal)
        let seconds : Int64 = 0
        let preferredTimeScale : Int32 = 1
        let seekTime : CMTime = CMTimeMake(value: seconds, timescale: preferredTimeScale)
        
        playerItemFr!.seek(to: seekTime)
    }

    
    /// Permet de mettre à jour  le slider de déplacement à jour avec le flux audio arabe ainsi que le temps écoulé.
    @objc func audioSliderUpdate() {
        
        let currentTime : CMTime = (self.playerItem?.currentTime())!
        let seconds : Float64 = CMTimeGetSeconds(currentTime)
        let time : Float = Float(seconds)
        self.trackSlider.value = time
        
        let currentTimeInSeconds = CMTimeGetSeconds((player?.currentTime())!)
        // 2 Alternatively, you could able to get current time from `currentItem` - videoPlayer.currentItem.duration
        
        let mins = currentTimeInSeconds / 60
        let secs = currentTimeInSeconds.truncatingRemainder(dividingBy: 60)
        let timeformatter = NumberFormatter()
        timeformatter.minimumIntegerDigits = 2
        timeformatter.minimumFractionDigits = 0
        timeformatter.roundingMode = .down
        guard let minsStr = timeformatter.string(from: NSNumber(value: mins)), let secsStr = timeformatter.string(from: NSNumber(value: secs)) else {
            return
        }
        debutTemps.text = "\(minsStr).\(secsStr)"
        
        let currentTimeInSecondss = CMTimeGetSeconds((player?.currentItem?.duration)!)
        
        let minss = currentTimeInSecondss / 60
        let secss = currentTimeInSecondss.truncatingRemainder(dividingBy: 60)
        let timeformatters = NumberFormatter()
        timeformatters.minimumIntegerDigits = 2
        timeformatters.minimumFractionDigits = 0
        timeformatters.roundingMode = .down
        guard let minsStrs = timeformatter.string(from: NSNumber(value: minss)), let secsStrs = timeformatter.string(from: NSNumber(value: secss)) else {
            return
        }
       
        finTemps.text = "\(minsStrs).\(secsStrs)"
       
    }
    
    /// Permet de mettre à jour  le slider de déplacement à jour avec le flux audio français ainsi que le temps écoulé.
    @objc func audioSliderUpdateFr() {
        
        let currentTime : CMTime = (self.playerItemFr?.currentTime())!
        let seconds : Float64 = CMTimeGetSeconds(currentTime)
        let time : Float = Float(seconds)
        self.trackSliderFr.value = time
        
        let currentTimeInSeconds = CMTimeGetSeconds((playerFr?.currentTime())!)
        
        let mins = currentTimeInSeconds / 60
        let secs = currentTimeInSeconds.truncatingRemainder(dividingBy: 60)
        let timeformatter = NumberFormatter()
        timeformatter.minimumIntegerDigits = 2
        timeformatter.minimumFractionDigits = 0
        timeformatter.roundingMode = .down
        guard let minsStr = timeformatter.string(from: NSNumber(value: mins)), let secsStr = timeformatter.string(from: NSNumber(value: secs)) else {
            return
        }
        debutTempsFr.text = "\(minsStr).\(secsStr)"
        
        let currentTimeInSecondss = CMTimeGetSeconds((playerFr?.currentItem?.duration)!)
        let minss = currentTimeInSecondss / 60
        let secss = currentTimeInSecondss.truncatingRemainder(dividingBy: 60)
        let timeformatters = NumberFormatter()
        timeformatters.minimumIntegerDigits = 2
        timeformatters.minimumFractionDigits = 0
        timeformatters.roundingMode = .down
        guard let minsStrs = timeformatter.string(from: NSNumber(value: minss)), let secsStrs = timeformatter.string(from: NSNumber(value: secss)) else {
            return
        }
        finTempsFr.text = "\(minsStrs).\(secsStrs)"       
    }

    /// lance la vidéo d'arabel en direct.
    ///
    /// - Parameter sender: l'action du bouton
    @IBAction func liveStream(_ sender: Any) {
        
        let url = URL(string: "https://livevideo.infomaniak.com/streaming/livecast/arabelfmendirect/playlist.m3u8")
        let player = AVPlayer(url: url!)
        let controller = AVPlayerViewController()
        controller.player = player
        present(controller, animated: true){
            player.play()
        }
    }
    
    
    /// Controle le flux audio arabe.
    ///
    /// - Parameter sender: l'action du bouton
    @IBAction func streamAr(_ sender: Any) {
        
        if player?.rate == 0
        {
            player!.play()
            button_ar.setImage(UIImage(named: "pauseFlash.png"), for: UIControl.State.normal)
            
        } else {
            player!.pause()
            
            button_ar.setImage(UIImage(named: "playFlash.png"), for: UIControl.State.normal)
        }
    }
    
    /// Controle le flux audio français
    ///
    /// - Parameter sender: l'action du bouton
    @IBAction func streamFr(_ sender: Any) {
        
        if playerFr?.rate == 0
        {
            playerFr!.play()
            button_fr.setImage(UIImage(named: "pauseFlash.png"), for: UIControl.State.normal)
            
        } else {
            playerFr!.pause()
            
            button_fr.setImage(UIImage(named: "playFlash.png"), for: UIControl.State.normal)
        }
    }
    
    
    /// Permet de déplacer le slider où l'on veut et la reprise du flux audio arabe se fait instantanément.
    ///
    /// - Parameter sender: l'action du bouton
    @IBAction func changeTrack(_ sender: Any) {
        
        trackSlider.isContinuous = true

        let seconds : Int64 = Int64(trackSlider.value)
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
        
        player!.seek(to: targetTime)
        
        if player!.rate == 0
        {
            player?.play()
            button_ar.setImage(UIImage(named: "pauseFlash.png"), for: UIControl.State.normal)

        }
        
    }
    
    /// Permet de déplacer le slider où l'on veut et la reprise du flux audio francais se fait instantanément.
    ///
    /// - Parameter sender: l'action du bouton
    @IBAction func changeTrackFr(_ sender: Any) {
        
         trackSliderFr.isContinuous = true
        let seconds : Int64 = Int64(trackSliderFr.value)
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
        
        playerFr!.seek(to: targetTime)
        
        if playerFr!.rate == 0
        {
            playerFr?.play()
            button_fr.setImage(UIImage(named: "pauseFlash.png"), for: UIControl.State.normal)
            
        }
        
    }
    
}
