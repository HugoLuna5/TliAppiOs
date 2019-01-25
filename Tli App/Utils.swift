//
//  Utils.swift
//  Tli App
//
//  Created by Hugo Luna on 1/24/19.
//  Copyright © 2019 Luna Inc. All rights reserved.
//

import Foundation


extension Date {
    
    func getElapsedInterval() -> String {
        
        let interval = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self, to: Date())
        
        if let year = interval.year, year > 0 {
            return year == 1 ? "Hace \(year)" + " " + "año" :
                "Hace \(year)" + " " + "años"
        } else if let month = interval.month, month > 0 {
            return month == 1 ? "Hace \(month)" + " " + "mes" :
                "Hace \(month)" + " " + "meses"
        } else if let day = interval.day, day > 0 {
            return day == 1 ? "Hace \(day)" + " " + "día" :
                "Hace \(day)" + " " + "días"
        } else if let hour = interval.hour, hour > 0 {
            return hour == 1 ? "Hace \(hour)" + " " + "hora" :
                "Hace \(hour)" + " " + "horas"
        } else if let minute = interval.minute, minute > 0 {
            return minute == 1 ? "Hace \(minute)" + " " + "minuto" :
                "Hace \(minute)" + " " + "minutos"
        } else if let second = interval.second, second > 0 {
            return second == 1 ? "Hace \(second)" + " " + "segundo" :
                "Hace \(second)" + " " + "segundos"
        } else {
            return "Hace un momento"
        }
        
    }
}
