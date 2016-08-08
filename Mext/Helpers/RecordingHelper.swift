//
//  RecordingHelper.swift
//  Mext
//
//  Created by Alex Lee on 06/08/2016.
//  Copyright © 2016 Alex Lee. All rights reserved.
//

import Foundation
import UIKit
import MediaPlayer
import AVFoundation

typealias RecordingHelperCallback = MPMediaItem? -> Void

class RecordingHelper: NSObject {
    
    weak var viewController: UIViewController!
    var callback: RecordingHelperCallback
    var mediaPicker: MPMediaPickerController?
    
    init(viewController: UIViewController, callback: RecordingHelperCallback) {
        self.viewController = viewController
        self.callback = callback
        
        super.init()
        
        showPhotoSourceSelection()
    }
    
    func showPhotoSourceSelection() {
        let alertController = UIAlertController(title: nil, message: "Choose soundclip from", preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let musicLibraryAction = UIAlertAction(title: "Add from Music Library", style: .Default) { (action) in
            self.mediaPicker = MPMediaPickerController(mediaTypes: .AnyAudio)
            self.mediaPicker!.delegate = self
            self.viewController.presentViewController(self.mediaPicker!, animated: true, completion: {})
        }
        
        alertController.addAction(musicLibraryAction)
        
//        if (UIImagePickerController.isCameraDeviceAvailable(.Rear)) {
//            let cameraAction = UIAlertAction(title: "Record a sound", style: .Default) { (action) in
//                self.showImagePickerController(.Camera)
//            }
//            
//            alertController.addAction(cameraAction)
//        }
        
        viewController.presentViewController(alertController, animated: true, completion: nil)
    }
    
}

extension RecordingHelper: MPMediaPickerControllerDelegate, AVAudioPlayerDelegate {
    
    func mediaPicker(mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        //User selected a/an item(s).
        for mpMediaItem in mediaItemCollection.items {
            //print("Add \(mpMediaItem) to a playlist, prep the player, etc.")
            callback(mpMediaItem)
        }
    }
    
    func mediaPickerDidCancel(mediaPicker: MPMediaPickerController) {
        viewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
}