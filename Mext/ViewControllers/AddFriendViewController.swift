//
//  AddFriendViewController.swift
//  Mext
//
//  Created by Alex Lee on 24/07/2016.
//  Copyright © 2016 Alex Lee. All rights reserved.
//

import UIKit
import AlamofireImage

class AddFriendViewController: UIViewController {
    @IBOutlet weak var addFriendTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var currUserUID: String! {
        return currUser.UID
    }
    var currUser: User!
    var matchingUsers: [User]? {
        didSet {
            addFriendTableView.reloadData()
        }
    }
    
    var friendUIDs: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseHelper.getUserFriendUIDs(currUserUID){ friendUIDs in
            self.friendUIDs = friendUIDs
            print(friendUIDs)
        }
        self.hideKeyboardWhenTappedAround() 
    }
    
}

// MARK: Searchbar Delegate
extension AddFriendViewController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        FirebaseHelper.searchUsers(searchText.lowercaseString){ matchingUsers in
            if let matchingUsers = matchingUsers {
                self.matchingUsers = matchingUsers.filter{$0.UID != self.currUserUID}
            }
        }
    }
}

// MARK: TableView Methods
extension AddFriendViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingUsers?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("addFriendTableViewCell", forIndexPath: indexPath) as! AddFriendTableViewCell
        
        let user = self.matchingUsers![indexPath.row]
        
        cell.user = user
        print(user.UID)
        if let friendUIDs = friendUIDs {
            cell.canFriend = !friendUIDs.contains(user.UID)
        }
        
        cell.delegate = self
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            //            notes.removeAtIndex(indexPath.row)
            //            tableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

// MARK: FriendSearchTableViewCell Delegate
extension AddFriendViewController: AddFriendTableViewCellDelegate {
    
    func cell(cell: AddFriendTableViewCell, didSelectFriendUser user: User) {
        FirebaseHelper.saveFriendship(currUserUID, toUserUID: user.UID)
        friendUIDs?.append(user.UID)
    }
    
    func cell(cell: AddFriendTableViewCell, didSelectUnfriendUser user: User) {
        FirebaseHelper.removeFriendship(currUserUID, toUserUID: user.UID)
        FirebaseHelper.removeFriendship(user.UID, toUserUID: currUserUID)
        self.friendUIDs = friendUIDs!.filter({$0 != user.UID})
    }
    
}