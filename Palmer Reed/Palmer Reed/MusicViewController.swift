//
//  MusicViewController.swift
//  Palmer Reed
//
//  Created by Carlos Belardo on 8/5/21.
//

import UIKit

class MusicViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    
    @IBOutlet weak var musicTable: UITableView!
    // array of Song type
    var songs = [Song]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMusic()
        musicTable.delegate = self
        musicTable.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let song = songs[indexPath.row]
        // configure cell
        cell.textLabel?.text = song.name
        cell.detailTextLabel?.text = song.artist
        cell.imageView?.image = UIImage(named: song.imageName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //present the music player
        let position = indexPath.row
        //songs
        guard let vc = storyboard?.instantiateViewController(identifier: "musicPlayer") as? PlayerViewController else {
            return
        }
        //passing data to music player
        vc.songs = songs
        vc.position = position
        present(vc, animated: true)
    
    }
    
    func configureMusic(){
        //appending music
        songs.append(Song(name: "Prototype", artist: "Palmer Reed", imageName: "Logo", trackName: "Prototype"))
        songs.append(Song(name: "Just Might", artist: "Palmer Reed", imageName: "Logo", trackName: "Just Might"))
        songs.append(Song(name: "Money Counter", artist: "Palmer Reed", imageName: "Logo", trackName: "money counter"))
        songs.append(Song(name: "What Did I Miss", artist: "Palmer Reed", imageName: "Logo", trackName: "What Did I Miss"))
        songs.append(Song(name: "Stuck On You", artist: "Palmer Reed", imageName: "Logo", trackName: "Stuck On You"))
        songs.append(Song(name: "NAH", artist: "Palmer Reed", imageName: "Logo", trackName: "NAH"))
        songs.append(Song(name: "OMW", artist: "Palmer Reed", imageName: "Logo", trackName: "OMW"))
    }
    

}

//create struct for songs
struct Song {
    let name: String
    let artist: String
    let imageName: String
    let trackName: String
}
