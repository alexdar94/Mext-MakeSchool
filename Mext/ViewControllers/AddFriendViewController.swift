//
//  AddFriendViewController.swift
//  Mext
//
//  Created by Alex Lee on 24/07/2016.
//  Copyright © 2016 Alex Lee. All rights reserved.
//

import UIKit

class AddFriendViewController: UIViewController {
    @IBOutlet weak var addFriendTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

// MARK: TableView Methods
extension AddFriendViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("addFriendTableVIewCell", forIndexPath: indexPath) as! AddFriendTableViewCell
        
        
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