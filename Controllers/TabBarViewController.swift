//
//  TabBarViewController.swift
//  Dough
//
//  Created by Miriam Hendler on 8/6/16.
//  Copyright © 2016 Miriam Hendler. All rights reserved.
//

import UIKit
import BFPaperTabBarController

class TabBarViewController: BFPaperTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.tintColor = colorWithHexString("#F69C34")
        // set the tab bar tint color to something cool.
        self.rippleFromTapLocation = true
        // YES = spawn tap-circles from tap locaiton. NO = spawn tap-circles from the center of the tab.
        self.usesSmartColor = true
        // YES = colors are chosen from the tabBar.tintColor. NO = colors will be shades of gray.
        self.tapCircleColor = UIColor.grayColor().colorWithAlphaComponent(0.4)
        // Set this to customize the tap-circle color.
        //        self.backgroundFadeColor = UIColor.purpleColor()
        // Set this to customize the background fade color.
        self.tapCircleDiameter = bfPaperTabBarController_tapCircleDiameterSmall
        // Set this to customize the tap-circle diameter.
        self.underlineColor = colorWithHexString("#F69C34")
        // Set this to customize the color of the underline which highlights the currently selected tab.
        self.animateUnderlineBar = true
        self.underlineThickness = 4.0
        // YES = bar slides below tabs to the selected one. NO = bar appears below selected tab instantaneously.
        // Do any additional setup after loading the view.
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.blackColor()], forState:.Normal)
       // self.tabBar.barTintColor = UIColor.blackColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
