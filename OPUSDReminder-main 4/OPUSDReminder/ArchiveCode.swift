//
//  ArchiveCode.swift
//  OPUSDReminder
//
//  Created by Adib Aayan on 3/9/22.
//

// This file contains old code that is unneeded, but I'm saving it here just in case.

/*
// MARK: Subscribe to Push Notes

internal func subscribeToPushNotifications(forCourseId courseId: String) {
    printUpdate("Attempting to subscribe to push notifications")
    
    let coursesList_path: String = "/v1/registrations"
    let completeEndpoint: String = serviceEndpoint + coursesList_path
    
    let urlString = "https://classroom.googleapis.com/v1/registrations"
    
    let dictionary = [
        "feed": [
            "feedType": "COURSE_WORK_CHANGES",
            "courseWorkChangesInfo": [
                "courseId": "450357464371"
            ]
        ],
        "cloudPubsubTopic": [
            "topicName": "projects/opusdreminder-336709/topics/Courses"
        ]
    ]
    
    AF.request(urlString,
               method: .post,
               parameters: dictionary,
               encoding: JSONEncoding.default,
               headers: HTTPHeaders([HTTPHeader(name: "Authorization", value: "Bearer \(accessToken!)")]),
               interceptor: nil,
               requestModifier: nil).response { response in
        print("Status code: \(response.response?.statusCode)")
    }
    
    // Set body
//        let feed = Feed(feedType: .COURSE_WORK_CHANGES, courseRosterChangesInfo: nil, courseWorkChangesInfo: CourseWorkChangesInfo(courseId: courseId))
////        let cloudPubsubTopic = CloudPubsubTopic(topicName: "Courses")
//        let cloudPubsubTopic = CloudPubsubTopic(topicName: "projects/opusdreminder-336709/topics/Courses")
//        let registration = Registration(registrationId: nil, feed: feed, expiryTime: nil, cloudPubsubTopic: cloudPubsubTopic)
    
//        let data2 = JSONSerialization.data(withJSONObject: httpBodyParameters.allValues(), options: [.prettyPrinted, .sortedKeys])
//        let jsonObject = try? JSONSerialization.data(withJSONObject: dictionary, options: [])
//        if jsonObject != nil {
//            printSuccess("K")
//        }
//        else {
//            printError("Shoot")
//        }
//
//        print("Course id: \(courseId)")
    // Instantiate Rest Manager
//        self.rest = RestManager()
    
    // Set headers
//        rest.requestHttpHeaders.add(value: "Bearer \(accessToken!)", forKey: "Authorization")
//        print("Access token: \(accessToken!)")
    // Set parameters
//        rest.urlQueryParameters.add(value: "me", forKey: "studentId")
//        rest.urlQueryParameters.add(value: "ACTIVE", forKey: "courseStates")
    /*
    // Set body
    let feed = Feed(feedType: .COURSE_WORK_CHANGES, courseRosterChangesInfo: nil, courseWorkChangesInfo: CourseWorkChangesInfo(courseId: courseId))
//        let cloudPubsubTopic = CloudPubsubTopic(topicName: "Courses")
    let cloudPubsubTopic = CloudPubsubTopic(topicName: "projects/opusdreminder-336709/topics/Courses")
    let registration = Registration(registrationId: nil, feed: feed, expiryTime: nil, cloudPubsubTopic: cloudPubsubTopic)
    let encoder = JSONEncoder()
    var data: Data? = nil
    do {
        data = try encoder.encode(registration)
        printSuccess("Encoded Registration object to JSON.")
    } catch {
        printError("Could not encode Registration object to JSON: \(error)")
        return
    }
    print(data)
    */
    
//        let dictionary: [String : Any] = [
//          "feed": [
//            "feedType": "COURSE_WORK_CHANGES",
//            "courseWorkChangesInfo": [
//                "courseId": "450357464371"
//            ]
//          ],
//          "cloudPubsubTopic": [
//            "topicName": "projects/opusdreminder-336709/topics/Courses"
//          ]
//        ]
    
//        let data2 = JSONSerialization.data(withJSONObject: httpBodyParameters.allValues(), options: [.prettyPrinted, .sortedKeys])
//        let jsonObject = try? JSONSerialization.data(withJSONObject: dictionary, options: [])
//        if jsonObject != nil {
//            printSuccess("K")
//        }
//        else {
//            printError("Shoot")
//        }
//        rest.httpBody = jsonObject
    
//        rest.httpBody = data
    
    // Create URL
//        let coursesList_path: String = "/v1/registrations"
//        let completeEndpoint: String = serviceEndpoint + coursesList_path
//        guard let url = URL(string: completeEndpoint) else {
//            print("Invalid url")
//            return
//        }
    
//        rest.makeRequest(toURL: url, withHttpMethod: .post) { results in
//            if let response = results.response,
//               response.httpStatusCode != 200 {
//                printError("HTTP status code: \(response.httpStatusCode)")
//                print(results.error)
//                print(results.data)
//                print(response.response)
//                print(response.headers)
//                return
//            }
//            if let error = results.error {
//                printError("Error making request: \(error.localizedDescription)")
//                return
//            }
//            print("\u{2705} Subscribed to push note successfully.")
//        }
}
 */

/*
// MARK: - Database Manager

class DatabaseManager {
    /// Reference to the app's root Realtime Database node.
    static let databaseRef: DatabaseReference = Database.database().reference()
    static var userId: String = ""
    
    // Users save their device notification tokens to `/Users/{userId}/pushToken.
    static func updatePushToken(token: String) {
        databaseRef.child("Users").child(userId).updateChildValues(["pushToken": token])
    }
}
*/
