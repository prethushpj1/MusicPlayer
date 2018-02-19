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
        tblSongs.delegate = self
        tblSongs.dataSource = self
        self.title = LocalString("ALL.SONGS")
        
        if ObjCUtils.isIphoneX() {
            constraintTableTop.constant = 88
        }else{
            constraintTableTop.constant = 0
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
        let cell = tableView.dequeueReusableCell(withIdentifier: LocalString("SONGS.CELL"), for: indexPath)
        let songsQuery = MPMediaQuery.songs()
        if let song = songsQuery.items?[indexPath.row]{
            cell.textLabel?.text = song.value(forProperty: MPMediaItemPropertyTitle) as? String ?? ""
            cell.detailTextLabel?.text = song.value(forProperty: MPMediaItemPropertyArtist) as? String ?? ""
        }
        return cell
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

