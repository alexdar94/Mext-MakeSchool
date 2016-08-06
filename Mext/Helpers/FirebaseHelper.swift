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
    
    static let TAG = "FirebaseHelper"
    
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
        
        searchQuery.queryOrderedByChild("tag/\(soundClipTag)").queryEqualToValue(true)
            .observeEventType(.Value, withBlock: { snapshot in
                for soundClipJSON in snapshot.children.allObjects {
                    var tags = [String]()
                    if let tagsJSON = soundClipJSON.value["tag"] as? [String: AnyObject]{
                        tags = Array(tagsJSON.keys)
                    }
                    let soundClip = SoundClip(tag: tags
                        , text: soundClipJSON.value["text"] as! String
                        , soundFileUrl: soundClipJSON.value["soundFileUrl"] as! String
                        , soundName: soundClipJSON.value["soundName"] as! String
                        , source: soundClipJSON.value["source"] as! String)
                    if (matchingSoundClips?.append(soundClip)) == nil {
                        matchingSoundClips = [soundClip]
                    }
                }
                onComplete(matchingSoundClips)
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
    
    static func userPhotoUrlRef(userUID: String) -> FIRDatabaseReference {
        return userRef(userUID).child("photoUrl")
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
    
    static func updateUserProfilePicUrl(userUID: String, photoUrl: String){
        userPhotoUrlRef(userUID).setValue(photoUrl)
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
                chatRoomKey =  Array(value.keys)[0]
            } else {
                print("Firebase ExistingChatRoom Endpoint - null")
            }
            onComplete(chatRoomKey)
        })
    }
    
    static func saveNewUser(newUser: User){
        let newUserRef = FirebaseHelper.usersRef().child(newUser.UID)
        let newUserRef_JSON = [
            "email": newUser.email,
            "displayName": newUser.displayName,
            "lowerCaseDisplayName": newUser.displayName.lowercaseString,
            "photoUrl": newUser.photoUrl,
            "phoneNumber": newUser.phoneNumber
        ]
        newUserRef.setValue(newUserRef_JSON)
    }
    
    static func addChatRoomToUser(user: User, chatRoomUID: String, chatPartner: User){
        let newUser_JSON = [
            chatRoomUID: chatPartner.UID
        ]
        
        FirebaseHelper.userChatRoomsRef(user.UID).updateChildValues(newUser_JSON)
    }
    
    static func searchUsers(searchText: String, onComplete: [User]? -> Void){
        var matchingUsers: [User]?
        FirebaseHelper.usersRef().queryOrderedByChild("lowerCaseDisplayName").queryStartingAtValue(searchText)
            .queryEndingAtValue("\(searchText)\u{f8ff}").queryLimitedToFirst(100)
            .observeEventType(.Value, withBlock: { snapshot in
                for userJSON in snapshot.children.allObjects {
                    let user = User(UID: userJSON.key
                        , email: userJSON.value["email"] as! String
                        , displayName: userJSON.value["displayName"] as! String
                        , photoUrl: userJSON.value["photoUrl"] as! String
                        , phoneNumber: userJSON.value["phoneNumber"] as! String)
                    if (matchingUsers?.append(user)) == nil {
                        matchingUsers = [user]
                    }
                }
                onComplete(matchingUsers)
            })
        onComplete(matchingUsers)
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
    
    static func chatRoomLastMessage(chatRoomUID : String) -> FIRDatabaseReference {
        return chatRoomsRef().child("\(chatRoomUID)/lastMessage")
    }
    
    static func chatRoomLastMessageTime(chatRoomUID : String) -> FIRDatabaseReference {
        return chatRoomsRef().child("\(chatRoomUID)/lastMessageTime")
    }
    
    static func getChatRoom(currUserUID:String, chatRoomUID: String, onComplete: ChatRoom -> Void ) {
        getChatRoomMemberUIDs(chatRoomUID){ chatRoomMemberUIDs in
            if let chatRoomMemberUIDs = chatRoomMemberUIDs{
                let chatPartnerUID = chatRoomMemberUIDs.filter{$0 != currUserUID}
                getUser(chatPartnerUID[0]){ user in
                    if let user = user {
                        chatRoomRef(chatRoomUID).observeSingleEventOfType(.Value, withBlock: { snapshot in
                            if let value = snapshot.value as? [String: AnyObject] {
                                onComplete(ChatRoom(UID: chatRoomUID
                                    , lastMessage: value["lastMessage"] as! String
                                    , FIRLastMessageTimeStamp: ["lastMessageTime": value["lastMessageTime"]!]
                                    , title: user.displayName
                                    , chatRoomPictureUrl: user.photoUrl))
                            } else {
                                print("Firebase ChatRoom Endpoint - null")
                            }
                        })
                    }
                }
            }
        }
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
    
    static func updateChatRoomLastMessage(chatRoomUID: String, lastMessage: String){
        chatRoomLastMessageTime(chatRoomUID).setValue(FIRServerValue.timestamp())
        chatRoomLastMessage(chatRoomUID).setValue(lastMessage)
    }
    
    static func getChangedChatRoom(chatRoomUID: String, onComplete: FIRDataSnapshot -> Void){
        chatRoomRef(chatRoomUID).observeEventType(.ChildChanged, withBlock: { snapshot in
            onComplete(snapshot)
        })
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
    
    static func getChatRoomMemberUIDs(chatRoomUID: String, onComplete: [String]? -> Void){
        chatRoomMembersRef().child(chatRoomUID).observeSingleEventOfType(.Value, withBlock: { snapshot in
            var chatRoomMemberUIDs: [String]? = nil
            if let value = snapshot.value as? [String: AnyObject] {
                chatRoomMemberUIDs = Array(value.keys)
            } else {
                print("Firebase chatRoomMemberUIDs Endpoint - null")
            }
            onComplete(chatRoomMemberUIDs)
        })
    }
}

// MARK: Friendships Endpoint
extension FirebaseHelper{
    static func friendshipsRef() -> FIRDatabaseReference {
        return ref.child("Friendships")
    }
    
    static func friendshipRef(fromUserUID: String, toUserUID: String) -> FIRDatabaseReference {
        return friendshipsRef().child("\(fromUserUID)\(toUserUID)")
    }
    
    static func friendshipFromUserRef(fromUserUID: String, toUserUID: String) -> FIRDatabaseReference {
        return friendshipRef(fromUserUID, toUserUID: toUserUID).child("fromUser")
    }
    
    static func friendshipStatusRef(fromUserUID: String, toUserUID: String) -> FIRDatabaseReference {
        return friendshipRef(fromUserUID, toUserUID: toUserUID).child("status")
    }
    
    static func getUserFriendUIDs(fromUserUID: String, onComplete: [String]? -> Void ) {
        friendshipsRef().queryOrderedByChild("fromUser").queryEqualToValue(fromUserUID)
            .observeEventType(.Value, withBlock: { snapshot in
                var friendUIDs: [String]?
                for friendshipJSON in snapshot.children.allObjects {
                    if let friendUID = friendshipJSON.value["toUser"] as? String {
                        if (friendUIDs?.append(friendUID)) == nil {
                            friendUIDs = [friendUID]
                        }
                    }
                }
                onComplete(friendUIDs)
            })
    }
    
    static func addFriendship(fromUserUID: String, toUserUID: String){
        let newFriendshipRef = friendshipsRef().child("\(fromUserUID)\(toUserUID)")
        let newFriendship_JSON = [
            "fromUser": "pending\(fromUserUID)"
            , "toUser": toUserUID
            , "status": "pending\(toUserUID)"
        ]
        newFriendshipRef.setValue(newFriendship_JSON)
    }
    
    static func removeFriendship(fromUserUID: String, toUserUID: String){
        friendshipRef(fromUserUID, toUserUID: toUserUID).removeValue()
    }
    
    static func getPendingFriendRequest(userUID: String, onComplete: [User]? -> Void ) {
        friendshipsRef().queryOrderedByChild("status").queryEqualToValue("pending\(userUID)")
            .observeEventType(.Value, withBlock: { snapshot in
                var friendRequests: [User]?
                for friendshipJSON in snapshot.children.allObjects {
                    if let friendUID = friendshipJSON.value["fromUser"] as? String {
                        getUser(friendUID.substringWithRange(Range<String.Index>(start: friendUID.startIndex.advancedBy(7), end: friendUID.endIndex))) { user in
                            if let user = user {
                                if (friendRequests?.append(user)) == nil {
                                    friendRequests = [user]
                                }
                            }
                        }
                    }
                }
                onComplete(friendRequests)
            })
    }
    
    static func acceptFriendRequest(currUserUID: String, requestingUserUID: String){
        friendshipStatusRef(requestingUserUID, toUserUID: currUserUID).setValue("accepted")
        friendshipFromUserRef(requestingUserUID, toUserUID: currUserUID).setValue(requestingUserUID)
        
        let newFriendshipRef = friendshipsRef().child("\(currUserUID)\(requestingUserUID)")
        let newFriendship_JSON = [
            "fromUser": currUserUID
            , "toUser": requestingUserUID
            , "status": "accepted"
        ]
        newFriendshipRef.setValue(newFriendship_JSON)
    }
    
    static func declineFriendRequest(currUserUID: String, requestingUserUID: String){
        removeFriendship(requestingUserUID, toUserUID: currUserUID)
    }
}

// MARK: UID Gen
extension FirebaseHelper{
    static func generateFIRUID(ref:FIRDatabaseReference) -> String {
        return ref.childByAutoId().key
    }
}

// MARK: Dev for soundclip
extension FirebaseHelper{
    static func uploadEmojiToTag(text: String) {
        FirebaseHelper.soundClipsRef().child("8/tag").updateChildValues([
            text: true
            ])
    }
}