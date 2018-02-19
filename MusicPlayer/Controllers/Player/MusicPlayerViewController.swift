//
//  MusicPlayerViewController.swift
//  MusicPlayer
//
//  Created by Prethush on 19/02/18.
//  Copyright © 2018 Prethush. All rights reserved.
//

import UIKit
import MediaPlayer

final class MusicPlayerViewController: UIViewController {

    @IBOutlet weak var constraintControllsHeight: NSLayoutConstraint!
    @IBOutlet weak var seekSlider: UISlider!
    @IBOutlet weak var btnPlayPause: UIButton!
    @IBOutlet weak var imgArtwork: UIImageView!
    @IBOutlet weak var lblArtist: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAlbum: UILabel!
    
    var player: MPMusicPlayerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if ObjCUtils.isIphoneX() {
            constraintControllsHeight.constant += 34
        }
        self.title = LocalString("NOW.PLAYING")
        self.player = MPMusicPlayerController.systemMusicPlayer
    }

    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        
        let notifyCenter = NotificationCenter.default
        notifyCenter.addObserver(forName: NSNotification.Name.MPMusicPlayerControllerPlaybackStateDidChange, object: nil, queue: nil) { [weak self] (notification) in
            self?.updatePlayButtonState()
        }
        
        notifyCenter.addObserver(forName: NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange, object: nil, queue: nil) { [weak self] (_) in
            self?.updateCurrentTrackInfo()
        }
        
        self.player?.beginGeneratingPlaybackNotifications()
        
        self.updatePlayButtonState()
        self.updateCurrentTrackInfo()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        let notifyCenter = NotificationCenter.default
        notifyCenter.removeObserver(self, name: NSNotification.Name.MPMusicPlayerControllerPlaybackStateDidChange, object: nil)
        notifyCenter.removeObserver(self, name: NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange, object: nil)
    }
    
    @IBAction func previousAction(_ sender: Any) {
        self.player?.skipToPreviousItem()
        self.player?.play()
    }
    
    @IBAction func nextAction(_ sender: Any) {
        self.player?.skipToNextItem()
        self.player?.play()
    }
    
    @IBAction func playAction(_ sender: Any) {
        if self.player?.playbackState == MPMusicPlaybackState.playing {
            self.player?.pause()
        }else{
            self.player?.play()
        }
    }
    
    @IBAction func seekBarAction(_ sender: UISlider) {
        print(sender.value)
    }
    
    private func updateCurrentTrackInfo(){
        if let currentPlayingItem = self.player?.nowPlayingItem, self.player?.playbackState != MPMusicPlaybackState.stopped{
            if let artWork = currentPlayingItem.value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork{
                self.imgArtwork.image = artWork.image(at: CGSize(width: 320, height: 320))
            }
            
            if let title = currentPlayingItem.value(forProperty: MPMediaItemPropertyTitle) as? String{
                self.lblTitle.text = title
            }else{
                self.lblTitle.text = LocalString("UNKNOWN.TITLE")
            }
            
            if let artist = currentPlayingItem.value(forProperty: MPMediaItemPropertyArtist) as? String{
                self.lblArtist.text = artist
            }else{
                self.lblArtist.text = LocalString("UNKNOWN.ARTIST")
            }
            
            if let album = currentPlayingItem.value(forProperty: MPMediaItemPropertyAlbumTitle) as? String{
                self.lblAlbum.text = album
            }else{
                self.lblAlbum.text = LocalString("UNKNOWN.ALBUM")
            }
        }
    }
    
    private func updatePlayButtonState(){
        if self.player?.playbackState == MPMusicPlaybackState.playing {
            self.btnPlayPause.setImage(UIImage(named: "pause"), for: [])
        }else{
            self.btnPlayPause.setImage(UIImage(named: "play"), for: [])
        }
    }
}
