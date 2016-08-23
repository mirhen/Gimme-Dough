//
//  Goal.swift
//  Dough
//
//  Created by Miriam Hendler on 8/4/16.
//  Copyright © 2016 Miriam Hendler. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class Goal: Object
{
   dynamic var priceOfGoal: Double = 0
   dynamic var goalName: String = "title"
   dynamic var itemTag: Int = 0
   dynamic var goalImage: NSData = UIImagePNGRepresentation(UIImage(named: "saving background image goal.jpg")!)!
   dynamic var timeToReachGoal: Double = 0
   dynamic var amountToSave: Double = 0
}
