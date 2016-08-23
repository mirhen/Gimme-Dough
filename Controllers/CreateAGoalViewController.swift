//
//  CreateAGoalViewController.swift
//  Dough
//
//  Created by Miriam Hendler on 8/4/16.
//  Copyright © 2016 Miriam Hendler. All rights reserved.
//

import UIKit
import RealmSwift

class CreateAGoalViewController: UIViewController, UIAlertViewDelegate
{
    //UITextFields
    @IBOutlet weak var nameOfGoalTextField: UITextField!
    @IBOutlet weak var GoalAmountTextField: UITextField!
    
    //Other Outlets
    @IBOutlet weak var goalImageView: UIImageView!
    @IBOutlet weak var reachByPickerView: UIPickerView!
    @IBOutlet weak var saveAmountLabel: UILabel!
    
    //Other Objects
    var currentGoal: Goal!
    var timeForGoals = ["1 Week", "2 Weeks", "3 Weeks", "1 Month", "2 Months", "3 Months", "4 Months", "5 Months", "6 Months", "7 Months", "8 Months", "9 Months", "10 Months", "11 Months", "1 Year", "2 Years"]
    var myDate : Double = 1
    let day: Double = 1
    let week: Double = 7
    let month:Double = 28
    let year: Double = 365
    var saveAmount: Double = 0.0
    var newImage: NSData?
    let formmater = NSNumberFormatter()
    
    //IBActions
    @IBAction func doneButtonPressed(sender: AnyObject)
    {
        if nameOfGoalTextField.text != "title"
        {
            if GoalAmountTextField.text != String(formmater.stringFromNumber(0)!.characters.first!) || GoalAmountTextField.text != String(formmater.stringFromNumber(0)!)
            {
                let presentingViewController = (self.presentingViewController?.childViewControllers[2] as! YourGoalsViewController)
                
                let goalAmount = Double(GoalAmountTextField.text!.stringByReplacingOccurrencesOfString(String(formmater.stringFromNumber(0)!.characters.first!), withString: ""))!
                
                if currentGoal != nil
                {
                    let updateGoal = Goal()
                    
                    updateGoal.priceOfGoal = goalAmount
                    updateGoal.goalName = nameOfGoalTextField.text!
                    updateGoal.timeToReachGoal = myDate
                    updateGoal.amountToSave = saveAmount
                    
                    RealmHelper.updateGoal(currentGoal, newGoal: updateGoal)
                    
                    presentingViewController.goalsTableView.reloadData()
                }
                else
                {
                    let newGoal = Goal()
                    newGoal.priceOfGoal = Double(GoalAmountTextField.text!.stringByReplacingOccurrencesOfString(String(formmater.stringFromNumber(0)!.characters.first!), withString: ""))!
                    newGoal.itemTag = randomInteger(1, maximumValue: 9999)
                    newGoal.goalName = nameOfGoalTextField.text!
                    newGoal.goalImage = CalendarUnitHelper.convertUIImageToNSData(goalImageView.image!)
                    newGoal.timeToReachGoal = myDate
                    newGoal.amountToSave = saveAmount
                    RealmHelper.addGoal(newGoal)
                }
                self.dismissViewControllerAnimated(true, completion: nil)
                //            presentingViewController.goalArray = RealmHelper.retrieveGoal()
            } else
            {
                if nameOfGoalTextField.text == "title" || nameOfGoalTextField.text == "" && GoalAmountTextField.text == String(formmater.stringFromNumber(0)!.characters.first!) || GoalAmountTextField.text == "" || GoalAmountTextField.text == String(formmater.stringFromNumber(0)!) || GoalAmountTextField.text == "0.0"
                {
                    let alertViewController = UIAlertController(title: "Uh Oh", message: "You didn't put in an amount or name for your goal", preferredStyle: .Alert)
                    let cancel = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
                    alertViewController.addAction(cancel)
                    self.presentViewController(alertViewController, animated: true, completion: nil)
                }
                    
                else if nameOfGoalTextField.text == "title" || nameOfGoalTextField.text == ""
                {
                    let alertViewController = UIAlertController(title: "Uh Oh", message: "You didn't put in a name for your goal", preferredStyle: .Alert)
                    let cancel = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
                    alertViewController.addAction(cancel)
                    self.presentViewController(alertViewController, animated: true, completion: nil)
                }
                else if GoalAmountTextField.text == String(formmater.stringFromNumber(0)!.characters.first!) || GoalAmountTextField.text == "" || GoalAmountTextField.text == "\(String(formmater.stringFromNumber(0)!.characters.first!))0" || GoalAmountTextField.text == "0" || GoalAmountTextField.text == "0.0"
                {
                    let alertViewController = UIAlertController(title: "Uh Oh", message: "You didn't put in an amount for your goal", preferredStyle: .Alert)
                    let cancel = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
                    alertViewController.addAction(cancel)
                    self.presentViewController(alertViewController, animated: true, completion: nil)
                }
                NSUserDefaults.standardUserDefaults().setDouble(saveAmount, forKey: "saving")
            }
        }
    }
    @IBAction func takePhotoButtonPressed(sender: AnyObject)
    {
        let optionMenu = UIAlertController(title: nil, message: "Choose A Photo", preferredStyle: .ActionSheet)
        
        // 2
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .Default, handler:
            {
                (alert: UIAlertAction!) -> Void in
                
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
                {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
                    imagePicker.allowsEditing = false
                    self.presentViewController(imagePicker, animated: true, completion: nil)
                }
                print("taking a photo")
        })
        let choosePhotoAction = UIAlertAction(title: "Choose From Library", style: .Default, handler:
            {
                (alert: UIAlertAction!) -> Void in
                
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary)
                {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
                    imagePicker.allowsEditing = true
                    self.presentViewController(imagePicker, animated: true, completion: nil)
                }
                
                print("choosing a photo from the library")
        })
        //        let googlePhotoAction = UIAlertAction(title: "Google", style: .Default, handler: {
        //            (alert: UIAlertAction!) -> Void in
        //            print("googling a photo")
        //        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler:
            {
                (alert: UIAlertAction!) -> Void in
                print("Cancelled")
        })
        
        optionMenu.addAction(takePhotoAction)
        optionMenu.addAction(choosePhotoAction)
        //        optionMenu.addAction(googlePhotoAction)
        optionMenu.addAction(cancelAction)
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    //Override Functions
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //setting up number formmater
        formmater.numberStyle = .CurrencyStyle
        
        //setting text placeholder text
        nameOfGoalTextField.attributedPlaceholder = NSAttributedString(string:"title", attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        //Setting up the delegates for *reachByPickerView* and *GoalAmountTextField*
        reachByPickerView.delegate = self
        reachByPickerView.dataSource = self
        GoalAmountTextField.delegate = self
        nameOfGoalTextField.delegate = self
        
        //Format various items if there does not exist a current expense.
        GoalAmountTextField.text = String(formmater.stringFromNumber(0)!.characters.first!)
        nameOfGoalTextField.text = "title"
        reachByPickerView.selectRow(3, inComponent: 0, animated: true)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(CreateAGoalViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        reachByPickerView.subviews[1].hidden = true
        reachByPickerView.subviews[2].hidden = true
        
        //        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        //        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
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
    
    
    func dismissKeyboard()
    {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //If currentExpense does indeed exist, format various items.
        if let verifiedCurrentGoal = currentGoal
        {
            //Format the text of *nameOfExpenseTextField* and *balanceTextField*.
            nameOfGoalTextField.text = verifiedCurrentGoal.goalName
            nameOfGoalTextField.textColor = UIColor.whiteColor()
            let formater = NSNumberFormatter()
            formater.numberStyle = .CurrencyStyle
            GoalAmountTextField.text = "\(formater.stringFromNumber(verifiedCurrentGoal.priceOfGoal)!)"
            saveAmountLabel.text = "\(formater.stringFromNumber(verifiedCurrentGoal.amountToSave)!) /Week"
            goalImageView.image = CalendarUnitHelper.convertNSDataToUIImage(verifiedCurrentGoal.goalImage)
            
            if verifiedCurrentGoal.timeToReachGoal == week // Week
            {
                reachByPickerView.selectRow(0, inComponent: 0, animated: true)
                myDate = week
            }
            else if  verifiedCurrentGoal.timeToReachGoal == week * 2 // 2 Weeks
            {
                reachByPickerView.selectRow(1, inComponent: 0, animated: true)
                myDate = week * 2
            }
            else if verifiedCurrentGoal.timeToReachGoal == week * 3 // 3 Weeks
            {
                reachByPickerView.selectRow(2, inComponent: 0, animated: true)
                myDate = week * 3
            }
            else if verifiedCurrentGoal.timeToReachGoal == month // 1 Month
            {
                reachByPickerView.selectRow(3, inComponent: 0, animated: true)
                 myDate = week * 4
            }
            else if verifiedCurrentGoal.timeToReachGoal == month * 2 // 2 Months
            {
                reachByPickerView.selectRow(4, inComponent: 0, animated: true)
                 myDate = month * 2
            }
            else if verifiedCurrentGoal.timeToReachGoal == month * 3 // 3 Months
            {
                reachByPickerView.selectRow(5, inComponent: 0, animated: true)
                   myDate = month * 3
            }
            else if verifiedCurrentGoal.timeToReachGoal == month * 4 // 4 Months
            {
                reachByPickerView.selectRow(6, inComponent: 0, animated: true)
                   myDate = month * 4
            }
            else if verifiedCurrentGoal.timeToReachGoal == month * 5 // 5 Months
            {
                reachByPickerView.selectRow(7, inComponent: 0, animated: true)
                   myDate = month * 5
            }
            else if verifiedCurrentGoal.timeToReachGoal == month * 6 // 6 Months
            {
                reachByPickerView.selectRow(8, inComponent: 0, animated: true)
                   myDate = month * 6
            }
            else if verifiedCurrentGoal.timeToReachGoal == month * 7 // 7 Months
            {
                reachByPickerView.selectRow(9, inComponent: 0, animated: true)
                   myDate = month * 7
            }
            else if verifiedCurrentGoal.timeToReachGoal == month * 8// 9 Months
            {
                reachByPickerView.selectRow(10, inComponent: 0, animated: true)
                   myDate = month * 8
            }
            else if verifiedCurrentGoal.timeToReachGoal == month * 9 // 10 Months
            {
                reachByPickerView.selectRow(11, inComponent: 0, animated: true)
                   myDate = month * 9
            }
            else if verifiedCurrentGoal.timeToReachGoal == month * 10 // 11 Months
            {
                reachByPickerView.selectRow(12, inComponent: 0, animated: true)
                   myDate = month * 10
            }
            else if verifiedCurrentGoal.timeToReachGoal == month * 11 // 12 Months
            {
                reachByPickerView.selectRow(13, inComponent: 0, animated: true)
                   myDate = month * 11
            }
            else if verifiedCurrentGoal.timeToReachGoal == year // 1 Year
            {
                reachByPickerView.selectRow(14, inComponent: 0, animated: true)
                   myDate = month * 12
            }
            else if verifiedCurrentGoal.timeToReachGoal == year * 2 // 2 Years
            {
                reachByPickerView.selectRow(15, inComponent: 0, animated: true)
                   myDate = year * 2
            }
        }
        else
        {
            myDate = month
        }
        
        
        //As the balance text field edits, remove disallowed characters.
        GoalAmountTextField.addTarget(self, action: #selector(AOEC.textFieldDidChange(_:)), forControlEvents: .EditingChanged)
        GoalAmountTextField.tag = 100
        
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(detectTextFieldState), userInfo: nil, repeats: true)
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //Independant Function
    func updateSavingAmount()
    {
        if GoalAmountTextField.text != String(formmater.stringFromNumber(0)!.characters.first!)
        {
            let goalAmount = Double(GoalAmountTextField.text!.stringByReplacingOccurrencesOfString(String(formmater.stringFromNumber(0)!.characters.first!), withString: ""))!
            var t = 0.0
            let expenseArray = RealmHelper.retrieveExpense()
            let totalBalance = NSUserDefaults.standardUserDefaults().doubleForKey("totalBalance")
            var spendingMoney: Double = 0.0
            for individualObject in expenseArray {
                t += individualObject.amountOfMoney
            }
            spendingMoney = totalBalance - t
            
            let newSpendingMoney: Double = ((spendingMoney * myDate) - goalAmount ) / myDate
            saveAmount = spendingMoney - newSpendingMoney
            
            let currencyFormatter = NSNumberFormatter()
            currencyFormatter.numberStyle = .CurrencyStyle
            if newSpendingMoney >= 0
            {
                saveAmountLabel.text = "\(currencyFormatter.stringFromNumber(saveAmount)!) /Week"
                saveAmountLabel.textColor = UIColor.blackColor()
            } else {
                saveAmountLabel.textColor = UIColor.redColor()
                saveAmountLabel.text = "\(currencyFormatter.stringFromNumber(saveAmount)!) /Week"
                let alertViewController = UIAlertController(title: "Not Enough Money!", message: "You don't have enough money to reach your goal of \(nameOfGoalTextField.text!))", preferredStyle: .Alert)
                // in \(timeForGoals[row]
                let cancel =  UIAlertAction(title: "OK :(", style: .Cancel, handler: nil)
                alertViewController.addAction(cancel)
                self.presentViewController(alertViewController, animated: true, completion: nil)
            }
        }
    }
}

//MARK: -Picker View Delagate
extension CreateAGoalViewController: UIPickerViewDelegate, UIPickerViewDataSource
{
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return  timeForGoals.count
    }
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString?
    {
        return NSAttributedString(string: timeForGoals[row])
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView
    {
        let pickerLabel = UILabel()
        let titleData = timeForGoals[row]
        
        //Format the text of *timeForGoalPickerView*
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Avenir-Book", size: 15.0)!,NSForegroundColorAttributeName:UIColor.blackColor()])
        pickerLabel.attributedText = myTitle
        pickerLabel.textAlignment = .Center
        
        return pickerLabel
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        switch timeForGoals[row]
        {
        case timeForGoals[0]: // Week
            
            myDate = week
            
        case timeForGoals[1]: // 2 Weeks
            
            myDate = week * 2
            
        case timeForGoals[2]: // 3 Weeks
            
            myDate = week * 3
            
        case timeForGoals[3]: // 1 Month
            
            myDate = month
            
        case timeForGoals[4]: // 3 Months
            
            myDate = month * 2
            
        case timeForGoals[5]: // 4 Months
            
            myDate = month * 3
            
        case timeForGoals[6]: // 5 Months
            
            myDate = month * 4
            
        case timeForGoals[7]: // 6 Months
            
            myDate = month * 5
            
        case timeForGoals[8]: // 7 Months
            
            myDate = month * 6
            
        case timeForGoals[9]: // 8 Months
            
            myDate = month * 7
            
        case timeForGoals[10]: // 9 Months
            
            myDate = month * 8
            
        case timeForGoals[11]: // 10 Months
            
            myDate = month * 9
            
        case timeForGoals[12]: // 11 Months
            
            myDate = month * 10
            
        case timeForGoals[13]: // 12 Months
            
            myDate = month * 11
            
        case timeForGoals[14]: // 1 Year
            
            myDate = year
            
        case timeForGoals[15]: // 2 Years
            
            myDate = year * 2
            
        default:
            break;
        }
        
        updateSavingAmount()
    }
}

extension CreateAGoalViewController : UITextFieldDelegate
{
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
        if textField == GoalAmountTextField
        {
            return newLength <= 10
        }
        if textField == nameOfGoalTextField
        {
            return newLength <= 20
        }
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
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == "title"
        {
            textField.text = ""
        }
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
        GoalAmountTextField.inputAccessoryView = keyboardDoneButtonShow
        
    }
    
    //Function for hidding the keyboard.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func detectTextFieldState()
    {
        if GoalAmountTextField.editing == true
        {
            let desiredPosition = GoalAmountTextField.endOfDocument
            GoalAmountTextField.selectedTextRange = GoalAmountTextField.textRangeFromPosition(desiredPosition, toPosition: desiredPosition)
            
            textFieldDidChange(GoalAmountTextField)
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        updateSavingAmount()
        
        let name = "yo"
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
        
//        updateSavingAmount()
    }
}

extension CreateAGoalViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!)
    {
        if let verifiedCurrentGoal = currentGoal
        {
            let realm = try! Realm()
            try! realm.write()
                {
                    newImage = CalendarUnitHelper.convertUIImageToNSData(image)
                    verifiedCurrentGoal.goalImage = newImage!
                    goalImageView.image = image
            }
        }
        else
        {
            goalImageView.image = image
        }
        
        self.dismissViewControllerAnimated(true, completion: nil);
    }
}

