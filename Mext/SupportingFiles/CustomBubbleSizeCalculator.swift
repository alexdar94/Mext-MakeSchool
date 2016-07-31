//
//  CustomBubbleSizeCalculator.swift
//  Mext
//
//  Created by Alex Lee on 30/07/2016.
//  Copyright © 2016 Alex Lee. All rights reserved.
//

import Foundation
import UIKit
import JSQMessagesViewController

class CustomBubbleSizeCalculator: JSQMessagesBubblesSizeCalculator{
    override func messageBubbleSizeForMessageData(messageData: JSQMessageData!, atIndexPath indexPath: NSIndexPath!, withLayout layout: JSQMessagesCollectionViewFlowLayout!) -> CGSize {
        var size: CGSize = super.messageBubbleSizeForMessageData(messageData, atIndexPath: indexPath, withLayout: layout)
        // return size; //this would fix the problem but I lose my custom sizes
        size.height = 108.0
        return size
    }
}