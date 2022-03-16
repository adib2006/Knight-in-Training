//
//  CourseWork.swift
//  OPUSDReminder
//
//  Created by Adib Aayan on 12/30/21.
//

import Foundation

struct CourseWorkList: Codable {
    let courseWork: [CourseWork]
    let nextPageToken: String?
}

struct CourseWork: Codable {
    let courseId: String
    let id: String
    let title: String
    let dueDate: Date?
    let dueTime: TimeOfDay?
}
