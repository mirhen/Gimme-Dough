//
//  CalenderUnitHelper.swift
//  Dough
//
//  Created by Miriam Hendler on 7/18/16.
//  Copyright © 2016 Miriam Hendler. All rights reserved.
//

import UIKit

class CalendarUnitHelper {
    
    static var timeUnits = [(0, 1), (1,7), (2, 28), (3, 365)]
    static var Day = "Day"
    static var Week = "Week"
    static var Month = "Month"
    static var Year = "Year"
    
    static func convertToBalancePerDay(typeOfUnit: Int, amountOfMoney: Double) -> Double
    {
        if typeOfUnit == 1
        {
            return amountOfMoney / 7
        }
        else if typeOfUnit == 2
        {
            return amountOfMoney / 28
        }
        else if typeOfUnit == 3
        {
            return amountOfMoney / 365
        }
        else
        {
            return amountOfMoney
        }
    }
    
    static func convertToBalancePerWeek(typeOfUnit: Int, amountOfMoney: Double) -> Double
    {
        if typeOfUnit == 0
        {
            return amountOfMoney * 7
        }
        else if typeOfUnit == 2
        {
            return amountOfMoney / 4
        }
        else if typeOfUnit == 3
        {
            return amountOfMoney / 52
        }
        else
        {
            return amountOfMoney
        }
    }
    
    static func convertToBalancePerMonth(typeOfUnit: Int, amountOfMoney: Double) -> Double
    {
        if typeOfUnit == 0
        {
            return amountOfMoney * 28
        }
        else if typeOfUnit == 1
        {
            return amountOfMoney * 4
        }
        else if typeOfUnit == 3
        {
            return amountOfMoney / 12
        }
        else
        {
            return amountOfMoney
        }
    }
    
    static func convertToBalancePerYear(typeOfUnit: Int, amountOfMoney: Double) -> Double
    {
        if typeOfUnit == 0
        {
            return amountOfMoney * 365
        }
        else if typeOfUnit == 1
        {
            return amountOfMoney * 52
        }
        else if typeOfUnit == 2
        {
            return amountOfMoney * 12
        }
        else
        {
            return amountOfMoney
        }
    }
    
    static func convertToFormattedDouble(number: AnyObject) -> Double
    {
        let numberAsString = String(number)
        let newNumber = numberAsString.stringByTrimmingCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
        
        return Double(newNumber)!
    }
    
    static func convertToDateTypeString(withTimeUnit: Int) -> String
    {
        if withTimeUnit == 0
        {
            return "day"
        }
        else if withTimeUnit == 1
        {
            return "week"
        }
        else if withTimeUnit == 2
        {
            return "month"
        }
        else if withTimeUnit == 3
        {
            return "year"
        }
        else
        {
            return "failure"
        }
    }
    
    static func convertNSDataToUIImage(imageData: NSData) -> UIImage
    {
        return UIImage(data: imageData)!
    }
    
    static func convertUIImageToNSData(image: UIImage) -> NSData {
        return UIImagePNGRepresentation(image)!
    }
}