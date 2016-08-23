//
//  AmountOfMoney.swift
//  Dough
//
//  Created by Miriam Hendler on 7/18/16.
//  Copyright © 2016 Miriam Hendler. All rights reserved.
//

import UIKit
import RealmSwift

class AmountOfMoney: UIViewController
{
    
    @IBOutlet weak var moneyEarnedTextField: UITextField!
    @IBOutlet weak var moneyImageView: UIImageView!
    @IBOutlet weak var cancelButton: UIButton!
    
    var testBalance: Double = 0
    var timeUnit: Int = 0
    var t: Double = 0.0
    let formmater = NSNumberFormatter()
    
    //UIViews
    @IBOutlet weak var dayView: UIView!
    @IBOutlet weak var weekView: UIView!
    @IBOutlet weak var monthView: UIView!
    @IBOutlet weak var yearView: UIView!
    
    //Action Objects
    @IBAction func cancelButtonPressed(sender: AnyObject) {
    }
    @IBAction func saveButton(sender: AnyObject)
    {
        self.view.endEditing(true)
        if moneyEarnedTextField.text != String(formmater.stringFromNumber(0)!.characters.first!) || moneyEarnedTextField.text != formmater.stringFromNumber(0)
        {
            testBalance = Double(moneyEarnedTextField.text!.stringByReplacingOccurrencesOfString(String(formmater.stringFromNumber(0)!.characters.first!), withString: ""))!
            var timeUnitString = ""
            if dayView.hidden == false
            {
                timeUnit = 0
                timeUnitString = "Day"
            }
            else if weekView.hidden == false
            {
                timeUnit = 1
                timeUnitString = "Week"
            }
            else if monthView.hidden == false
            {
                timeUnit = 2
                timeUnitString = "Month"
            }
            else
            {
                timeUnit = 3
                timeUnitString = "Year"
            }
            
            
            let expenseArray = RealmHelper.retrieveExpense()
            
            for individualObject in expenseArray
            {
                t += individualObject.amountOfMoney
            }
            
            if CalendarUnitHelper.convertToBalancePerWeek(timeUnit, amountOfMoney: testBalance) < t
            {
                let alertViewController = UIAlertController(title: "Uh Oh!", message: "\(formmater.stringFromNumber(testBalance))/\(timeUnitString) isn't enough to cover your expense amount of $\(t)/Week", preferredStyle: .Alert)
                let cancelAction = UIAlertAction(title: "Ok :(", style: .Cancel, handler: nil)
                alertViewController.addAction(cancelAction)
                
                self.presentViewController(alertViewController, animated: true, completion: {
                    print("presenting alert view")
                })
            }
            else
            {
                
                let defaults = NSUserDefaults.standardUserDefaults()
//                testBalance = CalendarUnitHelper.convertToBalancePerWeek(timeUnit, amountOfMoney: testBalance)
                defaults.setDouble(testBalance, forKey: "totalBalance")
                defaults.setInteger(timeUnit, forKey: "timeUnit")
                
                testBalance = defaults.doubleForKey("totalBalance")
                timeUnit = defaults.integerForKey("timeUnit")

                if isAppAlreadyLaunchedOnce()
                {
                    self.performSegueWithIdentifier("firstTimeTotalAmount", sender: self)
                }
                else
                {
                    (self.presentingViewController?.childViewControllers[0] as! ETVC).totalBalance = testBalance
                    (self.presentingViewController?.childViewControllers[0] as! ETVC).totalTimeUnit = timeUnit
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
        }
    }
    @IBAction func dayButtonPressed(sender: AnyObject) {
        dayView.hidden = false
        monthView.hidden = true
        weekView.hidden = true
        yearView.hidden = true
    }
    
    @IBAction func weekButtonPressed(sender: AnyObject)
    {
        dayView.hidden = true
        monthView.hidden = true
        weekView.hidden = false
        yearView.hidden = true
    }
    
    @IBAction func monthButtonPressed(sender: AnyObject)
    {
        dayView.hidden = true
        monthView.hidden = false
        weekView.hidden = true
        yearView.hidden = true
    }
    
    @IBAction func yearButtonPressed(sender: AnyObject)
    {
        dayView.hidden = true
        monthView.hidden = true
        weekView.hidden = true
        yearView.hidden = false
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        NSUserDefaults.standardUserDefaults().setInteger(100, forKey: "yo")
        dayView.hidden = true
        monthView.hidden = true
        weekView.hidden = false
        yearView.hidden = true
        
        formmater.numberStyle = .CurrencyStyle
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(AmountOfMoney.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
//                NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
//                NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }
    //movie up whole view when keyboard appears
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
            else {
                
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height
            }
            else {
                
            }
        }
    }

    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if isAppAlreadyLaunchedOnce()
        {
            cancelButton.hidden = false
        }
        else
        {
            cancelButton.hidden = true
        }
        
        moneyEarnedTextField.addTarget(self, action: #selector(AmountOfMoney.textFieldDidChange(_:)), forControlEvents: .EditingChanged)
        moneyEarnedTextField.tag = 100
        
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(detectTextFieldState), userInfo: nil, repeats: true)
        
        if NSUserDefaults.standardUserDefaults().doubleForKey("totalBalance") != 0.0
        {
            moneyEarnedTextField.text = "\(formmater.stringFromNumber(NSUserDefaults.standardUserDefaults().doubleForKey("totalBalance"))!)" ?? "\(formmater.stringFromNumber(0))"
        }
        
        if NSUserDefaults.standardUserDefaults().integerForKey("timeUnit") == 0
        {
            dayView.hidden = false
            weekView.hidden = true
            monthView.hidden = true
            yearView.hidden = true
        }
        else if NSUserDefaults.standardUserDefaults().integerForKey("timeUnit") == 1
        {
            dayView.hidden = true
            weekView.hidden = false
            monthView.hidden = true
            yearView.hidden = true
        }
        else if NSUserDefaults.standardUserDefaults().integerForKey("timeUnit") == 2
        {
            dayView.hidden = true
            weekView.hidden = true
            monthView.hidden = false
            yearView.hidden = true
        }
        else if NSUserDefaults.standardUserDefaults().integerForKey("timeUnit") == 3
        {
            dayView.hidden = true
            weekView.hidden = true
            monthView.hidden = true
            yearView.hidden = false
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "cancel"
        {
            self.dismissViewControllerAnimated(true, completion: nil)
            print("cancel button tapped")
        }
        if segue.identifier == "firstTimeTotalAmount"
        {
            let destination = segue.destinationViewController as! TabBarViewController
            print("first time going to expenses table view controller!")
        }
    }
}

extension AmountOfMoney : UITextFieldDelegate
{
    func detectTextFieldState()
    {
        if moneyEarnedTextField.editing == true
        {
            let desiredPosition = moneyEarnedTextField.endOfDocument
            moneyEarnedTextField.selectedTextRange = moneyEarnedTextField.textRangeFromPosition(desiredPosition, toPosition: desiredPosition)
            
            textFieldDidChange(moneyEarnedTextField)
        }
    }
    
    func textFieldDidChange(textField: UITextField)
    {
        textField.text! = textField.text!.stringByReplacingOccurrencesOfString(String(formmater.stringFromNumber(0)!.characters.first!), withString: "").stringByReplacingOccurrencesOfString(",", withString: "")
        
        if !textField.text!.hasPrefix(String(formmater.stringFromNumber(0)!.characters.first!))
        {
            textField.text = String(formmater.stringFromNumber(0)!.characters.first!) + textField.text!
        }
        
        if textField.text!.containsString(".") && !textField.text!.hasSuffix(".")
        {
            let stringArray = textField.text!.characters.split{$0 == "."}.map(String.init)
            
            let centsString = stringArray[1]
            
            if centsString.characters.count > 2
            {
                textField.text = textField.text!.chopSuffix(1)
            }
        }
        
        if textField.text! == "\(String(formmater.stringFromNumber(0)!.characters.first!))."
        {
            textField.text! = String(formmater.stringFromNumber(0)!.characters.first!)
        }
        
        let desiredPosition = textField.endOfDocument
        textField.selectedTextRange = textField.textRangeFromPosition(desiredPosition, toPosition: desiredPosition)
    }
    
    func textField(textField: UITextField,
                   shouldChangeCharactersInRange range: NSRange,
                                                 replacementString string: String) -> Bool
    {
        //making maximum charachter length 11 digits
        let currentCharacterCount = textField.text?.characters.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.characters.count - range.length
        return newLength <= 10
        
        if textField.tag == 100
        {
            let newCharacters = NSCharacterSet(charactersInString: string)
            let boolIsNumber = NSCharacterSet.decimalDigitCharacterSet().isSupersetOfSet(newCharacters)
            
            if boolIsNumber == true
            {
                return true
            }
            else
            {
                if string == "."
                {
                    let countdots = textField.text!.componentsSeparatedByString(".").count - 1
                    if countdots == 0
                    {
                        return true
                    }
                    else
                    {
                        if countdots > 0 && string == "."
                        {
                            return false
                        }
                        else
                        {
                            return true
                        }
                    }
                }
                else
                {
                    return false
                }
            }
        }
        else
        {
            return true
        }
    }
    //    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    //        if textField == nameOfGoalTextField
    //        {
    //            if string == "\n"
    //            {
    //                amountTextField.becomeFirstResponder()
    //            }
    //        }
    //        else if textField == amountTextField
    //        {
    //            if string == "\n"
    //            {
    //                amountTextField.resignFirstResponder()
    //            }
    //        }
    //        
    //        return true
    //    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        let keyboardDoneButtonShow = UIToolbar(frame: CGRectMake(0, 0,  self.view.frame.size.width, self.view.frame.size.height/17))
        //Setting the style for the toolbar
        keyboardDoneButtonShow.barStyle = UIBarStyle .BlackTranslucent
        //Making the done button and calling the textFieldShouldReturn native method for hidding the keyboard.
        let doneButton = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.Done, target: self, action: #selector(textFieldShouldReturn(_:)))
        //Calculating the flexible Space.
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        //Setting the color of the button.
        doneButton.tintColor = UIColor.whiteColor()
        //Making an object using the button and space for the toolbar
        let toolbarButton = [flexSpace,doneButton]
        //Adding the object for toolbar to the toolbar itself
        keyboardDoneButtonShow.setItems(toolbarButton, animated: false)
        //Now adding the complete thing against the desired textfield
        moneyEarnedTextField.inputAccessoryView = keyboardDoneButtonShow
        
    }
    
    //Function for hidding the keyboard.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}
