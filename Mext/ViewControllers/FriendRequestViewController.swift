//
//  FriendRequestViewController.swift
//  Mext
//
//  Created by Alex Lee on 03/08/2016.
//  Copyright © 2016 Alex Lee. All rights reserved.
//

import UIKit

class FriendRequestViewController: UIViewController {

}

extension FriendRequestViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("friendRequestTableViewCell", forIndexPath: indexPath) as! FriendRequestTableViewCell
        
        cell.displayNameLabel.text = "Muji \(indexPath.row)"
        
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
