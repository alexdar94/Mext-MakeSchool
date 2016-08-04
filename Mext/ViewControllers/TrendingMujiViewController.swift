//
//  TrendingMujiViewController.swift
//  Mext
//
//  Created by Alex Lee on 03/08/2016.
//  Copyright © 2016 Alex Lee. All rights reserved.
//

import UIKit

class TrendingMujiViewController: UIViewController {

}

extension TrendingMujiViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("trendingTableViewCell", forIndexPath: indexPath) as! TrendingTableViewCell
        
        cell.soundNameLabel.text = "Muji \(indexPath.row)"
        cell.soundByLabel.text = "by Mext"
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
