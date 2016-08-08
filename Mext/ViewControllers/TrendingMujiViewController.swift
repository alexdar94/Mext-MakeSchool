//
//  TrendingMujiViewController.swift
//  Mext
//
//  Created by Alex Lee on 03/08/2016.
//  Copyright © 2016 Alex Lee. All rights reserved.
//

import UIKit

class TrendingMujiViewController: UIViewController {

    @IBOutlet weak var trendingTableView: UITableView!
    var trendingSoundClips: [SoundClip]?{
        didSet{
            trendingTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FirebaseHelper.getTrendingSoundClip(){soundClips in
            if let soundClips = soundClips {
                self.trendingSoundClips = soundClips.reverse()
            }
        }
        
    }
    
}

extension TrendingMujiViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trendingSoundClips?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("trendingTableViewCell", forIndexPath: indexPath) as! TrendingTableViewCell
        
        cell.soundNameLabel.text = trendingSoundClips![indexPath.row].soundName
        cell.soundByLabel.text = "uploaded by \(trendingSoundClips![indexPath.row].uploaderName)"
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        MusicPlayerHelper.playSoundClipFromUrl(trendingSoundClips![indexPath.row].soundFileUrl)
    }
}
