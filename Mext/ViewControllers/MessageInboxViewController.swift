//
//  MessageInboxViewController.swift
//  Mext
//
//  Created by Alex Lee on 15/07/2016.
//  Copyright © 2016 Alex Lee. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class MessageInboxViewController: UIViewController {
    let TAG = "MessageInboxViewController"
    
    @IBOutlet weak var messageInboxTableView: UITableView!
    
    var currUser: User!
    var currUserUID: String!
    var chatRooms: [ChatRoom]! {
        didSet{
            messageInboxTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseHelper.getUserChatRoomUIDs(self.currUser.UID){ chatRoomKeys in
            
            if let chatRoomKeys = chatRoomKeys {
                for uid in chatRoomKeys {
                    FirebaseHelper.getChatRoom(uid, onComplete: { chatRoom in
                        
                        if (self.chatRooms?.append(chatRoom)) == nil {
                            self.chatRooms = [chatRoom]
                        }
                        
                        FirebaseHelper.getChangedChatRoom(chatRoom.UID){ snapshot in
                            if let index = self.chatRooms.indexOf({$0.UID == chatRoom.UID}) {
                                switch snapshot.key {
                                case "chatRoomPictureUrl": self.chatRooms[index].chatRoomPictureUrl = snapshot.value as! String
                                case "lastMessage": self.chatRooms[index].lastMessage = snapshot.value as! String
                                case "lastMessageTime": self.chatRooms[index].FIRLastMessageTimeStamp = ["lastMessageTime": snapshot.value!]
                                case "title": self.chatRooms[index].title = snapshot.value as! String
                                default: print("")
                                }
                                self.messageInboxTableView.reloadData()
                            }
                        }
                    })
                }
            } else {
                print("\(self.TAG) - No chat room")
            }
        }
        
        //print("MessageInboxViewController Email : \(currUser.email)")
        //        if let uid = currUserUID {
        //            FirebaseHelper.getUser(uid){ in
        //
        //            }
        //        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        //performSegueWithIdentifier("temp", sender: nil)
        //FirebaseHelper.searchUser("J")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "toContacts" {
                let contactsViewController = segue.destinationViewController as! ContactsViewController
                contactsViewController.currUser = currUser
            } else if identifier == "toChat" {
                let navVc = segue.destinationViewController as! UINavigationController
                let chatViewController = navVc.viewControllers.first as! ChatViewController
                chatViewController.chatRoom = chatRooms![messageInboxTableView.indexPathForSelectedRow!.row]
                chatViewController.currUser = currUser
            }
        }
    }
    
    @IBAction func unwindToMessageInboxViewController(segue: UIStoryboardSegue) {
        
    }
}

// MARK: TableView Methods
extension MessageInboxViewController: UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatRooms?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("messageInboxTableViewCell", forIndexPath: indexPath) as! MessageInboxTableViewCell
        
        let chatRoom = chatRooms[indexPath.row]
        
        cell.chatRoomTitleLabel.text = chatRoom.title
        cell.lastMessageLabel.text = chatRoom.lastMessage
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH:mm"
        cell.lastMessageTimeLabel.text = formatter.stringFromDate(chatRoom.lastMessageTime)
        cell.chatRoomImageButton.af_setImageForState(
            UIControlState.Normal
            , URL: NSURL(string: chatRoom.chatRoomPictureUrl)!
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
