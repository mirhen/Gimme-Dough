 //
//  AppDelegate.swift
//  Dough
//
//  Created by Miriam Hendler on 7/18/16.
//  Copyright © 2016 Miriam Hendler. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?
    var expenseArray = Results<Expense>!() // [Expense] = []
    var goalArray = Results<Goal>!() // [Goal] = []

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        FIRApp.configure()
        
        NSUserDefaults.standardUserDefaults().setInteger(25, forKey: "Age")
        print(NSUserDefaults.standardUserDefaults().integerForKey("Age"))
        
        if isAppAlreadyLaunchedOnce()
        {
            
            if NSUserDefaults.standardUserDefaults().stringForKey("name") != nil
            {
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.window = UIWindow(frame: UIScreen.mainScreen().bounds)
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let yourVC = mainStoryboard.instantiateViewControllerWithIdentifier("TabBarViewController") as! TabBarViewController
                appDelegate.window?.rootViewController = yourVC
                appDelegate.window?.makeKeyAndVisible()

            }
        }
     //   FIRAuth.auth()?.createUserWithEmail("mjammer18@gmail.com", password: "miriam") { (user, error) in

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }



}

func isAppAlreadyLaunchedOnce() -> Bool{
    let defaults = NSUserDefaults.standardUserDefaults()
    
    if defaults.stringForKey("isAppAlreadyLaunchedOnce") != nil{
        print("App already launched")
        return true
    }else{
        defaults.setBool(true, forKey: "isAppAlreadyLaunchedOnce")
        print("App launched first time")
        return false
    }
}

func randomInteger(minimumValue: Int, maximumValue: Int) -> Int
{
    return minimumValue + Int(arc4random_uniform(UInt32(maximumValue - minimumValue + 1)))
}

func colorWithHexString (hex:String) -> UIColor
{
    var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).noWhiteSpaceLowerCaseString
    
    if (cString.hasPrefix("#"))
    {
        cString = (cString as NSString).substringFromIndex(1)
    }
    
    if (cString.characters.count != 6)
    {
        return UIColor.grayColor()
    }
    
    let rString = (cString as NSString).substringToIndex(2)
    let gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
    let bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
    
    var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0
    NSScanner(string: rString).scanHexInt(&r)
    NSScanner(string: gString).scanHexInt(&g)
    NSScanner(string: bString).scanHexInt(&b)
    
    return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
}

extension Array
{
    var shuffledValue: [Element]
    {
        var arrayElements = self
        
        for individualIndex in 0..<arrayElements.count
        {
            swap(&arrayElements[individualIndex], &arrayElements[Int(arc4random_uniform(UInt32(arrayElements.count-individualIndex)))+individualIndex])
        }
        
        return arrayElements
    }
    
    var chooseOne: Element
    {
        return self[Int(arc4random_uniform(UInt32(count)))]
    }
}

extension Int
{
    var arrayValue: [Int]
    {
        return description.characters.map{Int(String($0)) ?? 0}
    }
    
    var ordinalValue: String
        {
        get
        {
            var suffix = "th"
            switch self % 10
            {
            case 1:
                suffix = "st"
            case 2:
                suffix = "nd"
            case 3:
                suffix = "rd"
            default: ()
            }
            
            if 10 < (self % 100) && (self % 100) < 20
            {
                suffix = "th"
            }
            
            return String(self) + suffix
        }
    }
}

extension String
{
    var noWhiteSpaceLowerCaseString: String { return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).lowercaseString }
    
    var letterValue: Int
    {
        return Array("abcdefghijklmnopqrstuvwxyz".characters).indexOf(Character(lowercaseString))?.successor() ?? 0
    }
    
    var jumbledValue: String
    {
        return String(Array(arrayLiteral: self).shuffledValue)
    }
    
    var length: Int { return characters.count }
    
    func removeWhitespace() -> String
    {
        return self.stringByReplacingOccurrencesOfString(" ", withString: "")
    }
    
    func chopPrefix(countToChop: Int = 1) -> String
    {
        return self.substringFromIndex(self.startIndex.advancedBy(characters.count - countToChop))
    }
    
    func chopSuffix(countToChop: Int = 1) -> String
    {
        return self.substringToIndex(self.startIndex.advancedBy(characters.count - countToChop))
    }
}