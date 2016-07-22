//
//  MessageInboxTableViewCell.swift
//  Mext
//
//  Created by Alex Lee on 18/07/2016.
//  Copyright © 2016 Alex Lee. All rights reserved.
//

import UIKit

class MessageInboxTableViewCell: UITableViewCell {
    
    @IBOutlet weak var chatRoomTitleLabel: UILabel!
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var lastMessageTimeLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    
//    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:)")
//    }
//    
//    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        
//        profileImageButton.imageView?.layer.cornerRadius = self.profileImageButton.imageView!.frame.size.width / 2
//    }
    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageButton.imageView?.layer.cornerRadius = self.profileImageButton.imageView!.frame.size.width / 2
    }

}
