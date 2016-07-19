//
//  NewChatViewController.swift
//  Mext
//
//  Created by Alex Lee on 18/07/2016.
//  Copyright © 2016 Alex Lee. All rights reserved.
//

import UIKit

class NewChatViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        //performSegueWithIdentifier("temp", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "createNewChat" {
                let newChatRoomUID = FirebaseHelper.generateFIRUID(FirebaseHelper.chatRoomsRef())
                let newChatRoom = ChatRoom(UID:newChatRoomUID, title: "tapped_UserDisplayName",chatRoomPictureUrl: "tapped_UserPhotoUrl")
                
                FirebaseHelper.saveNewChatRoom(newChatRoomUID, newChatRoom: newChatRoom)
                FirebaseHelper.saveNewChatRoomMemberRelationship(newChatRoomUID, userUID: "1")
                FirebaseHelper.saveNewChatRoomMemberRelationship(newChatRoomUID, userUID: "2")
                
                let chatViewController = segue.destinationViewController as! ChatViewController
                
                chatViewController.chatRoomName = newChatRoomUID
            }
        }
    }
}

// MARK: TableView Methods
extension NewChatViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("contactsTableViewCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = "User \(indexPath.row)"
        
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            //            notes.removeAtIndex(indexPath.row)
            //            tableView.reloadData()
        }
    }
}