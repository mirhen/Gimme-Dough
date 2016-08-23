//
//  ExpensesTableViewController.swift
//  Dough
//
//  Created by Miriam Hendler on 7/18/16.
//  Copyright © 2016 Miriam Hendler. All rights reserved.
//

import UIKit
import RealmSwift

class ETVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    //--------------------------------------------------//
    
    //Interface Builder User Interface Elements
    
    @IBOutlet weak var amountOfMoneyButton: UIButton!
    @IBOutlet weak var amountTableView: UITableView!
    
    //--------------------------------------------------//
    
    //Non-Interface Builder Objects
    
    //Other Objects
    var balanceDictionary: [Int : Double] = [:]
    var totalBalance = 0.0
    var totalTimeUnit: Int = 0
    var savedArray = "SavedArray"
    let realm = try! Realm()
    let formmater = NSNumberFormatter()
    var last = Expense?()
    var tableViewExpenses: [Expense] = []
    var expenseArray = Results<Expense>?()
        {
        didSet
        {
            tableViewExpenses.removeAll()
            var temp = realm.objects(Expense)
            let arrayTmp = Array(temp)
            tableViewExpenses = arrayTmp as! [Expense]
            if tableViewExpenses.last?.expenseName != "credit"
            {
            var last = tableViewExpenses.last
            tableViewExpenses.removeLast()
                tableViewExpenses.insert(last!, atIndex: 0)
            }
            amountTableView.reloadData()
        }
    }
    
    @IBAction func editAmountOfMoneyButtonPressed(sender: AnyObject)
    {
        self.performSegueWithIdentifier("moneyEarnedSegue", sender: self)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        formmater.numberStyle = .CurrencyStyle

        if NSUserDefaults.standardUserDefaults().doubleForKey("totalBalance") != 0
        {
            totalBalance = NSUserDefaults.standardUserDefaults().doubleForKey("totalBalance")
            totalTimeUnit = NSUserDefaults.standardUserDefaults().integerForKey("timeUnit")
        }
        
        //Setting *amountTableView* background to transparent
        self.amountTableView.backgroundColor = UIColor(patternImage: UIImage(named: "cheating xcode patern.png")!)
        
        //getting rid of seperator on empy tableview cells
//        self.amountTableView.tableFooterView = UIView(frame: CGRectZero)
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        amountTableView.delegate = self
        amountTableView.dataSource = self
        amountTableView.separatorColor = UIColor.blackColor()
        amountOfMoneyButton.setTitle(String(formmater.stringFromNumber(0)!.characters.first!), forState: .Normal)
        
        let firstExpense = Expense()
        firstExpense.amountOfMoney = 0
        firstExpense.expenseName = "groceries"
        firstExpense.itemTag = randomInteger(1, maximumValue: 9999)
        firstExpense.timeUnit = 1
        firstExpense.expenseImage = UIImagePNGRepresentation(UIImage(named: "groceries image.jpg")!)!
        
        let secondExpense = Expense()
        secondExpense.amountOfMoney = 0
        secondExpense.expenseName = "rent"
        secondExpense.itemTag = randomInteger(1, maximumValue: 9999)
        secondExpense.timeUnit = 1
        secondExpense.expenseImage = UIImagePNGRepresentation(UIImage(named: "rent image.jpg")!)!
        
        let thirdExpense = Expense()
        thirdExpense.amountOfMoney = 0
        thirdExpense.expenseName = "health insurance"
        thirdExpense.itemTag = randomInteger(1, maximumValue: 9999)
        thirdExpense.timeUnit = 1
        thirdExpense.expenseImage = UIImagePNGRepresentation(UIImage(named: "health insurance.jpg")!)!
        
        let fourthExpense = Expense()
        fourthExpense.amountOfMoney = 0
        fourthExpense.expenseName = "gym"
        fourthExpense.itemTag = randomInteger(1, maximumValue: 9999)
        fourthExpense.timeUnit = 1
        fourthExpense.expenseImage = UIImagePNGRepresentation(UIImage(named: "gym image.jpg")!)!
        
        let sixthExpense = Expense()
        sixthExpense.amountOfMoney = 0
        sixthExpense.expenseName = "subscription"
        sixthExpense.itemTag = randomInteger(1, maximumValue: 9999)
        sixthExpense.timeUnit = 1
        sixthExpense.expenseImage = UIImagePNGRepresentation(UIImage(named: "subscription image.jpg")!)!
        
        let seventhExpense = Expense()
        seventhExpense.amountOfMoney = 0
        seventhExpense.expenseName = "gas"
        seventhExpense.itemTag = randomInteger(1, maximumValue: 9999)
        seventhExpense.timeUnit = 1
        seventhExpense.expenseImage = UIImagePNGRepresentation(UIImage(named: "car image.jpg")!)!
        
        let eighthExpense = Expense()
        eighthExpense.amountOfMoney = 0
        eighthExpense.expenseName = "electricity"
        eighthExpense.itemTag = randomInteger(1, maximumValue: 9999)
        eighthExpense.timeUnit = 1
        eighthExpense.expenseImage = UIImagePNGRepresentation(UIImage(named: "electricity image.jpg")!)!
        
        let ninthExpense = Expense()
        ninthExpense.amountOfMoney = 0
        ninthExpense.expenseName = "credit"
        ninthExpense.itemTag = randomInteger(1, maximumValue: 9999)
        ninthExpense.timeUnit = 1
        ninthExpense.expenseImage = UIImagePNGRepresentation(UIImage(named: "credit image.jpg")!)!
        
        let fifthExpenses = Expense()
        fifthExpenses.amountOfMoney = 0
        fifthExpenses.expenseName = "phone"
        fifthExpenses.itemTag = randomInteger(1, maximumValue: 9999)
        fifthExpenses.timeUnit = 1
        fifthExpenses.expenseImage = UIImagePNGRepresentation(UIImage(named: "phone image.jpg")!)!

        
        
        
        print("expenseArray- \(expenseArray)")
        
        if RealmHelper.retrieveExpense().count == 0
        {
            RealmHelper.addExpense(firstExpense)
            RealmHelper.addExpense(secondExpense)
            RealmHelper.addExpense(thirdExpense)
            RealmHelper.addExpense(fourthExpense)
            RealmHelper.addExpense(fifthExpenses)
            RealmHelper.addExpense(sixthExpense)
            RealmHelper.addExpense(seventhExpense)
            RealmHelper.addExpense(eighthExpense)
            RealmHelper.addExpense(ninthExpense)

        }
        expenseArray = RealmHelper.retrieveExpense()
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).expenseArray = expenseArray
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        let defaults = NSUserDefaults.standardUserDefaults()
        if totalBalance != 0
        {
//            tableViewExpenses.removeAll()
//            tableViewExpenses = Array(arrayLiteral: expenseArray)
//            expenseArray = RealmHelper.retrieveExpense()
//
//            let array = Array(arrayLiteral: expenseArray)
        
            if defaults.doubleForKey("totalBalance") == 0
            {
                amountOfMoneyButton.setTitle(String(formmater.stringFromNumber(0)!.characters.first!) + String(), forState: .Normal)
            }
            else
            {
                totalBalance = CalendarUnitHelper.convertToBalancePerWeek(defaults.integerForKey("timeUnit"), amountOfMoney: defaults.doubleForKey("totalBalance"))
                let formatter = NSNumberFormatter()
                formatter.numberStyle = .CurrencyStyle
                
                amountOfMoneyButton.setTitle(formatter.stringFromNumber(totalBalance)!, forState: .Normal)
            }
        }
        
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return expenseArray!.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return self.view.frame.height/4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! MoneyTableViewCell
                
        cell.titleLabel.text = tableViewExpenses[indexPath.row].expenseName ?? "title"
        var money = CalendarUnitHelper.convertToFormattedDouble(tableViewExpenses[indexPath.row].amountOfMoney)
        money = CalendarUnitHelper.convertToBalancePerWeek(tableViewExpenses[indexPath.row].timeUnit, amountOfMoney: money)
        
        let currencyFormatter = NSNumberFormatter()
        currencyFormatter.numberStyle = .CurrencyStyle
        currencyFormatter.locale = NSLocale(localeIdentifier: "es_US")
        
        
        cell.moneyAmountLabel.text = "\(currencyFormatter.stringFromNumber(money)!) / Week"
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        cell.expenseImageView.image = CalendarUnitHelper.convertNSDataToUIImage(tableViewExpenses[indexPath.row].expenseImage)
        
        return cell
    }
//    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
//    {
//        if editingStyle == .Delete
//        {
//            RealmHelper.deleteExpense(tableViewExpenses[indexPath.row])
//            expenseArray = RealmHelper.retrieveExpense()
//            tableView.reloadData()
//        }
//    }
    
    @IBAction func unwindToListNotesViewController(segue: UIStoryboardSegue)
    {
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "editExpensesPush"
        {
            let destinationController = segue.destinationViewController as! AOEC
            let indexPath = amountTableView.indexPathForSelectedRow
            
            destinationController.currentExpense = tableViewExpenses[indexPath!.row]
            
            print("editExpensesPush")
        }
        else if segue.identifier == "newExpensePush"
        {
            print("newExpensePush")
        }
        else if segue.identifier == "moneyEarnedSegue" || segue.identifier == "totalMoneySegue"
        {
            let destinationController = segue.destinationViewController as! AmountOfMoney
            
            if totalBalance != 0.0
            {
                destinationController.testBalance = CalendarUnitHelper.convertToBalancePerWeek(totalTimeUnit, amountOfMoney: totalBalance)
            }
            print("moneyEarnedSegue")
        }
    }
}