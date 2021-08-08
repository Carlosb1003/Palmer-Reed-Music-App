//
//  ViewController.swift
//  Palmer Reed
//
//  Created by Carlos Belardo on 8/4/21.
//

import UIKit
import AudioToolbox

class ViewController: UIViewController {

    var pulseLayers = [CAShapeLayer]()
    var pulseArray = [CAShapeLayer]()

    @IBOutlet weak var entryLogo: UIImageView!
    @IBOutlet weak var listenBtn: UIButton!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        entryLogo.layer.cornerRadius = entryLogo.frame.size.width/2.0
        createPulse()
      
      
    }
    
    
    func createPulse() {
        
        for _ in 0...2 {
            let circularPath = UIBezierPath(arcCenter: .zero, radius: ((self.entryLogo.superview?.frame.size.width )! )/2, startAngle: 0, endAngle: 2 * .pi , clockwise: true)
            let pulsatingLayer = CAShapeLayer()
            pulsatingLayer.path = circularPath.cgPath
            pulsatingLayer.lineWidth = 2.5
            pulsatingLayer.fillColor = UIColor.clear.cgColor
            pulsatingLayer.lineCap = CAShapeLayerLineCap.round
            pulsatingLayer.position = CGPoint(x: entryLogo.frame.size.width / 2.0, y: entryLogo.frame.size.width / 2.0)
            entryLogo.layer.addSublayer(pulsatingLayer)
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
    @IBAction func smartPressed(_ sender: Any) {
        
        let path = Bundle.main.path(forResource: "smart", ofType: "mp3")!
                let url = URL(fileURLWithPath: path)
                var soundID : SystemSoundID = 4543523
                let cfURL = CFURLCreateWithString(kCFAllocatorDefault, url.absoluteString as CFString, nil)
                AudioServicesCreateSystemSoundID(cfURL!, &soundID)
                AudioServicesPlaySystemSound(soundID)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8, execute: {
            self.performSegue(withIdentifier: "Smart", sender: self)
        })
    
        
    }
    
}

