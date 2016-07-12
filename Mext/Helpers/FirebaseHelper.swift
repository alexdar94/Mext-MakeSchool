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

class FirebaseHelper {
    static let ref = FIRDatabase.database().reference()
    
    static func messageRef(chatRoomName : String) -> FIRDatabaseReference {
        return ref.child("\(chatRoomName)/messages")
    }
    
    static func userIsTypingRef(chatRoomName : String) -> FIRDatabaseReference {
        return ref.child("\(chatRoomName)/userIsTyping")
    }
    
    static func soundClipsRef(chatRoomName : String) -> FIRDatabaseReference {
        return ref.child("SoundClips")
    }
    
}