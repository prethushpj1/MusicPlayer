//
//  AlbumInfoTableViewCell.swift
//  MusicPlayer
//
//  Created by Prethush on 18/02/18.
//  Copyright © 2018 Prethush. All rights reserved.
//

import UIKit

final class AlbumInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var imgArtwork: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
