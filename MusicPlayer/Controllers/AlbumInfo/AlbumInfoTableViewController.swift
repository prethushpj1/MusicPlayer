//
//  AlbumInfoTableViewController.swift
//  MusicPlayer
//
//  Created by Prethush on 18/02/18.
//  Copyright © 2018 Prethush. All rights reserved.
//

import UIKit
import MediaPlayer

final class AlbumInfoTableViewController: UITableViewController {
    var album: MPMediaItem?
    
    lazy var albumQuery: MPMediaQuery = {
        let albumQuery = MPMediaQuery.albums()
        let title = self.album?.value(forProperty: MPMediaItemPropertyAlbumTitle) as? String ?? ""
        let albumPredicate = MPMediaPropertyPredicate(value: title, forProperty: MPMediaItemPropertyAlbumTitle)
        albumQuery.addFilterPredicate(albumPredicate)
        return albumQuery
    }()
    
    private var albumArt: UIImage?{
        get{
            if let albumArt = self.album?.value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork, let albumImage = albumArt.image(at: CGSize(width: 100.0, height: 100.0)){
                return albumImage
            }
            return UIImage(named: "noAlbumArt")
        }
    }
    
    private var albumArtist: String?{
        get{
            if let albumArt = self.album?.value(forProperty: MPMediaItemPropertyAlbumArtist) as? String{
                return albumArt
            }
            return LocalString("UNKNOWN.ARTIST")
        }
    }
    
    private var albumInfo: String?{
        get{
            if let albumTracks = self.albumQuery.items{
                var trackCount = ""
                if albumTracks.count > 1 {
                    trackCount = "\(albumTracks.count) \(LocalString("SONGS"))"
                }else{
                    trackCount = "1 \(LocalString("SONG"))"
                }
                
                var playbackDuration:Double = 0
                for track in albumTracks {
                    playbackDuration += track.value(forProperty: MPMediaItemPropertyPlaybackDuration) as? Double ?? 0
                }
                
                var albumDuration = ""
                if (playbackDuration / 60) > 1{
                    albumDuration = "\(String(format: "%.2f", (playbackDuration / 60))) \(LocalString("MINUTES"))"
                }else{
                    albumDuration = "1 \(LocalString("MINUTE"))"
                }
                
                return "\(trackCount), \(albumDuration)"
            }
            return ""
        }
    }
    
    private var sameArtists: Bool?{
        get{
            if let tracksArray = self.albumQuery.items{
                let firstArtist = tracksArray.first?.value(forProperty: MPMediaItemPropertyArtist) as? String ?? ""
                for track in tracksArray {
                    if firstArtist == track.value(forProperty: MPMediaItemPropertyArtist) as? String ?? ""{
                        return true
                    }
                }
            }
            return false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.album?.value(forProperty: MPMediaItemPropertyAlbumTitle) as? String ?? ""
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.albumQuery.items?.count ?? 0) + 1
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 120
        }else{
            return 44
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: LocalString("ALBUM.INFO"), for: indexPath) as? AlbumInfoTableViewCell
            cell?.imgArtwork.image = self.albumArt
            cell?.lblTitle.text = self.albumArtist
            cell?.lblSubTitle.text = self.albumInfo
            return cell ?? UITableViewCell()
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: LocalString("ALBUM.SONGS"), for: indexPath)
            if let albumTracks = self.albumQuery.items{
                let track = albumTracks[indexPath.row - 1]
                let trackTitle = track.value(forProperty: MPMediaItemPropertyTitle) as? String
                if let trackNumber = track.value(forProperty: MPMediaItemPropertyAlbumTrackNumber) as? Int{
                    cell.textLabel?.text = "\(trackNumber). \(trackTitle ?? "")"
                }else{
                    cell.textLabel?.text = trackTitle ?? ""
                }
                
                if let same = self.sameArtists, same == true{
                    cell.detailTextLabel?.text = nil
                }else {
                    if let artist = track.value(forProperty: MPMediaItemPropertyArtist) as? String{
                        cell.detailTextLabel?.text = artist
                    }else{
                        cell.detailTextLabel?.text = nil
                    }
                }
            }
            return cell
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let albumTracks = self.albumQuery.items{
            let track = albumTracks[(self.tableView.indexPathForSelectedRow?.row ?? 1) - 1]
            let player = MPMusicPlayerController.systemMusicPlayer
            player.setQueue(with: MPMediaItemCollection(items: albumTracks))
            player.nowPlayingItem = track
            player.play()
        }
    }
}
