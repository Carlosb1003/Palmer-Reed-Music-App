//
//  PlayerViewController.swift
//  Palmer Reed
//
//  Created by Carlos Belardo on 8/5/21.
//

import UIKit
import AVFoundation

class PlayerViewController: UIViewController {
    public var position: Int = 0
    public var songs: [Song] = []
    var player: AVAudioPlayer?
    var pulseLayers = [CAShapeLayer]()
    var pulseArray = [CAShapeLayer]()
    var timer: Timer?
    var slider: UISlider?
    let playPauseBtn = UIButton()
    
    //User interface elements
    private let albumimageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private let songLbl: UILabel = {
        let songLabel = UILabel()
        songLabel.textAlignment = .center
        songLabel.numberOfLines = 0
        songLabel.textColor = UIColor(red: 216/256, green: 132/256, blue: 212/256, alpha: 1)
        return songLabel
    }()
    private let artistLbl: UILabel = {
        let artistLabel = UILabel()
        artistLabel.textAlignment = .center
        artistLabel.numberOfLines = 0
        artistLabel.textColor = UIColor(red: 216/256, green: 132/256, blue: 212/256, alpha: 1)
        return artistLabel
    }()
    
   
    @IBOutlet var holder: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if holder.subviews.count == 0{
            configure()
        }
    }
    
    func configure(){
        //set up Player
        let song = songs[position]
        let urlString = Bundle.main.path(forResource: song.trackName, ofType: "mp3")
        do{
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true,options: .notifyOthersOnDeactivation)
            
            guard let urlString = urlString else {
                print("url is nil")
                return
            }
            let url = URL(fileURLWithPath: urlString)
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else {
                print("player is nil")
                return
            }
            player.play()
            
        }
        catch{
            print("There was an error playing your music")
        }
        
        
        //Set up UI elements
        
        //set up album cover with out storybord
        albumimageView.frame = CGRect(x: 10, y: 10, width: holder.frame.size.width - 20, height: holder.frame.size.width - 20)
        albumimageView.image = UIImage(named: song.imageName)
        holder.addSubview(albumimageView)
        createPulse()
        
        //adding labels without story board
        songLbl.frame = CGRect(x: 10, y: albumimageView.frame.size.height + 10, width: holder.frame.size.width - 20, height: 70)
        artistLbl.frame = CGRect(x: 10, y: albumimageView.frame.size.height + 10 + 70, width: holder.frame.size.width - 20, height: 70)
        songLbl.text = song.name
        artistLbl.text = song.artist
        holder.addSubview(songLbl)
        holder.addSubview(artistLbl)
        
        //adding player controls
        slider = UISlider(frame: CGRect(x: 20, y: holder.frame.size.height - 60 , width: holder.frame.size.width - 40 , height: 50))
        slider!.value = Float(player!.currentTime)
        slider!.maximumValue = Float(player!.duration)
        slider!.addTarget(self, action: #selector(didslideslider(_:)), for: .valueChanged)
        holder.addSubview(slider!)
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
        
        let nxtBtn = UIButton()
        let backBtn = UIButton()
        //button framing
        let yPos = artistLbl.frame.origin.y + 70 + 20
        let size: CGFloat = 30
        
        playPauseBtn.frame = CGRect(x: (holder.frame.size.width - size) / 2.0, y: yPos, width: size, height: size)
        nxtBtn.frame = CGRect(x: holder.frame.size.width - size - 20, y: yPos, width: size, height: size)
        backBtn.frame = CGRect(x: 20, y: yPos, width: size, height: size)
        
        //Button styling
        playPauseBtn.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
        nxtBtn.setBackgroundImage(UIImage(systemName: "forward.fill"), for: .normal)
        backBtn.setBackgroundImage(UIImage(systemName: "backward.fill"), for: .normal)
        playPauseBtn.tintColor = .white
        nxtBtn.tintColor = .white
        backBtn.tintColor = .white
        playPauseBtn.addTarget(self, action: #selector(tappedPlayPauseButton), for: .touchUpInside)
        nxtBtn.addTarget(self, action: #selector(tappednextButton), for: .touchUpInside)
        backBtn.addTarget(self, action: #selector(tappedBackButton), for: .touchUpInside)
        
        holder.addSubview(playPauseBtn)
        holder.addSubview(nxtBtn)
        holder.addSubview(backBtn)
    }
    @objc func updateTime(_ timer: Timer) {
        slider!.value = Float(player!.currentTime)
    }
    @objc func tappedBackButton(){
        if position > 0 {
            position = position - 1
            player?.stop()
            for subview in holder.subviews{
                subview.removeFromSuperview()
            }
            configure()
        }
    }
    @objc func tappednextButton(){
        if position < songs.count - 1 {
            position = position + 1
            player?.stop()
            for subview in holder.subviews{
                subview.removeFromSuperview()
            }
            configure()
        }
    }
    @objc func tappedPlayPauseButton(){
        
        if player?.isPlaying == true{
            player?.pause()
            playPauseBtn.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
        }else{
            player?.play()
            playPauseBtn.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }

    @objc func didslideslider(_ slider: UISlider){
        player!.currentTime = TimeInterval(slider.maximumValue - slider.value)
        player!.prepareToPlay()
        player!.play()
        //adjust volume
    }
    func createPulse() {
        
        for _ in 0...2 {
            let circularPath = UIBezierPath(arcCenter: .zero, radius: ((self.albumimageView.superview?.frame.size.width )! )/2, startAngle: 0, endAngle: 2 * .pi , clockwise: true)
            let pulsatingLayer = CAShapeLayer()
            pulsatingLayer.path = circularPath.cgPath
            pulsatingLayer.lineWidth = 2.5
            pulsatingLayer.fillColor = UIColor.clear.cgColor
            pulsatingLayer.lineCap = CAShapeLayerLineCap.round
            pulsatingLayer.position = CGPoint(x: albumimageView.frame.size.width / 2.0, y: albumimageView.frame.size.width / 2.0)
            albumimageView.layer.addSublayer(pulsatingLayer)
            pulseArray.append(pulsatingLayer)
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            self.animatePulsatingLayerAt(index: 0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
                self.animatePulsatingLayerAt(index: 1)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.animatePulsatingLayerAt(index: 2)
                })
            })
        })
        
    }
    
    
    func animatePulsatingLayerAt(index:Int) {
        
        //Giving color to the layer
        pulseArray[index].strokeColor = UIColor.darkGray.cgColor
        
        //Creating scale animation for the layer, from and to value should be in range of 0.0 to 1.0
        // 0.0 = minimum
        //1.0 = maximum
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 0.0
        scaleAnimation.toValue = 0.9
        
        //Creating opacity animation for the layer, from and to value should be in range of 0.0 to 1.0
        // 0.0 = minimum
        //1.0 = maximum
        let opacityAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        opacityAnimation.fromValue = 0.9
        opacityAnimation.toValue = 0.0
       
      // Grouping both animations and giving animation duration, animation repat count
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [scaleAnimation, opacityAnimation]
        groupAnimation.duration = 2.3
        groupAnimation.repeatCount = .greatestFiniteMagnitude
        groupAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        //adding groupanimation to the layer
        pulseArray[index].add(groupAnimation, forKey: "groupanimation")
        
    }
     override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player!.stop()
       
    }
    


}

