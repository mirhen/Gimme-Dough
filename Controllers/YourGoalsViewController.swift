//
//  YourGoalsViewController.swift
//  Dough
//
//  Created by Miriam Hendler on 8/4/16.
//  Copyright © 2016 Miriam Hendler. All rights reserved.
//

import UIKit
import RealmSwift

class YourGoalsViewController: UIViewController
{
    //--------------------------------------------------//
    
    //Interface Builder User Interface Elements
    
    //TableView Outlet
    @IBOutlet weak var goalsTableView: UITableView!
    @IBOutlet weak var addAGoalButton: UIButton!
    
    //IBActions
    @IBAction func addAGoalButtonPressed(sender: AnyObject)
    {
        self.performSegueWithIdentifier("newGoalPush", sender: self)
    }
    //If cancel button is tapped return to *YourGoalsViewController*
    @IBAction func unwindToYourGoalsViewController(segue: UIStoryboardSegue)
    {
    }
    
    //--------------------------------------------------//
    
    //Non-Interface Builder Objects
    
    //Other Objects
    var goalArray = Results<Goal>?()
        {
        didSet
        {
            goalsTableView.reloadData()
        }
    }
    //Override Functions
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.bringSubviewToFront(addAGoalButton)
        goalArray = RealmHelper.retrieveGoal()
        
        goalsTableView.delegate = self
        goalsTableView.dataSource = self
        
        goalsTableView.separatorColor = UIColor.blackColor()
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).goalArray = goalArray
        
        //Setting *goalsTableView* background to transparent
        self.goalsTableView.backgroundColor = UIColor(patternImage: UIImage(named: "cheating xcode patern.png")!)
        
        //getting rid of seperator on empy tableview cells
        self.goalsTableView.tableFooterView = UIView(frame: CGRectZero)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        goalArray = RealmHelper.retrieveGoal()

    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "newGoalPush"
        {
            print("newGoalPush")
        }
        else if segue.identifier == "editGoalsPush"
        {
            let destinationController = segue.destinationViewController as! CreateAGoalViewController
            let indexPath = goalsTableView.indexPathForSelectedRow
            
            destinationController.currentGoal = goalArray![indexPath!.row]
            
            print("editGoalsPush")
        }
    }
}

//MARK: -Table View Delegate
extension YourGoalsViewController: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return goalArray!.count
    }
//    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        
//        if editingStyle == .Delete {
//            RealmHelper.deleteGoal(goalArray![indexPath.row])
//            var t = 0.0
//            let row = goalsTableView.indexPathForSelectedRow
//            let spendingMoney = NSUserDefaults.standardUserDefaults().doubleForKey("spending")
//            t = spendingMoney + goalArray![row!.row].amountToSave
//            NSUserDefaults.standardUserDefaults().setDouble(t, forKey: "spending")
//            
//            tableView.reloadData()
//        }
//    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return self.view.frame.height/3.8
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! GoalTableViewCell
        
        if goalArray!.count != 0
        {
            let currencyFormatter = NSNumberFormatter()
            currencyFormatter.numberStyle = .CurrencyStyle
            currencyFormatter.locale = NSLocale(localeIdentifier: "es_US")
            
            cell.titleLabel.text = goalArray![indexPath.row].goalName
            cell.amoountLabel.text = "Save \(currencyFormatter.stringFromNumber(goalArray![indexPath.row].amountToSave)!)/Week"
            cell.goalImageView.image = CalendarUnitHelper.convertNSDataToUIImage(goalArray![indexPath.row].goalImage)
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsetsZero
            cell.layoutMargins = UIEdgeInsetsZero
            cell.selectionStyle = .None
            
        }
        
        return cell
    }
}
