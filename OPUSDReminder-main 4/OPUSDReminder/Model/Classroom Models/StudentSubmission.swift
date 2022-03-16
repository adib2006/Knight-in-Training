//
//  StudentSubmission.swift
//  OPUSDReminder
//
//  Created by Adib Aayan on 1/2/22.
//

import Foundation

struct StudentSubmissionList: Codable {
    let studentSubmissions: [StudentSubmission]
}

struct StudentSubmission: Codable {
    let courseId: String
    let courseWorkId: String
    let id: String
    var assignedGrade: Double?
    private let state: String
    var submissionState: SubmissionState {
        return SubmissionState(rawValue: state) ?? .CREATED
    }
}

enum SubmissionState: String {
    case SUBMISSION_STATE_UNSPECIFIED
    case NEW
    case CREATED
    case TURNED_IN
    case RETURNED
    case RECLAIMED_BY_STUDENT
}
