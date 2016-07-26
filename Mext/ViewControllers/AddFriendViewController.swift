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
    
    var matchingUsers: [User]? {
        didSet {
            addFriendTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

// MARK: Searchbar Delegate
extension AddFriendViewController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        FirebaseHelper.searchUsers(searchText.lowercaseString){ matchingUsers in
            if let matchingUsers = matchingUsers {
                self.matchingUsers = matchingUsers
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
        cell.displayNameLabel.text = user.displayName
        
        let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
            size: cell.profilePictureImageView.frame.size,
            radius: 22.0
        )
        
        cell.profilePictureImageView.af_setImageWithURL(
            NSURL(string: user.photoUrl)!,
            placeholderImage: UIImage(named: "nobody_m.original")!,
            filter: filter
        )
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            //            notes.removeAtIndex(indexPath.row)
            //            tableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}