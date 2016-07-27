//
//  AddFriendTableViewCell.swift
//  Mext
//
//  Created by Alex Lee on 24/07/2016.
//  Copyright © 2016 Alex Lee. All rights reserved.
//

import UIKit
import AlamofireImage

protocol AddFriendTableViewCellDelegate: class {
    func cell(cell: AddFriendTableViewCell, didSelectFriendUser user: User)
    func cell(cell: AddFriendTableViewCell, didSelectUnfriendUser user: User)
}

class AddFriendTableViewCell: UITableViewCell {
    @IBOutlet weak var displayNameLabel: UILabel!

    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var addFriendButton: UIButton!

    weak var delegate: AddFriendTableViewCellDelegate?
    
    var user: User? {
        didSet {
            displayNameLabel.text = user?.displayName
            
            let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
                size: profilePictureImageView.frame.size,
                radius: 22.0
            )
            
            if let photoUrl = user?.photoUrl {
                profilePictureImageView.af_setImageWithURL(
                    NSURL(string: photoUrl)!,
                    placeholderImage: UIImage(named: "nobody_m.original")!,
                    filter: filter
                )
            }
        }
    }
    
    var canFriend: Bool? = true {
        didSet {
            /*
             Change the state of the follow button based on whether or not
             it is possible to follow a user.
             */
            if let canFriend = canFriend {
                addFriendButton.selected = !canFriend
            }
        }
    }
    
    @IBAction func addFriendButtonTapped(sender: AnyObject) {
        if let canFriend = canFriend where canFriend == true {
            delegate?.cell(self, didSelectFriendUser: user!)
            self.canFriend = false
        } else {
            delegate?.cell(self, didSelectUnfriendUser: user!)
            self.canFriend = true
        }
    }
}