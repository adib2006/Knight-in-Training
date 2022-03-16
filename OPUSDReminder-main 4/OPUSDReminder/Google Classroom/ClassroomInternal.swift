//
//  ClassroomInternal.swift
//  OPUSDReminder
//
//  Created by Adib Aayan on 1/26/22.
//

import Foundation

/// Abstraction layer for fetching data in terms of app models.
class ClassroomInternal {
    
    // This class only interacts with `ClassroomRestEndpoins` class.
    
    let classroomRestEndpoints: ClassroomRestEndpoints
    
    init(accessToken: String) {
        self.classroomRestEndpoints = ClassroomRestEndpoints(accessToken: accessToken)
    }
    
    // MARK: Get Classes
    
    /// Fetches all active classes from Google Classroom (no assignments added).
    /// - Parameter completion: Called with the fetched classes.
    internal func getClasses(completion: @escaping (_ classes: [Class]) -> Void) {
        classroomRestEndpoints.getCoursesList { coursesList in
            let courses = coursesList.courses
            let classes: [Class] = courses.map { course in
                return Class(id: course.id, name: course.name, assignments: [])
            }
            completion(classes)
        }
    }
    
    // MARK: Add Next Assignments
    
    /// Adds the next 5 assignments to the provided class (including assignment states assigned).
    /// - Parameters:
    ///   - class: The class to add the next 5 assignments for.
    ///   - completion: Called with a list of the next 5 assignments.
    internal func addNextAssignments(toClass class: Class, completion: @escaping () -> Void) {
        guard !`class`.noMoreResults else { completion(); return }
        classroomRestEndpoints.getCourseWorkList(nextPageToken: `class`.nextPageToken_forAssignments, forCourseWithID: `class`.id) { [weak self, `class`] courseWorkList in
            `class`.nextPageToken_forAssignments = courseWorkList.nextPageToken
            let courseWork = courseWorkList.courseWork
            let assignments = courseWork.map { courseWork -> Assignment in
                let assignment = Assignment(classID: courseWork.courseId,
                                            id: courseWork.id,
                                            title: courseWork.title,
                                            dueDate: courseWork.dueDate,
                                            dueTime: courseWork.dueTime)
                return assignment
            }
            `class`.assignments.append(contentsOf: assignments)
            self?.addAssignmentStates(assignments: assignments) {
                completion()
            }
        }
    }
    
    // MARK: Add Assignment States
    
    /// Adds assignment states for all the provided assignments.
    /// - Parameters:
    ///   - class: The class to add all assignment states for.
    ///   - completion: Called when assignment states have been added to each assignment in the class.
    internal func addAssignmentStates(assignments: [Assignment], completion: @escaping () -> Void) {
        guard !assignments.isEmpty else { completion(); return }
        
        // Get states
        classroomRestEndpoints.getStudentSubmissions(courseId: assignments[0].classID) { [assignments] studentSubmissionList in
            let submissions = studentSubmissionList.studentSubmissions

            // Add states
            for `assignment` in assignments {
                for submission in submissions {
                    if submission.courseWorkId == `assignment`.id {
                        let state = `assignment`.getAssignmentState(for: submission)
                        `assignment`.state = state
                        break
                    }
                }
            }
            
            completion()
        }
    }
}
