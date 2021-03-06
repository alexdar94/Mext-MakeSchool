//
//  Message.swift
//  Mext
//
//  Created by Alex Lee on 11/07/2016.
//  Copyright © 2016 Alex Lee. All rights reserved.
//

import Foundation
import JSQMessagesViewController

class Message : JSQMessage {
    var soundFileUrls : [String]?
    var attrStringIndex : [[Int]]?
    
    init(senderId: String, displayName: String, text: String, soundFileUrls: [String]?, attrStringIndex : [[Int]]?){
        self.soundFileUrls = soundFileUrls
        self.attrStringIndex = attrStringIndex
        super.init(senderId: senderId, senderDisplayName: displayName, date: NSDate(), text: text)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}