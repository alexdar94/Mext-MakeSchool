//
//  ChatRoom.swift
//  Mext
//
//  Created by Alex Lee on 18/07/2016.
//  Copyright © 2016 Alex Lee. All rights reserved.
//

import Foundation

class ChatRoom {
    let TAG = "ChatRoom"
    
    var UID = "uidPlaceHolder"
    var userIsTyping = false
    var lastMessage = "lastMessagePlaceHolder"
    var lastMessageTime: NSDate {
        let date = (FIRLastMessageTimeStamp["lastMessageTime"] as? NSTimeInterval)
        return NSDate(timeIntervalSince1970: date!/1000)
    }
    var FIRLastMessageTimeStamp: [NSObject : AnyObject]!
    var title = "titlePlaceHolder"
    var chatRoomPictureUrl = "chatRoomPictureUrlPlaceHolder"
    var chatMembers = [User]()
    
    subscript(key: String) -> AnyObject? {
        switch key {
            case "chatRoomPictureUrl" : return chatRoomPictureUrl
            case "lastMessage" : return title
            case "lastMessageTime" : return FIRLastMessageTimeStamp
            case "title" : return title
            case "userIsTyping" : return userIsTyping
        default : return nil
        }
    }
    
    init(UID:String, lastMessage: String, FIRLastMessageTimeStamp: [NSObject : AnyObject], title: String, chatRoomPictureUrl: String){
        self.UID = UID
        self.lastMessage = lastMessage
        self.FIRLastMessageTimeStamp = FIRLastMessageTimeStamp
        self.title = title
        self.chatRoomPictureUrl = chatRoomPictureUrl
        //        print(NSDate(FIRLastMessageTimeStamp["lastMessageTime"] as? NSNumber))
    }
}