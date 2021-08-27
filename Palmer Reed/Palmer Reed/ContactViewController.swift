//
//  ContactViewController.swift
//  Palmer Reed
//
//  Created by Carlos Belardo on 8/10/21.
//

import UIKit

class ContactViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func emailPressed(_ sender: Any) {
        email()
    }
    @IBAction func SpotifyPressed(_ sender: Any) {
        spotify()
    }
    @IBAction func twitterPressed(_ sender: Any) {
        twitter()
    }
    @IBAction func applePressed(_ sender: Any) {
        apple()
    }
    func twitter() {
     
       let lowerCaseSocialNetworkName = "twitter"
       let socialNetworkDomain = "com"
       let userName = "Palmerreedmusic"
       let appURL = URL(string: "\(lowerCaseSocialNetworkName)://user?screen_name=\(userName)")!
       let application = UIApplication.shared
     
       if application.canOpenURL(appURL) {
          application.open(appURL)
       } else {
          let webURL = URL(string: "https://\(lowerCaseSocialNetworkName).\(socialNetworkDomain)/\(userName)")!
       application.open(webURL)
       }
     
    }
    func spotify() {
        let application = UIApplication.shared
        let webURL = URL(string: "https://open.spotify.com/artist/4ulmcIhz563rmr5AOwStju?si=HupbDX0qRFeA8ZM2rxfMGw&dl_branch=1")!
        application.open(webURL)
    }
    func apple() {
        let application = UIApplication.shared
        let webURL = URL(string: "https://music.apple.com/gb/artist/palmer-reed/636044107")!
        application.open(webURL)
    }
    func email(){
        let email = "palmerreedmusic@gmail.com"
        if let url = URL(string: "mailto:\(email)") {
          if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
          } else {
            UIApplication.shared.openURL(url)
          }
        }
    }
}
