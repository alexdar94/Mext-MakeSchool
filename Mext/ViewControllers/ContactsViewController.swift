//
//  NewChatViewController.swift
//  Mext
//
//  Created by Alex Lee on 18/07/2016.
//  Copyright © 2016 Alex Lee. All rights reserved.
//

import UIKit
import Firebase
import AlamofireImage

class ContactsViewController: UIViewController {
    let TAG = "ContactsViewController"
    
    @IBOutlet weak var contactsTableView: UITableView!
    
    var currUser: User!
    var friends: [User]! {
        didSet{
            contactsTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseHelper.getUserFriendUIDs(self.currUser.UID){ friendKeys in
            if let friendKeys = friendKeys {
                for uid in friendKeys {
                    FirebaseHelper.getUser(uid, onComplete: { user in
                        guard let friend = user else {return}
                        
                        if (self.friends?.append(friend)) == nil {
                            self.friends = [friend]
                        }
                    })
                }
            } else {
                print("\(self.TAG) - No chat room")
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        //performSegueWithIdentifier("temp", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "createNewChat" {
                let newChatRoomUID = FirebaseHelper.generateFIRUID(FirebaseHelper.chatRoomsRef())
                let userTapped = friends[contactsTableView.indexPathForSelectedRow!.row]
                let newChatRoom = ChatRoom(UID:newChatRoomUID, lastMessage: "",FIRLastMessageTimeStamp: FIRServerValue.timestamp(), title: userTapped.displayName, chatRoomPictureUrl: userTapped.photoUrl)
                FirebaseHelper.saveNewChatRoom(newChatRoomUID, newChatRoom: newChatRoom)
                FirebaseHelper.saveNewChatRoomMemberRelationship(newChatRoomUID, userUID: "1")
                FirebaseHelper.saveNewChatRoomMemberRelationship(newChatRoomUID, userUID: "2")
                FirebaseHelper.addChatRoomToUser(currUser, chatRoomUID: newChatRoomUID)
                let navVc = segue.destinationViewController as! UINavigationController
                let chatViewController = navVc.viewControllers.first as! ChatViewController
                
                chatViewController.chatRoom = newChatRoom
            }
        }
    }
}

// MARK: TableView Methods
extension ContactsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friends?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("contactTableViewCell", forIndexPath: indexPath) as! ContactTableViewCell
        
        let friend = friends[indexPath.row]
        cell.userDisplayNameLabel.text = friend.displayName
        cell.profileImageButton.af_setImageForState(
            UIControlState.Normal
            , URL: NSURL(string: friend.photoUrl)!
            , placeHolderImage: UIImage(named: "nobody_m.original")!)
        
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            //            notes.removeAtIndex(indexPath.row)
            //            tableView.reloadData()
        }
    }
}