//
//  FriendRequestViewController.swift
//  Mext
//
//  Created by Alex Lee on 03/08/2016.
//  Copyright © 2016 Alex Lee. All rights reserved.
//

import UIKit
import AlamofireImage

class FriendRequestViewController: UIViewController {
    @IBOutlet weak var friendRequestTableView: UITableView!

    var currUser: User!
    var friendRequests: [User]? {
        didSet{
            friendRequestTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseHelper.getPendingFriendRequest(currUser.UID){ users in
            self.friendRequests = users
        }
    }
}

extension FriendRequestViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friendRequests?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("friendRequestTableViewCell", forIndexPath: indexPath) as! FriendRequestTableViewCell
        
        cell.row = indexPath.row
        let friendRequest = friendRequests![indexPath.row]
        cell.displayNameLabel.text = friendRequest.displayName
        
        let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
            size: cell.profilePictureImageView.frame.size,
            radius: 22.0
        )
        
        cell.profilePictureImageView.af_setImageWithURL(
            NSURL(string: friendRequest.photoUrl)!,
            placeholderImage: UIImage(named: "nobody_m.original")!,
            filter: filter
        )
        
        cell.delegate = self
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

// MARK: FriendSearchTableViewCell Delegate
extension FriendRequestViewController: FriendRequestTableViewCellDelegate {
    
    func cell(cell: FriendRequestTableViewCell, didTapAccept row: Int) {
        FirebaseHelper.acceptFriendRequest(currUser.UID, requestingUserUID: friendRequests![row].UID)
        friendRequests?.removeAtIndex(row)
    }
    
    func cell(cell: FriendRequestTableViewCell, didTapDecline row: Int) {
        FirebaseHelper.declineFriendRequest(currUser.UID, requestingUserUID: friendRequests![row].UID)
        friendRequests?.removeAtIndex(row)
    }
    
}