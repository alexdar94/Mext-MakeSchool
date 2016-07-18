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
    
}

// MARK: ChatRooms Endpoint
extension FirebaseHelper{
    static func chatRoomsRef() -> FIRDatabaseReference {
        return ref.child("ChatRooms")
    }
    
    static func saveNewChatRoom(chatRoomUID: String, newChatRoom: ChatRoom){
        let newChatRoomRef = FirebaseHelper.chatRoomsRef().child(chatRoomUID)
        let newChatRoom_JSON = [
            "userIsTyping": newChatRoom.userIsTyping,
            "lastMessage": newChatRoom.lastMessage,
            "title": newChatRoom.title,
            "chatPictureUrl": newChatRoom.chatRoomPictureUrl
        ]
        newChatRoomRef.setValue(newChatRoom_JSON)
    }
    
}

// MARK: ChatRoomMembers Endpoint
extension FirebaseHelper{
    static func chatRoomMembersRef() -> FIRDatabaseReference {
        return ref.child("ChatRoomMembers")
    }
    
    static func saveNewChatRoomMemberRelationship(chatRoomUID: String, userUID: String){
        let newChatRoomMemberRef = FirebaseHelper.chatRoomMembersRef().child(chatRoomUID)
        let newChatRoomMember_JSON = [
            userUID : true
        ]
        newChatRoomMemberRef.updateChildValues(newChatRoomMember_JSON)
    }
    
}

// MARK: UID Gen
extension FirebaseHelper{
    static func generateFIRUID(ref:FIRDatabaseReference) -> String {
        return ref.childByAutoId().key
    }
}