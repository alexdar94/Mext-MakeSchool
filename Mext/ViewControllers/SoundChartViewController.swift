//
//  SoundChartViewController.swift
//  Mext
//
//  Created by Alex Lee on 01/08/2016.
//  Copyright © 2016 Alex Lee. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation

class SoundChartViewController: UIViewController {
    var recordingHelper: RecordingHelper?

    @IBOutlet weak var mySoundsContainer: UIView!
    @IBOutlet weak var trendingSoundsContainer: UIView!
    
    @IBAction func onSegmentChanged(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            UIView.animateWithDuration(0.5, animations: {
                self.trendingSoundsContainer.alpha = 1
                self.mySoundsContainer.alpha = 0
            })
        } else {
            UIView.animateWithDuration(0.5, animations: {
                self.trendingSoundsContainer.alpha = 0
                self.mySoundsContainer.alpha = 1
            })
        }
    }
    
    @IBAction func didTapRecord(sender: AnyObject) {
        recordingHelper = RecordingHelper(viewController: self) { (sounds: MPMediaItemCollection?) in
            //print(sound)
            //print(sounds![0]?.)
            var appMusicPlayer: MPMusicPlayerController = MPMusicPlayerController.applicationMusicPlayer()
            appMusicPlayer.setQueueWithItemCollection(sounds!)
            appMusicPlayer.play()
            
//            var item: MPMediaItem = collection.items()[0]
//            var url: NSURL = item(valueForProperty: MPMediaItemPropertyAssetURL)
//            self.dismissModalViewControllerAnimated(true)
            // Play the item using AVPlayer
//            var playerItem: AVPlayerItem = AVPlayerItem(URL: url)
//            var player: AVPlayer = AVPlayer(playerItem: playerItem)
//            player.play()
        }
    }
}
