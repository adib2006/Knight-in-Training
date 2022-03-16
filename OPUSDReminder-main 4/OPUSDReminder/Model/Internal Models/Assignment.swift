//
//  Assignment.swift
//  OPUSDReminder
//
//  Created by Adib Aayan on 12/30/21.
//

import Foundation

enum AssignmentState {
    /// An assignment that has a future due date and hasn't been turned in yet.
    case assigned
    /// An assignment that has been turned in (past or future).
    case turnedIn
    /// An assignment that has a past due date and hasn't been turned in yet.
    case missing
}

class Assignment {
    let classID: String
    let id: String
    let title: String
    let dueDate: Date?
    let dueTime: TimeOfDay?
    var state: AssignmentState
    
    var `class`: Class? = nil
    
    init(classID: String, id: String, title: String, dueDate: Date?, dueTime: TimeOfDay?, state: AssignmentState = .assigned) {
        self.classID = classID
        self.id = id
        self.title = title
        self.dueDate = dueDate
        self.dueTime = dueTime
        self.state = state
    }
    
    func getAssignmentState(for studentSubmission: StudentSubmission) -> AssignmentState {
        let studentSubmissionState = studentSubmission.submissionState
        switch studentSubmissionState {
        case .SUBMISSION_STATE_UNSPECIFIED:
            return self.pastDue ? .missing : .assigned
        case .NEW:
            return self.pastDue ? .missing : .assigned
        case .CREATED:
            return self.pastDue ? .missing : .assigned
        case .TURNED_IN:
            return .turnedIn
        case .RETURNED:
            if studentSubmission.assignedGrade == nil {
                return self.pastDue ? .missing : .assigned
            }
            else {
                return .turnedIn
            }
        case .RECLAIMED_BY_STUDENT:
            return self.pastDue ? .missing : .assigned
        }
    }
    
    /// The local date & time (`Foundation.Date`) the assignment is due (or a date in the distant future if there is no date specified).
    var localDueDateTime: Foundation.Date {
        guard let dueDate = dueDate else { return Foundation.Date.distantFuture }
        let dateComponents = DateComponents(timeZone: TimeZone(abbreviation: "UTC"),year: dueDate.year, month: dueDate.month, day: dueDate.day, hour: dueTime?.hours ?? 23, minute: dueTime != nil ? (dueTime?.minutes ?? 0) : (59))
        guard let date = Calendar.current.date(from: dateComponents) else { return Foundation.Date.distantFuture }
        return date
    }
    
    var pastDue: Bool {
        guard let dueDate = dueDate else {
            return false
        }
        let dateComponents = DateComponents(timeZone: TimeZone(abbreviation: "UTC"),
                                            year: dueDate.year,
                                            month: dueDate.month,
                                            day: dueDate.day,
                                            hour: dueTime?.hours ?? 23,
                                            minute: dueTime?.minutes ?? 59)
        guard let date = Calendar.current.date(from: dateComponents) else {
            return false
        }
        if Foundation.Date.now > date {
            return true
        }
        else {
            return false
        }
    }
    
    /// Returns either Feb 11, 1994, 11:59 pm
    var dueDateAndTimeFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        let formattedTime: String = formatter.string(from: localDueDateTime)
        return formattedTime
        
        /*
        let dueDateFormatted: String = dueDateFormatted
        let dueTimeFormatted: String = dueTimeFormatted
        if dueDateFormatted != "" {
            if dueTimeFormatted != "" {
                return "\(dueDateFormatted), \(dueTimeFormatted)"
            }
            else {
                return dueDateFormatted
            }
        }
        else {
            return ""
        }
        */
    }
    
    // MARK: - Private Helpers
    
    /// Either Feb 11, 1994 or "".
    private var dueDateFormatted: String {
        guard let dueDate = dueDate else { return "" }
        if let date = formattedDate(month: dueDate.month, day: dueDate.day) {
            return date
        }
        else {
            return "\(dueDate.month)/\(dueDate.day)/\(dueDate.year)"
        }
    }
    
    /// Either 11:59 pm or "".
    private var dueTimeFormatted: String {
        guard let dueTime = dueTime else { return "" }
        if let time = formattedTime(hour: dueTime.hours, minute: dueTime.minutes ?? 0) {
            return time
        }
        else {
            return "\(dueTime.hours):\(dueTime.minutes ?? 0)"
        }
    }

    // MARK: - Private Date Helpers
    
    private func formattedDate(month: Int, day: Int) -> String? {
        let dateComponents = DateComponents(month: month, day: day)
        guard let date = Calendar.current.date(from: dateComponents) else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        let formattedTime: String = formatter.string(from: date)
        return formattedTime
    }
    
    /// Returns the hour and minute values as something like 11:59 pm.
    ///
    /// This method returns nil if the hour and minute values are not valid.
    private func formattedTime(hour: Int, minute: Int) -> String? {
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "H:mm"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            
        let dateStr = "\(hour):\(minute)"
            if let date = dateFormatter.date(from: dateStr) {
                dateFormatter.timeZone = TimeZone.current
                dateFormatter.dateFormat = "h:mm a"
            
                return dateFormatter.string(from: date)
            }
            return nil
    }
}
