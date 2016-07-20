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
        return ref.child("Messages/\(chatRoomName)")
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
    static func usersRef() -> FIRDatabaseReference {
        return ref.child("Users")
    }
    
    static func userRef(userUID: String) -> FIRDatabaseReference {
        return usersRef().child(userUID)
    }
    
    static func userChatRoomsRef(userUID: String) -> FIRDatabaseReference {
        return userRef(userUID).child("chatRooms")
    }
    
    static func getUser(userUID: String, onComplete: User? -> Void ) {
        
        userRef(userUID).observeSingleEventOfType(.Value, withBlock: { snapshot in
            let UID = userUID
            let email = snapshot.value!["email"] as! String
            let displayName = snapshot.value!["displayName"] as! String
            let photoUrl = snapshot.value!["photoUrl"] as! String
            let phoneNumber = snapshot.value!["phoneNumber"] as! String
            
            let user = User(UID: UID, email: email, displayName: displayName, photoUrl: photoUrl, phoneNumber: phoneNumber)
            
            onComplete(user)
        })
    }
    
    static func getUserChatRoomUIDs(userUID: String, onComplete: [String]? -> Void ) {
        userChatRoomsRef(userUID).observeEventType(.Value, withBlock: { snapshot in
            var chatRoomKeys: [String]? = nil
            if let value = snapshot.value as? [String: AnyObject] {
                chatRoomKeys = Array(value.keys)
            } else {
                print("Firebase ChatRooms Endpoint - null")
            }
            onComplete(chatRoomKeys)
        })
    }
    
    static func saveNewUser(newUser: User){
        let newUserRef = FirebaseHelper.usersRef().child(newUser.UID)
        let newUserRef_JSON = [
            "email": newUser.email,
            "displayName": newUser.displayName,
            "photoUrl": newUser.photoUrl,
            "phoneNumber": newUser.phoneNumber
        ]
        newUserRef.setValue(newUserRef_JSON)
    }
    
    static func addChatRoomToUser(user: User, chatRoomUID: String){
        let newUserRef_JSON = [
            chatRoomUID: true
        ]
        FirebaseHelper.userChatRoomsRef(user.UID).setValue(newUserRef_JSON)
    }
}

// MARK: ChatRooms Endpoint
extension FirebaseHelper{
    static func chatRoomsRef() -> FIRDatabaseReference {
        return ref.child("ChatRooms")
    }
    
    static func chatRoomRef(chatRoomUID: String) -> FIRDatabaseReference {
        return chatRoomsRef().child(chatRoomUID)
    }
    
    static func userIsTypingRef(chatRoomUID : String) -> FIRDatabaseReference {
        return chatRoomsRef().child("\(chatRoomUID)/userIsTyping")
    }
    
    static func getChatRoom(chatRoomUID: String, onComplete: ChatRoom -> Void ) {
        chatRoomRef(chatRoomUID).observeEventType(.Value, withBlock: { snapshot in
            if let value = snapshot.value as? [String: AnyObject] {
                onComplete(ChatRoom(UID: chatRoomUID
                                    , lastMessage: value["lastMessage"] as! String
                                    , title: value["title"] as! String
                                    , chatRoomPictureUrl: value["chatRoomPictureUrl"] as! String))
            } else {
                print("Firebase ChatRoom Endpoint - null")
            }
            
        })
    }
    
    static func saveNewChatRoom(chatRoomUID: String, newChatRoom: ChatRoom){
        let newChatRoomRef = FirebaseHelper.chatRoomsRef().child(chatRoomUID)
        let newChatRoom_JSON = [
            "userIsTyping": newChatRoom.userIsTyping,
            "lastMessage": newChatRoom.lastMessage,
            "title": newChatRoom.title,
            "chatRoomPictureUrl": newChatRoom.chatRoomPictureUrl
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