//
//  CalendarGenerator.swift
//  CalendarScroll
//
//  Created by Daniel Lahoz on 29/6/16.
//  Copyright © 2016 Lahoz. All rights reserved.
//

import Foundation

class CalendarGenerator: NSObject {
    
    let calendar = Calendar.current()
    var components : DateComponents = DateComponents()
    
    override init() {
        super.init()
        _ = self.getCurrentMonth()
    }
    
    func getCurrentMonth() -> Date{
        
        let date = Date()
        
        components = Calendar.current().components([.day , .month , .year], from: date)
        
        return date
    }
    


}


// MARK: - NSDaTe extension
public extension Date {
    
    func getMonthDescription() -> String{
        
        let components = Calendar.current().components([.month , .year], from: self)
        
        let year =  components.year
        let month = components.month
        
        return "Mes: \(month) Año \(year)"
    }
    
    func getNextDay() -> Date{
        let date = Calendar.current().date(byAdding: .day, value: 1, to: self, options: [])
        return date!
    }
    
    func getPreviusDay() -> Date{
        let date = Calendar.current().date(byAdding: .day, value: -1, to: self, options: [])
        return date!
    }
    
    func getNextMonth() -> Date{
        let date = Calendar.current().date(byAdding: .month, value: 1, to: self, options: [])
        return date!
    }
    
    func getPreviusMonth() -> Date{
        let date = Calendar.current().date(byAdding: .month, value: -1, to: self, options: [])
        return date!
    }
    
    func getPreviusSixMonths() -> Date{
        let date = Calendar.current().date(byAdding: .month, value: -6, to: self, options: [])
        return date!
    }
    
    func getPreviusYear() -> Date{
        let date = Calendar.current().date(byAdding: .month, value: -12, to: self, options: [])
        return date!
    }
    
    func getTextDay() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: self)
    }
    
    func getDaysOfTheMonth() -> (previusdays:[Date], monthdays:[Date]){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        var startOfMonthNS : NSDate?
        var lengthOfMonth : TimeInterval = 0
        Calendar.current().range(of: .month, start: &startOfMonthNS, interval: &lengthOfMonth, for: self)
        //print(dateFormatter.stringFromDate(startOfMonth!))
        //print("\(lengthOfMonth / 60 / 60 / 24 )")
        let days = Int(lengthOfMonth / 60 / 60 / 24)
        
        var startOfMonth : Date = startOfMonthNS as! Date
        let components = Calendar.current().components([.weekday], from: startOfMonth)
        var dayweek = components.weekday//NSCalendar.currentCalendar().dateFromComponents(components)!
        dayweek = dayweek! - 2
        if dayweek < 0 {
            dayweek = dayweek! + 7
        }

        //print("\(dayweek)")
        
        var firstdayofweek = Calendar.current().date(byAdding: .day, value: -(dayweek!), to: startOfMonth, options: [])
        //print(dateFormatter.stringFromDate(firstdayofweek!))
        
        var previusdays = [Date]()
        
        for _ in 0..<dayweek! {
            previusdays.append(firstdayofweek!)
            firstdayofweek = firstdayofweek?.getNextDay()
        }
        
        var monthdays = [Date]()
        
        for _ in 1...days {
            monthdays.append(startOfMonth)
            startOfMonth = startOfMonth.getNextDay()
        }
        
        return (previusdays, monthdays)
    }
    
}

