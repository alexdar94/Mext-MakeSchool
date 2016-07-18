//
//  FirebaseHelper.swift
//  Mext
//
//  Created by Alex Lee on 11/07/2016.
//  Copyright © 2016 Alex Lee. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

// MARK: Messages Endpoint
class FirebaseHelper {
    static let ref = FIRDatabase.database().reference()
    
    static func messagesRef(chatRoomName : String) -> FIRDatabaseReference {
        return ref.child("messages/\(chatRoomName)")
    }
    
    static func userIsTypingRef(chatRoomName : String) -> FIRDatabaseReference {
        return ref.child("\(chatRoomName)/userIsTyping")
    }
}

// MARK: SoundClips Endpoint
extension FirebaseHelper{
    static func soundClipsRef(chatRoomName : String) -> FIRDatabaseReference {
        return ref.child("SoundClips")
    }
}

// MARK: Users Endpoint
extension FirebaseHelper{
    static func chatRoomsRef() -> FIRDatabaseReference {
        return ref.child("ChatRooms")
    }
}

// MARK: MessageInbox Endpoint
extension FirebaseHelper{
    
}

// MARK: UID Gen
extension FirebaseHelper{
    static func generateFIRUID() -> String {
        let UID = (String)(FirebaseHelper.ref.childByAutoId())
        return UID.substringWithRange(Range<String.Index>(start: UID.startIndex.advancedBy(52), end: UID.endIndex.advancedBy(0)))
    }
}