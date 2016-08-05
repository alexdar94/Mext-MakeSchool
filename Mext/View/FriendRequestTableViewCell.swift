//
//  FriendRequestTableViewCell.swift
//  Mext
//
//  Created by Alex Lee on 04/08/2016.
//  Copyright © 2016 Alex Lee. All rights reserved.
//

import UIKit

class FriendRequestTableViewCell: UITableViewCell {

    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profilePictureImageView.layer.cornerRadius = self.profilePictureImageView.frame.size.width / 2
    }

}
