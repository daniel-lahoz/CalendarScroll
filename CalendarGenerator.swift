//
//  CalendarGenerator.swift
//  CalendarScroll
//
//  Created by Daniel Lahoz on 29/6/16.
//  Copyright © 2016 Lahoz. All rights reserved.
//

import Foundation

class CalendarGenerator: NSObject {
    
    let calendar = NSCalendar.currentCalendar()
    var components : NSDateComponents = NSDateComponents()
    
    override init() {
        super.init()
        _ = self.getCurrentMonth()
    }
    
    func getCurrentMonth() -> NSDate{
        
        let date = NSDate()
        
        components = NSCalendar.currentCalendar().components([.Day , .Month , .Year], fromDate: date)
        
        return date
    }
    


}


// MARK: - NSDaTe extension
public extension NSDate {
    
    func getMonthDescription() -> String{
        
        let components = NSCalendar.currentCalendar().components([.Month , .Year], fromDate: self)
        
        let year =  components.year
        let month = components.month
        
        return "Mes: \(month) Año \(year)"
    }
    
    func getNextDay() -> NSDate{
        let date = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: 1, toDate: self, options: [])
        return date!
    }
    
    func getPreviusDay() -> NSDate{
        let date = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: -1, toDate: self, options: [])
        return date!
    }
    
    func getNextMonth() -> NSDate{
        let date = NSCalendar.currentCalendar().dateByAddingUnit(.Month, value: 1, toDate: self, options: [])
        return date!
    }
    
    func getPreviusMonth() -> NSDate{
        let date = NSCalendar.currentCalendar().dateByAddingUnit(.Month, value: -1, toDate: self, options: [])
        return date!
    }
    
    func getPastSixMonths() -> NSDate{
        let date = NSCalendar.currentCalendar().dateByAddingUnit(.Month, value: -6, toDate: self, options: [])
        return date!
    }
    
    func getTextDay() -> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.stringFromDate(self)
    }
    
    func getDaysOfTheMonth() -> (previusdays:[NSDate], monthdays:[NSDate]){
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        var startOfMonth : NSDate?
        var lengthOfMonth : NSTimeInterval = 0
        NSCalendar.currentCalendar().rangeOfUnit(.Month, startDate: &startOfMonth, interval: &lengthOfMonth, forDate: self)
        //print(dateFormatter.stringFromDate(startOfMonth!))
        //print("\(lengthOfMonth / 60 / 60 / 24 )")
        let days = Int(lengthOfMonth / 60 / 60 / 24)
        
        let components = NSCalendar.currentCalendar().components([.Weekday], fromDate: startOfMonth!)
        var dayweek = components.weekday//NSCalendar.currentCalendar().dateFromComponents(components)!
        dayweek = dayweek - 2
        if dayweek < 0 {
            dayweek = dayweek + 7
        }

        //print("\(dayweek)")
        
        var firstdayofweek = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: -(dayweek), toDate: startOfMonth!, options: [])
        //print(dateFormatter.stringFromDate(firstdayofweek!))
        
        var previusdays = [NSDate]()
        
        for _ in 0..<dayweek {
            previusdays.append(firstdayofweek!.copy() as! NSDate)
            firstdayofweek = firstdayofweek?.getNextDay()
        }
        
        var monthdays = [NSDate]()
        
        for _ in 1...days {
            monthdays.append(startOfMonth!.copy() as! NSDate)
            startOfMonth = startOfMonth?.getNextDay()
        }
        
        return (previusdays, monthdays)
    }
    
}

