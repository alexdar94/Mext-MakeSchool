//
//  SoundClip.swift
//  Mext
//
//  Created by Alex Lee on 11/07/2016.
//  Copyright © 2016 Alex Lee. All rights reserved.
//

import Foundation
import Parse

class SoundClip : PFObject, PFSubclassing {

    @NSManaged var tag: String?
    @NSManaged var text: String?
    @NSManaged var soundFile: PFFile?
    @NSManaged var soundName: String?
    @NSManaged var source: String?
    
    //MARK: PFSubclassing Protocol
    
    static func parseClassName() -> String {
        return "SoundClip"
    }
    
    override init () {
        super.init()
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            // inform Parse about this subclass
            self.registerSubclass()
        }
    }
    
    
}
