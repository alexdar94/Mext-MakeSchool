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
    static func soundClipsRef() -> FIRDatabaseReference {
        return ref.child("SoundClips")
    }
    
    static func searchSoundClip(soundClipTag: String, onComplete: [SoundClip]? -> Void) {
        var matchingSoundClips: [SoundClip]?
        let searchQuery = soundClipsRef().queryLimitedToFirst(10)
        
        searchQuery.queryOrderedByChild("tag").queryEqualToValue(soundClipTag)
            .observeEventType(.ChildAdded, withBlock: { snapshot in
                if let value = snapshot.value as? [String: AnyObject] {
                    let soundClip = SoundClip(tag: value["tag"] as! String
                        , text: value["text"] as! String
                        , soundFileUrl: value["soundFileUrl"] as! String
                        , soundName: value["soundName"] as! String
                        , source: value["source"] as! String)
                    if (matchingSoundClips?.append(soundClip)) == nil {
                        matchingSoundClips = [soundClip]
                    }
                    onComplete(matchingSoundClips)
                }
        })
        onComplete(matchingSoundClips)
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
    
    static func userFriendsRef(userUID: String) -> FIRDatabaseReference {
        return userRef(userUID).child("friends")
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
    
    static func getExistingChatRoomKey(searchUserUID: String, chatPartnerUID: String, onComplete: String? -> Void ) {
        let chatRoomKeyQuery = userChatRoomsRef(searchUserUID).queryOrderedByValue().queryEqualToValue(chatPartnerUID)
        
        chatRoomKeyQuery.observeSingleEventOfType(.Value, withBlock: { snapshot in
            var chatRoomKey: String? = nil
            if let value = snapshot.value as? [String: AnyObject] {
                print("Existing chat room \(value)")
                chatRoomKey =  Array(value.keys)[0]
                print(chatRoomKey)
            } else {
                print("Firebase ExistingChatRoom Endpoint - null")
            }
            onComplete(chatRoomKey)
        })
    }
    
    static func getUserFriendUIDs(userUID: String, onComplete: [String]? -> Void ) {
        userFriendsRef(userUID).observeEventType(.Value, withBlock: { snapshot in
            var friendKeys: [String]? = nil
            if let value = snapshot.value as? [String: AnyObject] {
                friendKeys = Array(value.keys)
            } else {
                print("Firebase Friends Endpoint - null")
            }
            onComplete(friendKeys)
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
        let newUser_JSON = [
            chatRoomUID: true
        ]
        
        FirebaseHelper.userChatRoomsRef(user.UID).updateChildValues(newUser_JSON)
    }
    
    static func addFriends(fromUser: User, toUser: User){
        let newFriend_JSON = [
            toUser.UID: true
        ]
        
        FirebaseHelper.userFriendsRef(fromUser.UID).updateChildValues(newFriend_JSON)
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
                    , FIRLastMessageTimeStamp: ["lastMessageTime": value["lastMessageTime"]!]
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
            "lastMessageTime": newChatRoom.FIRLastMessageTimeStamp,
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