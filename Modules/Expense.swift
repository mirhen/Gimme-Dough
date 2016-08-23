//
//  Expense.swift
//  Dough
//
//  Created by Miriam Hendler on 7/18/16.
//  Copyright © 2016 Miriam Hendler. All rights reserved.
//

import UIKit
import RealmSwift

class Expense: Object// , NSCoding
{
     dynamic var amountOfMoney: Double = 0
     dynamic var expenseName: String = "title"
     dynamic var itemTag: Int = 0
     dynamic var timeUnit: Int = 1
    dynamic var expenseImage: NSData = UIImagePNGRepresentation(UIImage(named: "img.png")!)!
    
    
//    init(amountOfMoney: Double, expenseName: String, itemTag: Int, timeUnit: Int)//, expenseImage: UIImage)
//    {
//        self.amountOfMoney = amountOfMoney
//        self.expenseName = expenseName
//        self.itemTag = itemTag
//        self.timeUnit = timeUnit
   //     self.expenseImage = expenseImage
//    }
    
//    required convenience init?(coder aDecoder: NSCoder) {
//        
//        guard
//        
//        let amountOfMoney = aDecoder.decodeObjectForKey("amountOfMoney") as? Double,
//        let expenseName = aDecoder.decodeObjectForKey("expenseName") as? String,
//        let itemTag = aDecoder.decodeObjectForKey("itemTag") as? Int,
//        let timeUnit = aDecoder.decodeObjectForKey("timeUnit") as? Int,
//        let expenseImage = aDecoder.decodeObjectForKey("expenseImage") as? UIImage
//        else {
//            return nil
//        }
//        self.init(amountOfMoney: amountOfMoney, expenseName: expenseName, itemTag: itemTag, timeUnit: timeUnit, expenseImage: expenseImage)
//    }
//    
//    func encodeWithCoder(aCoder: NSCoder) {
//        aCoder.encodeObject(amountOfMoney, forKey: "amountOfMoney")
//        aCoder.encodeObject(expenseName, forKey: "expenseName")
//        aCoder.encodeObject(itemTag, forKey: "itemTag")
//        aCoder.encodeObject(timeUnit, forKey: "timeUnit")
//        aCoder.encodeObject(expenseImage, forKey: "expenseImage")
//    }
}
