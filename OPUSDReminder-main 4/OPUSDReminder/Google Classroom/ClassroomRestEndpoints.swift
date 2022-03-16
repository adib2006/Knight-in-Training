//
//  ClassroomRestEndpoints.swift
//  OPUSDReminder
//
//  Created by Adib Aayan on 1/26/22.
//

import Foundation

/// Used to fetch data from Google Classroom API REST Endpoints.
class ClassroomRestEndpoints {
    /// Access token to access Google API.
    ///
    /// Use the access token to call the API, by either including the access token in the header of a REST or gRPC request (Authorization: Bearer ACCESS_TOKEN)
    private let accessToken: String!
    private var rest: RestManager!
    private let serviceEndpoint: String = "https://classroom.googleapis.com"
    
    init(accessToken: String) {
        self.accessToken = accessToken
    }
    
    // MARK: 1. Get Courses
    
    /// Gets the `CoursesList` for all *active* courses (for the currently signed in user).
    /// - Parameter completion: Called with the fetched data in a`CoursesList` object.
    internal func getCoursesList(completion: @escaping (CoursesList) -> Void) {
        
        // Instantiate Rest Manager
        self.rest = RestManager()
        
        // Set headers
        rest.requestHttpHeaders.add(value: "Bearer \(accessToken!)", forKey: "Authorization")
        
        // Set parameters
        rest.urlQueryParameters.add(value: "me", forKey: "studentId")
        rest.urlQueryParameters.add(value: "ACTIVE", forKey: "courseStates")
        
        // Set body
        // (must be empty for courses list)
        
        // Create URL
        let coursesList_path: String = "/v1/courses"
        let completeEndpoint: String = serviceEndpoint + coursesList_path
        guard let url = URL(string: completeEndpoint) else { return }
        
        rest.makeRequest(toURL: url, withHttpMethod: .get) { results in
            if let response = results.response,
               response.httpStatusCode != 200 {
                print("HTTP status code: \(response.httpStatusCode)")
            }
            if let error = results.error {
                print("Error making request: \(error)")
            }
            
            if let data = results.data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                guard let coursesList = try? decoder.decode(CoursesList.self, from: data) else {
                    print("Could not decode data into Courses List.")
                    return
                }
                completion(coursesList)
            }
        }
    }
    
    // MARK: 2. Get Course Work
    
    /// Gets the course work for the course with the provided ID, sending back the data to the completion handler as a `CourseWorkList` object.
    /// - Parameters:
    ///   - nextPageToken: The token (if any) indicating that the subsequent page of results should be returned.
    ///   - courseId: The id of the course to fetch work for.
    ///   - completion: Called with the fetched course work.
    internal func getCourseWorkList(nextPageToken: String? = nil, forCourseWithID courseId: String, completion: @escaping (CourseWorkList) -> Void) {
        
        // Instantiate Rest Manager
        self.rest = RestManager()
        
        // Set headers
        rest.requestHttpHeaders.add(value: "Bearer \(accessToken!)", forKey: "Authorization")
        
        // Set parameters
        rest.urlQueryParameters.add(value: "dueDate desc", forKey: "orderBy")
        rest.urlQueryParameters.add(value: "5", forKey: "pageSize")
        if let token = nextPageToken {
            rest.urlQueryParameters.add(value: token, forKey: "pageToken")
        }
        
        // Set body
        // (must be empty for courses list)
        
        // Create URL
        let courseWorkList_path: String = "/v1/courses/\(courseId)/courseWork"
        let completeEndpoint: String = serviceEndpoint + courseWorkList_path
        guard let url = URL(string: completeEndpoint) else {
            print("Invalid URL.")
            return
        }
        
        rest.makeRequest(toURL: url, withHttpMethod: .get) { results in
            if let response = results.response,
               response.httpStatusCode != 200 {
                print("HTTP status code: \(response.httpStatusCode)")
            }
            if let error = results.error {
                print("Error making request: \(error)")
            }
            
            if let data = results.data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                guard let courseWorkList = try? decoder.decode(CourseWorkList.self, from: data) else {
                    print("Could not decode data into Course Work List.")
                    return
                }
                completion(courseWorkList)
            }
        }
    }
    
    // MARK: 3. Get Student Submissions
    
    /// Gets all student submissions for the course with the provided course ID.
    /// - Parameters:
    ///   - courseId: The id of the course to fetch student submissions for.
    ///   - completion: Called with the fetched data in a `StudentSubmissionList` object.
    internal func getStudentSubmissions(courseId: String, completion: @escaping (StudentSubmissionList) -> Void) {
        
        // Instantiate Rest Manager
        self.rest = RestManager()
        
        // Set headers
        rest.requestHttpHeaders.add(value: "Bearer \(accessToken!)", forKey: "Authorization")
        
        // Set parameters
        rest.urlQueryParameters.add(value: "me", forKey: "userId")
        
        // Set body
        // (must be empty for courses list)
        
        // Create URL
        let path: String = "/v1/courses/\(courseId)/courseWork/-/studentSubmissions"
        let completeEndpoint: String = serviceEndpoint + path
        guard let url = URL(string: completeEndpoint) else {
            print("Invalid URL.")
            return
        }
        
        rest.makeRequest(toURL: url, withHttpMethod: .get) { results in
            if let response = results.response,
               response.httpStatusCode != 200 {
                print("HTTP status code: \(response.httpStatusCode)")
            }
            if let error = results.error {
                print("Error making request: \(error)")
            }
            
            if let data = results.data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                guard let studentSubmissionList = try? decoder.decode(StudentSubmissionList.self, from: data) else {
                    print("Could not decode data into Student Submission List.")
                    return
                }
                completion(studentSubmissionList)
            }
        }
    }
}
