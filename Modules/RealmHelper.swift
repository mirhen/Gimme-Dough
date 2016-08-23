//
//  RealmHelper.swift
//  Dough
//
//  Created by Miriam Hendler on 8/4/16.
//  Copyright © 2016 Miriam Hendler. All rights reserved.
//

import Foundation
import RealmSwift

//MARK -ExpenseHelper
class RealmHelper
{
    static func addExpense(expense: Expense)
    {
        let realm = try! Realm()
        try! realm.write(){
            realm.add(expense)
            
           
        }
    }
    static func deleteExpense(expense: Expense)
    {
        let realm = try! Realm()
        try! realm.write(){
            realm.delete(expense)
        }
    }
    static func updateExpense(expenseToBeUpdated: Expense, newExpense: Expense)
    {
        let realm = try! Realm()
        try! realm.write(){
            expenseToBeUpdated.amountOfMoney = newExpense.amountOfMoney
            expenseToBeUpdated.expenseName = newExpense.expenseName
            expenseToBeUpdated.timeUnit = newExpense.timeUnit
            expenseToBeUpdated.itemTag = newExpense.itemTag
        }
    }
    static func retrieveExpense() -> Results<Expense>
    {
        let realm = try! Realm()
        return realm.objects(Expense)
    }
}

//MARK -GoalHelper
extension RealmHelper
{
    static func addGoal(goal: Goal)
    {
        let realm = try! Realm()
        try! realm.write()
            {
            realm.add(goal)
        }
    }
    static func deleteGoal(goal: Goal)
    {
        let realm = try! Realm()
        try! realm.write(){
            realm.delete(goal)
        }
    }

    static func updateGoal(goalToBeUpdated: Goal, newGoal: Goal)
    {
        let realm = try! Realm()
        try! realm.write()
            {
            goalToBeUpdated.goalImage = newGoal.goalImage
            goalToBeUpdated.amountToSave = newGoal.amountToSave
            goalToBeUpdated.goalName = newGoal.goalName
            goalToBeUpdated.itemTag = newGoal.itemTag
            goalToBeUpdated.timeToReachGoal = newGoal.timeToReachGoal
            goalToBeUpdated.priceOfGoal = newGoal.priceOfGoal
        }
    }
    static func retrieveGoal() -> Results<Goal>
    {
        let realm = try! Realm()
        return realm.objects(Goal)
    }
}