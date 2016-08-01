//
//  SoundChartViewController.swift
//  Mext
//
//  Created by Alex Lee on 01/08/2016.
//  Copyright © 2016 Alex Lee. All rights reserved.
//

import UIKit

class SoundChartViewController: UIViewController {

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
}
