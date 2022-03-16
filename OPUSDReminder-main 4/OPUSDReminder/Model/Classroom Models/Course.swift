//
//  Courses.swift
//  OPUSDReminder
//
//  Created by Adib Aayan on 12/30/21.
//

import Foundation

struct CoursesList: Codable {
    let courses: [Course]
}

struct Course: Codable {
    let id: String
    let name: String
}
