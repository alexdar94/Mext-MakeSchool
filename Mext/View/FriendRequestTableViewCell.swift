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
    
    weak var delegate: FriendRequestTableViewCellDelegate?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profilePictureImageView.layer.cornerRadius = self.profilePictureImageView.frame.size.width / 2
    }

    var row: Int!
    
    @IBAction func didTapAccept(sender: AnyObject) {
        delegate?.cell(self, didTapAccept: row)
    }
    
    @IBAction func didTapDecline(sender: AnyObject) {
        delegate?.cell(self, didTapDecline: row)
    }
}

protocol FriendRequestTableViewCellDelegate: class {
    func cell(cell: FriendRequestTableViewCell, didTapAccept row: Int)
    func cell(cell: FriendRequestTableViewCell, didTapDecline row: Int)
}
