//
//  AmountOfExpensesViewController.swift
//  Dough
//
//  Created by Miriam Hendler on 7/18/16.
//  Copyright © 2016 Miriam Hendler. All rights reserved.
//

import UIKit
import RealmSwift

//import UnderKeyboard

class AOEC: UIViewController
{
    //--------------------------------------------------//
    
    //Interface Builder User Interface Elements
    
    //UITextFields
    @IBOutlet weak var balanceTextField: UITextField!
    @IBOutlet weak var nameOfExpenseTextField: UITextField!
    
    //UIViews
    @IBOutlet weak var dayView: UIView!
    @IBOutlet weak var weekView: UIView!
    @IBOutlet weak var monthView: UIView!
    @IBOutlet weak var yearView: UIView!
    
    //Other Outlets
    @IBOutlet weak var expenseImageView: UIImageView!
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    
    
    //--------------------------------------------------//
    
    //Non-Interface Builder Objects
    
    //Other Objects
    var currentExpense: Expense?
    var newImage: NSData?
    var expenseArray = Results<Expense>!()
    var t = 0.0
    var spendingAmount = 0.0
    let formmater = NSNumberFormatter()
//    let underKeyboardLayoutConstraint = UnderKeyboardLayoutConstraint()
    
    //Action Objects
    @IBAction func dayButtonPressed(sender: AnyObject)
    {
        //hiding other under lines
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
    //--------------------------------------------------//
    
    //Override Functions
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        //If currentExpense does indeed exist, format various items.
        if let verifiedCurrentExpense = currentExpense
        {
            //Format the text of *nameOfExpenseTextField* and *balanceTextField*.
            nameOfExpenseTextField.text = verifiedCurrentExpense.expenseName
            nameOfExpenseTextField.textColor = UIColor.whiteColor()
            balanceTextField.text = "\(formmater.stringFromNumber(verifiedCurrentExpense.amountOfMoney)!)"
            if let newImage = newImage
            {

            }
            else
            {
                expenseImageView.image = CalendarUnitHelper.convertNSDataToUIImage(verifiedCurrentExpense.expenseImage)
            }
            
            //For each type of date chosen, select the appropriate row in the date type picker view.
            if verifiedCurrentExpense.timeUnit == 0
            {
                //Hiding unselected time units
                dayView.hidden = false
                monthView.hidden = true
                weekView.hidden = true
                yearView.hidden = true
            }
            else if verifiedCurrentExpense.timeUnit == 1
            {
                dayView.hidden = true
                monthView.hidden = true
                weekView.hidden = false
                yearView.hidden = true
            }
            else if verifiedCurrentExpense.timeUnit == 2
            {
                dayView.hidden = true
                monthView.hidden = false
                weekView.hidden = true
                yearView.hidden = true
            }
            else if verifiedCurrentExpense.timeUnit == 3
            {
                dayView.hidden = true
                monthView.hidden = true
                weekView.hidden = true
                yearView.hidden = false
            }
        }
        else if nameOfExpenseTextField.text == "title"
        {
            //Hiding unselected time units
            dayView.hidden = false
            monthView.hidden = true
            weekView.hidden = true
            yearView.hidden = true
        }
        
        //As the balance text field edits, remove disallowed characters.
        balanceTextField.addTarget(self, action: #selector(AOEC.textFieldDidChange(_:)), forControlEvents: .EditingChanged)
        balanceTextField.tag = 100
        
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(detectTextFieldState), userInfo: nil, repeats: true)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //setting text placeholder text
        nameOfExpenseTextField.attributedPlaceholder = NSAttributedString(string:"title", attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
//        underKeyboardLayoutConstraint.setup(bottomLayoutConstraint, view: view, bottomLayoutGuide: bottomLayoutGuide)
        print("viewDidLoad: ")
        expenseArray = RealmHelper.retrieveExpense()
        formmater.numberStyle = .CurrencyStyle
        for expense in expenseArray
        {
            t += expense.amountOfMoney
        }
        var balance = NSUserDefaults.standardUserDefaults().doubleForKey("totalBalance")
        if t != 0.0
        {
            if currentExpense != nil
            {
        spendingAmount = balance - t + currentExpense!.amountOfMoney
            }
            else
            {
                spendingAmount = balance - t
            }
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(AOEC.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        //setting the delegates
        nameOfExpenseTextField.delegate = self
        balanceTextField.delegate = self
        
        //Format various items if there does not exist a current expense.
        balanceTextField.text = "\(formmater.stringFromNumber(0)!)"
        nameOfExpenseTextField.text = "title"
        
        //Hiding unselected time units
        dayView.hidden = false
        monthView.hidden = true
        weekView.hidden = true
        
        // Note that SO highlighting makes the new selector syntax (#selector()) look
        // like a comment but it isn't one
//              NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardNotification(_:)), name: UIKeyboardWillChangeFrameNotification,object: nil)
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)

        
    }
    
    //movie up whole view when keyboard appears
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height / 3
            }
            else {
                
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height / 3
            }
            else {
                
            }
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    //movie up object that would be hidden from keyboard
    func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue()
            let duration:NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.unsignedLongValue ?? UIViewAnimationOptions.CurveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if endFrame?.origin.y >= UIScreen.mainScreen().bounds.size.height {
                self.keyboardHeightLayoutConstraint?.constant = 5
                print("yo")
            } else {
                self.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 0.0
                print("no")
            }
            UIView.animateWithDuration(duration,
                                       delay: NSTimeInterval(0),
                                       options: animationCurve,
                                       animations: { self.view.layoutIfNeeded() },
                                       completion: nil)
        }
    }

    //dismmis keyboard on any tap
    func dismissKeyboard()
    {
        self.view.endEditing(true)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        print("prepareForSegue")
        
        if segue.identifier == "cancelEditSegue"
        {
            print("cancel button tapped")
        }
    }
    
    //--------------------------------------------------//
    
    //Interface Builder Actions
    
    @IBAction func saveButton(sender: AnyObject)
    {
        let presentingViewController = (self.presentingViewController?.childViewControllers[0] as! ETVC)

        if balanceTextField.text != String(formmater.stringFromNumber(0)!.characters.first!) || balanceTextField.text != formmater.stringFromNumber(0)
        {
            var timeUnit = 4
            
            if dayView.hidden == false
            {
                timeUnit = 0
            }
            else if weekView.hidden == false
            {
                timeUnit = 1
            }
            else if monthView.hidden == false
            {
                timeUnit = 2
            }
            else
            {
                timeUnit = 3
            }
            
 
                if CalendarUnitHelper.convertToBalancePerWeek(timeUnit, amountOfMoney: Double(balanceTextField.text!.stringByReplacingOccurrencesOfString(String(formmater.stringFromNumber(0)!.characters.first!), withString: ""))!) > spendingAmount && spendingAmount != 0.0
               {
                let alertController = UIAlertController(title: "error", message: "you do not have enough money to cover all of your expenses", preferredStyle: .Alert)
                let cancel = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
                alertController.addAction(cancel)
                self.presentViewController(alertController, animated: true, completion: nil)
                }
                else
                
                {
            if currentExpense != nil
            {
                let newExpense = Expense()
                newExpense.amountOfMoney = Double(balanceTextField.text!.stringByReplacingOccurrencesOfString(String(balanceTextField.text!.characters.first!), withString: ""))!
                newExpense.expenseName = nameOfExpenseTextField.text!
                newExpense.timeUnit = timeUnit
                
                RealmHelper.updateExpense(currentExpense!, newExpense: newExpense)
                presentingViewController.amountTableView.reloadData()
            }
            else
            {
                let newExpense = Expense()
                newExpense.amountOfMoney = Double(balanceTextField.text!.stringByReplacingOccurrencesOfString(String(balanceTextField.text!.characters.first!), withString: ""))!
                newExpense.expenseName = nameOfExpenseTextField.text!
                newExpense.timeUnit = timeUnit
                newExpense.expenseImage = CalendarUnitHelper.convertUIImageToNSData(expenseImageView.image!)
                RealmHelper.addExpense(newExpense)
            }
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        presentingViewController.expenseArray = RealmHelper.retrieveExpense()
        }
    }
    
    //--------------------------------------------------//
    
    //Independent Functions
    
    func detectTextFieldState()
    {
        if balanceTextField.editing == true
        {
            let desiredPosition = balanceTextField.endOfDocument
            balanceTextField.selectedTextRange = balanceTextField.textRangeFromPosition(desiredPosition, toPosition: desiredPosition)
            
            textFieldDidChange(balanceTextField)
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
}

extension AOEC : UITextFieldDelegate
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
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        if textField.text == "title"
        {
            textField.text = ""
        }
        let string = formmater.stringFromNumber(0)!
        if textField.text == string
        {
            textField.text = "\(String(textField.text!.characters.first!))"
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
        balanceTextField.inputAccessoryView = keyboardDoneButtonShow
        
    }
    
    //Function for hidding the keyboard.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

extension AOEC: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!)
    {
        if let verifiedCurrentExpense = currentExpense
        {
            let realm = try! Realm()
            try! realm.write()
                {
                newImage = CalendarUnitHelper.convertUIImageToNSData(image)
                verifiedCurrentExpense.expenseImage = newImage!
                expenseImageView.image = image
            }
        }
        else
        {
            expenseImageView.image = image
        }
        
        self.dismissViewControllerAnimated(true, completion: nil);
    }
}
