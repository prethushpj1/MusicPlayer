//
//  SongsViewTableViewCell.swift
//  MusicPlayer
//
//  Created by Prethush on 20/02/18.
//  Copyright © 2018 Prethush. All rights reserved.
//

import UIKit

final class SongsViewTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var imgArtwork: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
