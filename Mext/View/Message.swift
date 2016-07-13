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
    var soundFileUrl : String
    //var attrStringIndex : [Int]
    var attrStringIndex : [[Int]]
    
    init(senderId: String, displayName: String, text: String, soundFileUrl: String, attrStringIndex : [[Int]]){
        self.soundFileUrl = soundFileUrl
        self.attrStringIndex = attrStringIndex
        super.init(senderId: senderId, senderDisplayName: displayName, date: NSDate(), text: text)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}