//
//  MusicSuggestionTableViewCell.swift
//  Mext
//
//  Created by Alex Lee on 07/07/2016.
//  Copyright © 2016 Alex Lee. All rights reserved.
//

import UIKit

class MusicSuggestionTableViewCell: UITableViewCell {
    var playButton : UIButton!
    var songName : UILabel!
    var songArt : UIImageView!
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let gap_image : CGFloat = 5
        let gap_label : CGFloat = 9
        let labelHeight: CGFloat = 30
        let labelWidth: CGFloat = 150
        let lineGap : CGFloat = 5
        //let label2Y : CGFloat = gap + labelHeight + lineGap
        let imageSize : CGFloat = 38
        
        playButton = UIButton()
//        playButton.frame = CGRectMake(bounds.width-imageSize - gap, gap, imageSize, imageSize)
        playButton.frame = CGRectMake(gap_image, gap_image, imageSize, imageSize)
        playButton.setImage(UIImage(named: "playButton.png"), forState: UIControlState.Normal)
        //playButton.centerYAnchor.constraintEqualToAnchor(contentView.centerYAnchor).active = true
        contentView.addSubview(playButton)
        
        songName = UILabel()
        songName.frame = CGRectMake(gap_image + imageSize + gap_image, gap_label, labelWidth, labelHeight)
        songName.textColor = UIColor.blackColor()
        //songName.centerYAnchor.constraintEqualToAnchor(contentView.centerYAnchor).active = true
        //NSLayoutConstraint(item: songName, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0).active = true
        contentView.addSubview(songName)
        
//        myLabel2 = UILabel()
//        myLabel2.frame = CGRectMake(gap, label2Y, labelWidth, labelHeight)
//        myLabel2.textColor = UIColor.blackColor()
//        contentView.addSubview(myLabel2)
        
        
        
//        myButton2 = UIButton()
//        myButton2.frame = CGRectMake(bounds.width-imageSize - gap, label2Y, imageSize, imageSize)
//        myButton2.setImage(UIImage(named: "telephone.png"), forState: UIControlState.Normal)
//        contentView.addSubview(myButton2)
    }

}
