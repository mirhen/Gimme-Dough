//
//  HomeViewController.swift
//  Dough
//
//  Created by Miriam Hendler on 7/21/16.
//  Copyright © 2016 Miriam Hendler. All rights reserved.
//

import UIKit
import Charts
import GameKit
import RealmSwift

class HomeViewController: UIViewController, ChartViewDelegate
{
    
    @IBOutlet weak var spendingsTitleLabel: UILabel!
    @IBOutlet weak var expensesTitleLabel: UILabel!
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var spendingBalanceLabel: UITextField!
//    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var spendingBalanceDatePicker: UIPickerView!
    @IBOutlet weak var addExpensesLabel: UILabel!
    
    var unique: [String] = []
    var totalMoney = 10.0
    var expenseDictionary: [String : Double] = [:]
    var spendingMoney: Double = 0
    @IBOutlet weak var slashLabel: UILabel!
    var expenses = Results<Expense>!()
    var goals = Results<Goal>?()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        spendingBalanceDatePicker.delegate = self
        spendingBalanceDatePicker.dataSource = self
        spendingBalanceDatePicker.selectRow(1, inComponent: 0, animated: true)
        
        pieChartView.descriptionText = " "
        pieChartView.descriptionTextColor = UIColor.whiteColor()
        pieChartView.descriptionFont = UIFont(name: "Avenir-Book", size: 12.0)!
        pieChartView.holeColor = UIColor.clearColor()
        pieChartView.holeRadiusPercent = 0.2
        
        spendingBalanceDatePicker.subviews[1].hidden = true
        spendingBalanceDatePicker.subviews[2].hidden = true
        pieChartView.transparentCircleRadiusPercent =  pieChartView.holeRadiusPercent// + 0.05
        //      pieChartView.usePercentValuesEnabled = true

        
        let empty = ["your expenses"]
        let value = [0.0]
        setChart(empty, values: value)
        pieChartView.delegate = self
        
        self.pieChartView.backgroundColor = UIColor(patternImage: UIImage(named: "cheating xcode patern.png")!)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        spendingsTitleLabel.textColor = UIColor.whiteColor()
        
        spendingBalanceDatePicker.selectRow(1, inComponent: 0, animated: true)

        expenses = RealmHelper.retrieveExpense()
        goals = RealmHelper.retrieveGoal()
        if expenses.count != 0 && NSUserDefaults.standardUserDefaults().doubleForKey("totalBalance").description != "0.0"
        {
            expenseDictionary.removeAll()
            for individualObject in expenses
            {
                let money = CalendarUnitHelper.convertToBalancePerWeek(individualObject.timeUnit, amountOfMoney: individualObject.amountOfMoney)
                
                expenseDictionary[individualObject.expenseName] = money
            }
            
            let money = NSUserDefaults.standardUserDefaults().doubleForKey("totalBalance")
            let timeUnit = NSUserDefaults.standardUserDefaults().integerForKey("timeUnit")
            
                    totalMoney = CalendarUnitHelper.convertToBalancePerWeek(timeUnit, amountOfMoney: money)
            
                var t = 0.0
                var g = 0.0
            for number in expenseDictionary.values
            {
                t += number
            }
            if let goals = goals
            {
                for number in goals
                {
                    g += number.amountToSave
                }
            }
        if t != 0.0
            {
                
                

                
                addExpensesLabel.hidden = true
                expensesTitleLabel.hidden = false
                spendingsTitleLabel.hidden = false
                pieChartView.hidden = false
                spendingBalanceDatePicker.hidden = false
                spendingBalanceLabel.hidden = false
                slashLabel.hidden = false
            }
            else
            {
                addExpensesLabel.hidden = false
                expensesTitleLabel.hidden = true
                spendingsTitleLabel.hidden = true
                pieChartView.hidden = true
                spendingBalanceDatePicker.hidden = true
                spendingBalanceLabel.hidden = true
                slashLabel.hidden = true

            }
            if NSUserDefaults.standardUserDefaults().doubleForKey("spending") != 0.0
            {
                spendingMoney = totalMoney - t - g
                
            }
            else
            {
                
                
                spendingMoney = totalMoney - t - g
                
                NSUserDefaults.standardUserDefaults().setDouble(spendingMoney, forKey: "spending")
            }
                    expenseDictionary["spending"] = spendingMoney
            
                    let formatter = NSNumberFormatter()
                    formatter.numberStyle = .CurrencyStyle
                    spendingBalanceLabel.text = "\(formatter.stringFromNumber(spendingMoney)!)"
                    
                    var filteredExpenseDictionary: [String : Double] = [:]
                    
                    var iterationCount: Int! = expenseDictionary.count
                    
                    for individualObject in expenseDictionary
                    {
                        iterationCount = iterationCount - 1
                        
                        if individualObject.1 != 0.0
                        {
                            filteredExpenseDictionary[individualObject.0] = individualObject.1
                        }
                        
                        if iterationCount == 0
                        {
                            setChart(Array(filteredExpenseDictionary.keys) , values: Array(filteredExpenseDictionary.values))
                        }
                    }
            
                }
        else
        {
            pieChartView.hidden = true
            spendingBalanceLabel.hidden = true
            spendingBalanceDatePicker.hidden = true
            slashLabel.hidden = true
            spendingsTitleLabel.hidden = true
            expensesTitleLabel.hidden = true
            addExpensesLabel.hidden = false
        }
        
    }
    
    
    func setChart(dataPoints: [String], values: [Double])
    {
        

        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count
        {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "Expenses")
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        
        let pFormatter: NSNumberFormatter = NSNumberFormatter()
        pFormatter.numberStyle = .NoStyle
        pFormatter.positiveFormat = String(pFormatter.stringFromNumber(0)!.characters.first!)
        
        
        pieChartData.setValueFormatter(pFormatter)
        pieChartData.setValueFont(UIFont(name: "Avenir-Book", size: 11.0))
        pieChartView.data = pieChartData
        
        var colorArray: [UIColor] = []
        //GREEN COLORS
//        let colors = [colorWithHexString("#05522c"),colorWithHexString("#00c400"),colorWithHexString("#009d00"),colorWithHexString("#007600"),colorWithHexString("#4eb14e"),colorWithHexString("#14eb14"), colorWithHexString("##1ff189")]
        
        //BLUE COLORS
       let colors =  [/*colorWithHexString("#CCD5E6"), colorWithHexString("#B9C6DD"), */colorWithHexString("#668DC2"), colorWithHexString("#4C7DB7"), colorWithHexString("#4774AB"), colorWithHexString("#416C9F"), colorWithHexString("#3A6190"), colorWithHexString("#33567F"),colorWithHexString("#B9C6DD"), colorWithHexString("#A3B5D4"), colorWithHexString("#8AA3CC") ]
        
        for i in 0..<dataPoints.count
        {
            let color = colors[i]
            colorArray.append(color)
        }
        pieChartDataSet.colors = colorArray
        pieChartView.legend.enabled = false
    }
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight)
    {
        print("chartValueSelected")
    }
}
extension HomeViewController: UIPickerViewDelegate, UIPickerViewDataSource
{
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return CalendarUnitHelper.timeUnits.count
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString?
    {
        let titleData = CalendarUnitHelper.timeUnits.map {$0.0}
        
        if titleData[row] == 0
        {
            return NSAttributedString(string: "Day")
        }
        else if titleData[row] == 1
        {
            return NSAttributedString(string: "Week")
        }
        else if titleData[row] == 2
        {
            return NSAttributedString(string: "Month")
        }
        else if titleData[row] == 3
        {
            return NSAttributedString(string: "Year")
        }
        else
        {
            return NSAttributedString(string: "Day")
        }
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView
    {
        let pickerLabel = UILabel()
        let titleData = CalendarUnitHelper.timeUnits.map {$0.0}[row]
        
        if titleData == 0
        {
            let myTitle = NSAttributedString(string: "Day", attributes: [NSFontAttributeName:UIFont(name: "Avenir-Book", size: 17.0)!,NSForegroundColorAttributeName:UIColor.whiteColor()])
            pickerLabel.attributedText = myTitle
        }
        else if titleData == 1
        {
            let myTitle = NSAttributedString(string: "Week", attributes: [NSFontAttributeName:UIFont(name: "Avenir-Book", size: 17.0)!,NSForegroundColorAttributeName:UIColor.whiteColor()])
            pickerLabel.attributedText = myTitle
        }
        else if titleData == 2
        {
            let myTitle = NSAttributedString(string: "Month", attributes: [NSFontAttributeName:UIFont(name: "Avenir-Book", size: 17.0)!,NSForegroundColorAttributeName:UIColor.whiteColor()])
            pickerLabel.attributedText = myTitle
        }
        else if titleData == 3
        {
            let myTitle = NSAttributedString(string: "Year", attributes: [NSFontAttributeName:UIFont(name: "Avenir-Book", size: 17.0)!,NSForegroundColorAttributeName:UIColor.whiteColor()])
            pickerLabel.attributedText = myTitle
        }
        else
        {
            print("ERROR")
        }
        return pickerLabel
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        var spendingBalance = 0.0
        let formatter = NSNumberFormatter()
        if row == 0
        {
            spendingBalance = CalendarUnitHelper.convertToBalancePerDay(1, amountOfMoney: spendingMoney)
            formatter.numberStyle = .CurrencyStyle
            spendingBalanceLabel.text! = "\(formatter.stringFromNumber(spendingBalance)!)"
        }
        else if row == 1
        {
            spendingBalance = CalendarUnitHelper.convertToBalancePerWeek(1, amountOfMoney: spendingMoney)
            formatter.numberStyle = .CurrencyStyle
            spendingBalanceLabel.text! = "\(formatter.stringFromNumber(spendingBalance)!)"
        }
        else if row == 2
        {
            spendingBalance = CalendarUnitHelper.convertToBalancePerMonth(1, amountOfMoney: spendingMoney)
            formatter.numberStyle = .CurrencyStyle
            spendingBalanceLabel.text! = "\(formatter.stringFromNumber(spendingBalance)!)"
        }
        else if row == 3
        {
            spendingBalance = CalendarUnitHelper.convertToBalancePerYear(1, amountOfMoney: spendingMoney)
            formatter.numberStyle = .CurrencyStyle
            spendingBalanceLabel.text! = "\(formatter.stringFromNumber(spendingBalance)!)"
        }
    }
}