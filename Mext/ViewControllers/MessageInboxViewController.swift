//
//  MessageInboxViewController.swift
//  Mext
//
//  Created by Alex Lee on 15/07/2016.
//  Copyright © 2016 Alex Lee. All rights reserved.
//

import UIKit

class MessageInboxViewController: UIViewController {
    let TAG = "MessageInboxViewController"
    
    @IBOutlet weak var messageInboxTableView: UITableView!
    
    var currUser: User!
    var currUserUID: String!
    var chatRooms : [ChatRoom]? {
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
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "toContacts" {
                let contactsViewController = segue.destinationViewController as! ContactsViewController
                contactsViewController.currUser = currUser
            } else if identifier == "toChat" {
                let chatViewController = segue.destinationViewController as! ChatViewController
                chatViewController.chatRoomName = chatRooms![messageInboxTableView.indexPathForSelectedRow!.row].UID
            }
        }
    }
    
}

// MARK: TableView Methods
extension MessageInboxViewController: UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatRooms?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("messageInboxTableViewCell", forIndexPath: indexPath)
        if let chatRooms = chatRooms {
            cell.textLabel?.text = chatRooms[indexPath.row].UID
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // 2
        if editingStyle == .Delete {
            //            // 3
            //            notes.removeAtIndex(indexPath.row)
            //            // 4
            //            tableView.reloadData()
        }
    }
}