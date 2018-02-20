//
//  SongsViewController.swift
//  MusicPlayer
//
//  Created by Prethush on 17/02/18.
//  Copyright © 2018 Prethush. All rights reserved.
//

import UIKit
import MediaPlayer

final class SongsViewController: UIViewController {
    @IBOutlet weak var constraintTableTop: NSLayoutConstraint!
    @IBOutlet weak var tblSongs: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "All Songs"
        
        if ObjCUtils.isIphoneX() {
            constraintTableTop.constant = 88
        }else{
            constraintTableTop.constant = 0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.checkMediaPermission { (status) in
            if status{
                self.tblSongs.delegate = self
                self.tblSongs.dataSource = self
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                    self.tblSongs.reloadData()
                })
            }else{
                self.showAlert(Message: "Music player doesn't have access to your music files.")
            }
        }
    }
    
    func checkMediaPermission(Completion block: @escaping (Bool) -> Void){
        switch MPMediaLibrary.authorizationStatus() {
        case .authorized:
            block(true)
            break
        case .notDetermined:
            MPMediaLibrary.requestAuthorization({ (status) in
                if status == .authorized{
                    block(true)
                }else{
                    block(false)
                }
            })
            break
        default:
            block(false)
            break
        }
    }
}

extension SongsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let songsQuery = MPMediaQuery.songs()
        return songsQuery.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocalString("SONGS.CELL"), for: indexPath) as? SongsViewTableViewCell
        let songsQuery = MPMediaQuery.songs()
        if let song = songsQuery.items?[indexPath.row]{
            cell?.lblTitle?.text = song.value(forProperty: MPMediaItemPropertyTitle) as? String ?? ""
            cell?.lblSubtitle?.text = song.value(forProperty: MPMediaItemPropertyArtist) as? String ?? ""
            
            if let songArt = song.value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork, let songImage = songArt.image(at: CGSize(width: 44.0, height: 44.0)){
                cell?.imgArtwork.image = songImage
            }else{
                cell?.imgArtwork.image = UIImage(named: "noAlbumArt")
            }
        }
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let items = MPMediaQuery.songs().items{
            let track = items[self.tblSongs.indexPathForSelectedRow?.row ?? 0]
            let player = MPMusicPlayerController.systemMusicPlayer
            player.setQueue(with: MPMediaItemCollection(items: items))
            player.nowPlayingItem = track
            player.play()
        }
    }
}

