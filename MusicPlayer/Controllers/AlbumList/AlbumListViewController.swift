//
//  AlbumListViewController.swift
//  MusicPlayer
//
//  Created by Prethush on 17/02/18.
//  Copyright © 2018 Prethush. All rights reserved.
//

import UIKit
import MediaPlayer

final class AlbumListViewController: UIViewController {

    @IBOutlet weak var tblAlbums: UITableView!
    @IBOutlet weak var constraintTableTop: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblAlbums.delegate = self
        tblAlbums.dataSource = self
        self.title = LocalString("ALL.ALBUMS")
        
        if ObjCUtils.isIphoneX() {
            constraintTableTop.constant = 88
        }else{
            constraintTableTop.constant = 0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tblAlbums.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let albumInfoVC = segue.destination as? AlbumInfoTableViewController
        let albumsQuery = MPMediaQuery.albums()
        albumInfoVC?.album = albumsQuery.items?[self.tblAlbums.indexPathForSelectedRow?.row ?? 0]
    }
}

extension AlbumListViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let albumsQuery = MPMediaQuery.albums()
        return albumsQuery.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocalString("ALBUMS.CELL"), for: indexPath) as? AlbumListTableViewCell
        let albumsQuery = MPMediaQuery.albums()
        if let album = albumsQuery.items?[indexPath.row]{
            cell?.lblAlbumTitle.text = album.value(forProperty: MPMediaItemPropertyAlbumTitle) as? String ?? ""
            
            if let albumArt = album.value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork, let albumImage = albumArt.image(at: CGSize(width: 44.0, height: 44.0)){
                cell?.imgAlbumArt.image = albumImage
            }else{
                cell?.imgAlbumArt.image = UIImage(named: "noAlbumArt")
            }
        }
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
