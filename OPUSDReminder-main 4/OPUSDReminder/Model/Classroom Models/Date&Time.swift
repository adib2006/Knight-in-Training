//
//  Date&Time.swift
//  OPUSDReminder
//
//  Created by Adib Aayan on 12/30/21.
//

import Foundation

/// Represents a whole or partial calendar date, such as a birthday.
///
/// The time of day and time zone are either specified elsewhere or are insignificant.
///
/// The date is relative to the Gregorian Calendar. This can represent one of the following:
///
/// - A full date, with non-zero year, month, and day values
/// - A month and day value, with a zero year, such as an anniversary
/// - A year on its own, with zero month and day values
/// - A year and month value, with a zero day, such as a credit card expiration date
struct Date: Codable, CustomStringConvertible {
    /// Year of the date. Must be from 1 to 9999, or 0 to specify a date without a year.
    let year: Int
    /// Month of a year. Must be from 1 to 12, or 0 to specify a year without a month and day.
    let month: Int
    /// Day of a month. Must be from 1 to 31 and valid for the year and month, or 0 to specify a year by itself or a year and month where the day isn't significant.
    let day: Int
    
    var description: String {
        return """
        
            year = \(year)
            month = \(month)
            day = \(day)
        """
    }
}

/// Represents a time of day. The date and time zone are either not significant or are specified elsewhere.
struct TimeOfDay: Codable, CustomStringConvertible {
    /// Hours of day in 24 hour format. Should be from 0 to 23. An API may choose to allow the value "24:00:00" for scenarios like business closing time.
    let hours: Int
    /// Minutes of hour of day. Must be from 0 to 59.
    let minutes: Int?
    
    var description: String {
        return """
        
            hours = \(hours)
            minutes = \(minutes ?? 0)
        """
    }
}
