//
//  ClassroomManager.swift
//  OPUSDReminder
//
//  Created by Adib Aayan on 12/29/21.
//

//import Foundation
//
///// Handles interacting with Google Classroom.
//class ClassroomManager {
//
//    // MARK: Public Properties
//
//    /// Use the access token to call the API, by either including the access token in the header of a REST or gRPC request (Authorization: Bearer ACCESS_TOKEN)
//    static var accessToken: String!
//
//    // MARK: Public Methods
//
//    static func setup() {
//        classroomManagers = []
//    }
//
//    /// Fetches all data from Google Classroom and stores the information in `DataManager.classes`.
//    /// - Parameter completion: Called when all data has been fetched.
//    static func fetchData(completion: @escaping () -> Void) {
//        getClasses { classes in
//            DataManager.classes = classes
//            completion()
//        }
//    }
//
//    static func getRecentAssingments(forClass class: Class, completion: @escaping (_ assignments: [Assignment]) -> Void) {
//        // TODO
//    }
//
//
//
//    // MARK: Life Cycle
//
//    init() {
//        self.rest = RestManager()
//    }
//
//    // MARK: Private Properties
//
//    /// Strong references to all the classroom managers.
//    static var classroomManagers: [ClassroomManager] = []
//    private var rest: RestManager
//    private let serviceEndpoint: String = "https://classroom.googleapis.com"
//}
//
//
//
//
//
//
//
//// MARK: ==================
//
//
//
//// MARK: Private Methods
//
//
//
//// MARK: ==================
//
//
//
//
//
//// MARK: - Abstraction Layer 1
//
//extension ClassroomManager {
//
//    // MARK: Get Classes
//
//    /// Fetches all active classes from Google Classroom, including the first 5 assignments.
//    /// - Parameter completion: Called with the fetched classes (and first 5 assignments).
//    private static func getClasses(completion: @escaping (_ classes: [Class]) -> Void) {
//        let classroomManager = ClassroomManager()
//        classroomManagers.append(classroomManager) // to keep strong reference
//        classroomManager.getCoursesList { coursesList in
//            let courses = coursesList.courses
//            let classes: [Class] = courses.map { course in
//                return Class(id: course.id, name: course.name, assignments: [])
//            }
//            let dispatchGroup = DispatchGroup()
//            classes.forEach { `class` in
//                dispatchGroup.enter()
//                addNextAssignments(toClass: `class`) {
//                    dispatchGroup.leave()
//                }
//            }
//            dispatchGroup.notify(qos: .userInitiated, queue: .main) {
//                completion(classes)
//            }
//        }
//    }
//
//    // MARK: Add Next Assignments
//
//    /// Adds the next 5 assignments to the provided class (including assignment states assigned).
//    /// - Parameters:
//    ///   - class: The class to add the next 5 assignments for.
//    ///   - completion: Called with a list of the next 5 assignments.
//    public static func addNextAssignments(toClass class: Class, completion: @escaping () -> Void) {
//        guard !`class`.noMoreResults else { completion(); return }
//        let classroomManager = ClassroomManager()
//        self.classroomManagers.append(classroomManager) // to keep strong reference
//        classroomManager.getCourseWorkList(nextPageToken: `class`.nextPageToken_forAssignments, forCourseWithID: `class`.id) { [`class`] courseWorkList in
//            `class`.nextPageToken_forAssignments = courseWorkList.nextPageToken
//            let courseWork = courseWorkList.courseWork
//            let assignments = courseWork.map { courseWork -> Assignment in
//                let assignment = Assignment(classID: courseWork.courseId,
//                                            id: courseWork.id,
//                                            title: courseWork.title,
//                                            dueDate: courseWork.dueDate,
//                                            dueTime: courseWork.dueTime)
//                return assignment
//            }
//            `class`.assignments.append(contentsOf: assignments)
//            addAssignmentStates(assignments: assignments) {
//                completion()
//            }
//        }
//    }
//
//    // MARK: Add Assignment States
//
//    /// Adds assignment states for all the provided assignments.
//    /// - Parameters:
//    ///   - class: The class to add all assignment states for.
//    ///   - completion: Called when assignment states have been added to each assignment in the class.
//    private static func addAssignmentStates(assignments: [Assignment], completion: @escaping () -> Void) {
//        guard !assignments.isEmpty else { completion(); return }
//
//        // Get states
//        let classroomManager = ClassroomManager()
//        classroomManagers.append(classroomManager) // to keep strong reference
//        classroomManager.getStudentSubmissions(courseId: assignments[0].classID) { [assignments] studentSubmissionList in
//            let submissions = studentSubmissionList.studentSubmissions
//
//            // Add states
//            for `assignment` in assignments {
//                for submission in submissions {
//                    if submission.courseWorkId == `assignment`.id {
//                        let state = `assignment`.getAssignmentState(for: submission.submissionState)
//                        `assignment`.state = state
//                        break
//                    }
//                }
//            }
//
//            completion()
//        }
//    }
//}










// MARK: - Abstraction Layer 2
//
//extension ClassroomManager {
//
//    // MARK: Get Courses
//
//    /// Gets all active courses for the currently signed in user, sending the data to the completion handler as a `CoursesList`  object.
//    /// - Parameter completion: Called with the fetched data in a`CoursesList` object.
//    private func getCoursesList(completion: @escaping (CoursesList) -> Void) {
//        let coursesList_path: String = "/v1/courses"
//        let completeEndpoint: String = serviceEndpoint + coursesList_path
//        guard let url = URL(string: completeEndpoint) else { return }
//
//        // Set headers
//        rest.requestHttpHeaders.add(value: "Bearer \(ClassroomManager.accessToken!)", forKey: "Authorization")
//
//        // Set parameters
//        rest.urlQueryParameters.add(value: "me", forKey: "studentId")
//        rest.urlQueryParameters.add(value: "ACTIVE", forKey: "courseStates")
//
//        // Set body
//            // must be empty for courses list
//
//        rest.makeRequest(toURL: url, withHttpMethod: .get) { results in
//            if let response = results.response,
//               response.httpStatusCode != 200 {
//                print("HTTP status code: \(response.httpStatusCode)")
//            }
//            if let error = results.error {
//                print("Error making request: \(error)")
//            }
//
//            if let data = results.data {
//                let decoder = JSONDecoder()
//                decoder.keyDecodingStrategy = .convertFromSnakeCase
//                guard let coursesList = try? decoder.decode(CoursesList.self, from: data) else {
//                    print("Could not decode data into Courses List.")
//                    return
//                }
//                completion(coursesList)
//            }
//        }
//    }
//
//    // MARK: Get Course Work
//
//    /// Gets the course work for the course with the provided ID, sending back the data to the completion handler as a `CourseWorkList` object.
//    /// - Parameters:
//    ///   - nextPageToken: The token (if any) indicating that the subsequent page of results should be returned.
//    ///   - courseId: The id of the course to fetch work for.
//    ///   - completion: Called with the fetched course work.
//    private func getCourseWorkList(nextPageToken: String? = nil, forCourseWithID courseId: String, completion: @escaping (CourseWorkList) -> Void) {
//        let courseWorkList_path: String = "/v1/courses/\(courseId)/courseWork"
//        let completeEndpoint: String = serviceEndpoint + courseWorkList_path
//        guard let url = URL(string: completeEndpoint) else {
//            print("Invalid URL.")
//            return
//        }
//
//        rest = RestManager()
//
//        // Set headers
//        rest.requestHttpHeaders.add(value: "Bearer \(ClassroomManager.accessToken!)", forKey: "Authorization")
//
//        // Set parameters
//        rest.urlQueryParameters.add(value: "dueDate desc", forKey: "orderBy")
//        rest.urlQueryParameters.add(value: "5", forKey: "pageSize")
//        if let token = nextPageToken {
//            rest.urlQueryParameters.add(value: token, forKey: "pageToken")
//        }
//
//        // Set body
//            // must be empty for courses list
//
//        rest.makeRequest(toURL: url, withHttpMethod: .get) { results in
//            if let response = results.response,
//               response.httpStatusCode != 200 {
//                print("HTTP status code: \(response.httpStatusCode)")
//            }
//            if let error = results.error {
//                print("Error making request: \(error)")
//            }
//
//            if let data = results.data {
//                let decoder = JSONDecoder()
//                decoder.keyDecodingStrategy = .convertFromSnakeCase
//                guard let courseWorkList = try? decoder.decode(CourseWorkList.self, from: data) else {
//                    print("Could not decode data into Course Work List.")
//                    return
//                }
//                completion(courseWorkList)
//            }
//        }
//    }
//
//    // MARK: Get Student Submissions
//
//    /// Gets all student submissions for the course with the provided course ID.
//    /// - Parameters:
//    ///   - courseId: The id of the course to fetch student submissions for.
//    ///   - completion: Called with the fetched data in a `StudentSubmissionList` object.
//    private func getStudentSubmissions(courseId: String, completion: @escaping (StudentSubmissionList) -> Void) {
//        let path: String = "/v1/courses/\(courseId)/courseWork/-/studentSubmissions"
//        let completeEndpoint: String = serviceEndpoint + path
//        guard let url = URL(string: completeEndpoint) else {
//            print("Invalid URL.")
//            return
//        }
//
//        rest = RestManager()
//
//        // Set headers
//        rest.requestHttpHeaders.add(value: "Bearer \(ClassroomManager.accessToken!)", forKey: "Authorization")
//
//        // Set parameters
//        rest.urlQueryParameters.add(value: "me", forKey: "userId")
//
//        // Set body
//            // must be empty for courses list
//
//        rest.makeRequest(toURL: url, withHttpMethod: .get) { results in
//            if let response = results.response,
//               response.httpStatusCode != 200 {
//                print("HTTP status code: \(response.httpStatusCode)")
//            }
//            if let error = results.error {
//                print("Error making request: \(error)")
//            }
//
//            if let data = results.data {
//                let decoder = JSONDecoder()
//                decoder.keyDecodingStrategy = .convertFromSnakeCase
//                guard let studentSubmissionList = try? decoder.decode(StudentSubmissionList.self, from: data) else {
//                    print("Could not decode data into Student Submission List.")
//                    return
//                }
//                completion(studentSubmissionList)
//            }
//        }
//    }
//}








































// MARK: Save

/*
/// Fetches all the student's assingment data from Google Classroom, storing the data in the DataManager.
/// - Parameters:
///   - nextPageToken: Token returned from a previous list call, indicating that the subsequent page of results should be returned.
///
///     The list request must be otherwise identical to the one that resulted in this token.
///
///   - completion: Called when all data has been fetched successfully.
private static func getData(completion: @escaping () -> Void) {
    
    tempClasses = []
    
    // Get Courses
    let classroomManager = ClassroomManager()
    classroomManagers.append(classroomManager) // to keep strong reference
    
    classroomManager.getCoursesList { coursesList in
        guard let courses = coursesList.courses else {
            print("\u{274C} Fetched courses was nil.")
            return
        }
        
        numCWLfetched = 0
        numCWLtoFetch = courses.count
        CWLdone = false
        numSTfetched = 0
        numSTtoFetch = courses.count
        STdone = false
        
        courses.forEach { course in
            
            let `class` = Class(id: course.id, name: course.name, assignments: [])
            tempClasses.append(`class`)
            
            // Get Course's Course Work List
            let classroomManager = ClassroomManager()
            self.classroomManagers.append(classroomManager) // to keep strong reference
            
            classroomManager.getCourseWorkList(nextPageToken: nextPageToken, forCourseWithID: course.id) { [`class`] courseWorkList in
                numCWLfetched += 1
                if let courseWork = courseWorkList?.courseWork {
                    courseWork.forEach { work in
                        let assignment = Assignment(classID: work.courseId,
                                                    id: work.id,
                                                    title: work.title,
                                                    dueDate: work.dueDate,
                                                    dueTime: work.dueTime)
                        `class`.assignments.append(assignment)
                    }
                }
                if numCWLfetched == numCWLtoFetch {
                    CWLdone = true
                    if STdone {
                        consolidateData()
                        DataManager.classes = tempClasses
                        completion()
                    }
                }
            }
            
            // Get Course's Student Submissions
            let classroomManager2 = ClassroomManager()
            classroomManagers.append(classroomManager2) // to keep strong reference

            classroomManager.getStudentSubmissions(courseId: course.id) { [`class`] studentSubmissionList in
                numSTfetched += 1
                if let studentSubmissions = studentSubmissionList?.studentSubmissions {
                    studentSubmissions.forEach { studentSubmission in
                        let missingWork = MissingWork(classID: studentSubmission.courseId,
                                                      assignmentID: studentSubmission.courseWorkId, id: studentSubmission.id)
                        `class`.missingWork.append(missingWork)
                    }
                }
                if numSTfetched == numSTtoFetch {
                    STdone = true
                    if CWLdone {
                        consolidateData()
                        DataManager.classes = tempClasses
                        completion()
                    }
                }
            }
        }
    }
}
private static var numCWLtoFetch: Int = 0
private static var numCWLfetched: Int = 0
private static var CWLdone: Bool = false
private static var numSTtoFetch: Int = 0
private static var numSTfetched: Int = 0
private static var STdone: Bool = false


static func getData(forClass class: Class, completion: @escaping (_ class: Class) -> Void) {
    
    let classroomManager = ClassroomManager()
    self.classroomManagers.append(classroomManager) // to keep strong reference
    
    // Get Class's Assignments
    
    classroomManager.getCourseWorkList(nextPageToken: `class`.nextPageToken_forAssignments, forCourseWithID: `class`.id) { [`class`] courseWorkList in
        courseWorkList.
        if let courseWork = courseWorkList?.courseWork {
            courseWork.forEach { work in
                let assignment = Assignment(classID: work.courseId,
                                            id: work.id,
                                            title: work.title,
                                            dueDate: work.dueDate,
                                            dueTime: work.dueTime)
                `class`.assignments.append(assignment)
            }
        }
                DataManager.classes = tempClasses
                completion()
    }
    
    // Get Course's Student Submissions
    let classroomManager2 = ClassroomManager()
    classroomManagers.append(classroomManager2) // to keep strong reference

    classroomManager.getStudentSubmissions(courseId: course.id) { [`class`] studentSubmissionList in
        numSTfetched += 1
        if let studentSubmissions = studentSubmissionList?.studentSubmissions {
            studentSubmissions.forEach { studentSubmission in
                let missingWork = MissingWork(classID: studentSubmission.courseId,
                                              assignmentID: studentSubmission.courseWorkId, id: studentSubmission.id)
                `class`.missingWork.append(missingWork)
            }
        }
        if numSTfetched == numSTtoFetch {
            STdone = true
            if CWLdone {
                consolidateData()
                DataManager.classes = tempClasses
                completion()
            }
        }
    }
}

static func getData(forClass class: Class, completion: @escaping (_ class: Class) -> Void) {
    
    let classroomManager = ClassroomManager()
    self.classroomManagers.append(classroomManager) // to keep strong reference
    
    // Get Class's Assignments
    
    classroomManager.getCourseWorkList(nextPageToken: `class`.nextPageToken_forAssignments, forCourseWithID: `class`.id) { [`class`] courseWorkList in
        courseWorkList.
        if let courseWork = courseWorkList?.courseWork {
            courseWork.forEach { work in
                let assignment = Assignment(classID: work.courseId,
                                            id: work.id,
                                            title: work.title,
                                            dueDate: work.dueDate,
                                            dueTime: work.dueTime)
                `class`.assignments.append(assignment)
            }
        }
                DataManager.classes = tempClasses
                completion()
    }
    
    // Get Course's Student Submissions
    let classroomManager2 = ClassroomManager()
    classroomManagers.append(classroomManager2) // to keep strong reference

    classroomManager.getStudentSubmissions(courseId: course.id) { [`class`] studentSubmissionList in
        numSTfetched += 1
        if let studentSubmissions = studentSubmissionList?.studentSubmissions {
            studentSubmissions.forEach { studentSubmission in
                let missingWork = MissingWork(classID: studentSubmission.courseId,
                                              assignmentID: studentSubmission.courseWorkId, id: studentSubmission.id)
                `class`.missingWork.append(missingWork)
            }
        }
        if numSTfetched == numSTtoFetch {
            STdone = true
            if CWLdone {
                consolidateData()
                DataManager.classes = tempClasses
                completion()
            }
        }
    }
}
 
// Conslidate Data
 
 /// Consolidates data by setting each assignment's `.status` property depending on if it's missing, assigned, or turned in.
 private static func consolidateData() {
     tempClasses.forEach { `class` in
         `class`.assignments.forEach { `assignment` in
             if `class`.missingWork.contains(where: { $0.assignmentID == `assignment`.id }) {
                 `assignment`.status = .turnedIn
             }
             else { // Could be missing
                 if `assignment`.localDueDateTime < Foundation.Date.now {
                     `assignment`.status = .missing
                 }
                 else {
                     `assignment`.status = .assigned
                 }
             }
         }
     }
 }
 
 
 // MARK - Get Student Submissions (based on nextPageToken)
 
 /// Gets the next set of student submissions (based on the next page token parameter), for the course with the provided course ID.
 /// - Parameters:
 ///   - nextPageToken: The token (if any) indicating that the subsequent page of results should be returned.
 ///   - courseId: The id of the course.
 ///   - completion: Called with the fetched data in a `StudentSubmissionList` object.
 private func getStudentSubmissions(nextPageToken: String?, courseId: String, completion: @escaping (StudentSubmissionList) -> Void) {
     let path: String = "/v1/courses/\(courseId)/courseWork/-/studentSubmissions"
     let completeEndpoint: String = serviceEndpoint + path
     guard let url = URL(string: completeEndpoint) else {
         print("Invalid URL.")
         return
     }
     
     rest = RestManager()
     
     // Set headers
     rest.requestHttpHeaders.add(value: "Bearer \(ClassroomManager.accessToken!)", forKey: "Authorization")
     
     // Set parameters
     rest.urlQueryParameters.add(value: "me", forKey: "userId")
     rest.urlQueryParameters.add(value: "5", forKey: "pageSize")
     if let token = nextPageToken {
         rest.urlQueryParameters.add(value: token, forKey: "pageToken")
     }
     //rest.urlQueryParameters.add(value: "me", forKey: "userId")
//        rest.urlQueryParameters.add(value: "NEW", forKey: "states")
//        rest.urlQueryParameters.add(value: "RETURNED", forKey: "states")
//        rest.urlQueryParameters.add(value: "CREATED", forKey: "states")
//        rest.urlQueryParameters.add(value: "RECLAIMED_BY_STUDENT", forKey: "states")
     //rest.urlQueryParameters.add(value: "TURNED_IN", forKey: "states")
//        rest.urlQueryParameters.add(value: "SUBMISSION_STATE_UNSPECIFIED", forKey: "states")
     
     // Set body
         // must be empty for courses list
     
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
*/
