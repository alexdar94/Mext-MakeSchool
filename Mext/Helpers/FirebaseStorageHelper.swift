//
//  FirebaseStorageHelper.swift
//  Mext
//
//  Created by Alex Lee on 03/08/2016.
//  Copyright © 2016 Alex Lee. All rights reserved.
//

import Foundation
import FirebaseStorage

class FirebaseStorageHelper {
    static let storage = FIRStorage.storage()
    static let storageRef = storage.referenceForURL("gs://project-7984311037219211014.appspot.com")
}

// MARK: User Profile Picture
extension FirebaseStorageHelper {
    static let userProfilePicRef = storageRef.child("UserProfilePicture-Large")
    
    static func uploadPhoto(currUserUID: String, image: UIImage, onComplete: String -> Void){
        let imageData = UIImageJPEGRepresentation(image, 0.8)
        let imagePath = currUserUID + ".jpg"
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        self.userProfilePicRef.child(imagePath)
            .putData(imageData!, metadata: metadata) { (metadata, error) in
                if let error = error {
                    print("Error uploading: \(error)")
                    return
                }
                onComplete(metadata!.downloadURL()!.absoluteString)
        }
    }
}

// MARK: Sound Clips
extension FirebaseStorageHelper {
    static let soundClipsRef = storageRef.child("SoundClips")
    
    static func uploadSoundClips(currUserUID: String, image: UIImage, onComplete: String -> Void){
        let imageData = UIImageJPEGRepresentation(image, 0.8)
        let imagePath = currUserUID + ".jpg"
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        self.userProfilePicRef.child(imagePath)
            .putData(imageData!, metadata: metadata) { (metadata, error) in
                if let error = error {
                    print("Error uploading: \(error)")
                    return
                }
                onComplete(metadata!.downloadURL()!.absoluteString)
        }
    }
}