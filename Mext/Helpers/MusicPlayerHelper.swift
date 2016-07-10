//
//  MusicPlayerHelper.swift
//  Mext
//
//  Created by Alex Lee on 09/07/2016.
//  Copyright © 2016 Alex Lee. All rights reserved.
//

import Foundation
import AVFoundation
import Parse

class MusicPlayerHelper {
    //static var player: AVAudioPlayer?
    static var audioPlayer: AVPlayer?
    //    static func playSound() {
    //        //let url = NSBundle.mainBundle().URLForResource("soundName", withExtension: "mp3")!
    //
    //        do {
    //
    //
    //            //player.prepareToPlay()
    //            //player.play()
    //
    //            let url = "http://mext.herokuapp.com/parse/files/mext/d095a1b1d0d5c71cebd36921ef93df15_hello-its-me.mp3"
    //            player = try AVAudioPlayer(contentsOfURL: url)
    //            guard let player = player else { return }
    //            let fileURL = NSURL(string:url)
    //            let soundData = NSData(contentsOfURL:fileURL!)
    //            self.player = try AVAudioPlayer(data: soundData!)
    //            player.prepareToPlay()
    //            player.volume = 1.0
    //            player.play()
    //        } catch let error as NSError {
    //            print(error.description)
    //        }
    //    }
    
    static func grabSong() {
        let songQuery = PFQuery(className: "Hello")
        songQuery.getObjectInBackgroundWithId("RDmiZCBECP", block: {
            (object: PFObject?, error:NSError?) -> Void in
            if let audioFileTemp: PFFile = object?.valueForKey("musicFile") as? PFFile {
                audioPlayer = AVPlayer(URL: NSURL(string: audioFileTemp.url!)!)
                audioPlayer!.play()
            }
        })
    }
    
//    static func searchSongs(searchText: String, completionBlock: PFQueryArrayResultBlock) -> PFQuery {
//        /*
//         NOTE: We are using a Regex to allow for a case insensitive compare of usernames.
//         Regex can be slow on large datasets. For large amount of data it's better to store
//         lowercased username in a separate column and perform a regular string compare.
//         */
//        let query = PFUser.query()!.whereKey(ParseHelper.ParseUserUsername,
//                                             matchesRegex: searchText, modifiers: "i")
//        
//        query.whereKey(ParseHelper.ParseUserUsername,
//                       notEqualTo: PFUser.currentUser()!.username!)
//        
//        query.orderByAscending(ParseHelper.ParseUserUsername)
//        query.limit = 20
//        
//        query.findObjectsInBackgroundWithBlock(completionBlock)
//        
//        return query
//    }

}
