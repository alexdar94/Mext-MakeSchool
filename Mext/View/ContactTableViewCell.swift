//
//  ContactTableViewCell.swift
//  Mext
//
//  Created by Alex Lee on 21/07/2016.
//  Copyright © 2016 Alex Lee. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var userDisplayNameLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageButton.imageView?.layer.cornerRadius = self.profileImageButton.imageView!.frame.size.width / 2
    }
    
}

