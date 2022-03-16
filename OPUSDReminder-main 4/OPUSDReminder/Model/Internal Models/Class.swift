//
//  Class.swift
//  OPUSDReminder
//
//  Created by Adib Aayan on 12/30/21.
//

import Foundation

class Class {
    let id: String
    let name: String
    var assignments: [Assignment]
    /// The token to identify the next subset of assignments to fetch, in the case that the user taps the "load more" button.
    var nextPageToken_forAssignments: String? {
        didSet {
            if nextPageToken_forAssignments == nil {
                noMoreResults = true
            }
        }
    }
    var noMoreResults: Bool = false
    
    
    init(id: String, name: String, assignments: [Assignment] = [], nextPageToken_forAssignments: String? = nil) {
        self.id = id
        self.name = name
        self.assignments = assignments
        self.nextPageToken_forAssignments = nextPageToken_forAssignments
    }
}
