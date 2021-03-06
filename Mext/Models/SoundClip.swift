//
//  SoundClip.swift
//  Mext
//
//  Created by Alex Lee on 11/07/2016.
//  Copyright © 2016 Alex Lee. All rights reserved.
//

import Foundation

class SoundClip {

    var tag: [String]
    var text: String
    var soundFileUrl: String
    var soundName: String
    var source: String
    var favorite: Int
    var uploaderName: String
    
    init(tag: [String], text: String, soundFileUrl: String, soundName: String, source: String, favorite: Int, uploaderName: String){
        self.tag = tag
        self.text = text
        self.soundFileUrl = soundFileUrl
        self.soundName = soundName
        self.source = source
        self.favorite = favorite
        self.uploaderName = uploaderName
    }
}
