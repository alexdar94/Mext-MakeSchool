//
//  ChatRoom.swift
//  Mext
//
//  Created by Alex Lee on 18/07/2016.
//  Copyright © 2016 Alex Lee. All rights reserved.
//

import Foundation

class ChatRoom {
    
    var UID = "uidPlaceHolder"
    var userIsTyping = false
    var lastMessage = "lastMessagePlaceHolder"
    var title = "titlePlaceHolder"
    var chatRoomPictureUrl = "chatRoomPictureUrlPlaceHolder"
    var chatMembers = [User]()
    
    init(UID:String, lastMessage: String, title: String, chatRoomPictureUrl: String){
        self.UID = UID
        self.lastMessage = lastMessage
        self.title = title
        self.chatRoomPictureUrl = chatRoomPictureUrl
    }
}