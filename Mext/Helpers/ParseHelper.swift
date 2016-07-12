//
//  ParseHelper.swift
//  Mext
//
//  Created by Alex Lee on 11/07/2016.
//  Copyright © 2016 Alex Lee. All rights reserved.
//

import Foundation
import Parse

class ParseHelper {
    // Sound Clip class
    static let PARSESOUNDCLIP         = "SoundClip"
    static let PARSESOUNDCLIP_TAG     = "tag"
    
    static func searchSoundClips(searchText: String, completionBlock: PFQueryArrayResultBlock) -> PFQuery {
        let query = SoundClip.query()
        query!.whereKey(PARSESOUNDCLIP_TAG, equalTo:searchText)
        query!.findObjectsInBackgroundWithBlock(completionBlock)
        return query!
    }
}

extension PFObject {
    
    public override func isEqual(object: AnyObject?) -> Bool {
        if (object as? PFObject)?.objectId == self.objectId {
            return true
        } else {
            return super.isEqual(object)
        }
    }
    
}