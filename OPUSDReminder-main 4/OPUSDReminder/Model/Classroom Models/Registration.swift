//
//  Registration.swift
//  OPUSDReminder
//
//  Created by Adib Aayan on 1/18/22.
//

import Foundation

struct Registration: Codable {
    var registrationId: String?
    let feed: Feed
    var expiryTime: String?
    let cloudPubsubTopic: CloudPubsubTopic
}

// MARK: Feed

struct Feed: Codable {
    var feedType: FeedType
    var courseRosterChangesInfo: CourseRosterChangesInfo?
    var courseWorkChangesInfo: CourseWorkChangesInfo
}

enum FeedType: String, Codable {
    case FEED_TYPE_UNSPECIFIED
    case DOMAIN_ROSTER_CHANGES
    case COURSE_ROSTER_CHANGES
    case COURSE_WORK_CHANGES
}

struct CourseRosterChangesInfo: Codable {
    let courseId: String
}

struct CourseWorkChangesInfo: Codable {
    let courseId: String
}

// MARK: CloudPubsubTopic

struct CloudPubsubTopic: Codable {
    let topicName: String
}
