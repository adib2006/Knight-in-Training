//
//  Classroom.swift
//  OPUSDReminder
//
//  Created by Adib Aayan on 1/26/22.
//

import Foundation

/// This class offers a high-level API the rest of the app can use to fetch data from Google Classroom.
///
/// - Note: Interact with this class via its singleton.
class Classroom {
    
    // This class only interacts with `ClassroomInternal` class.
    
    /// The singleton is created in the `GoogleSignInManager` class so that it receives the access token that was generated there.
    public static var singleton: Classroom!
    
    private let classroomInternal: ClassroomInternal

    public init(accessToken: String) {
        self.classroomInternal = ClassroomInternal(accessToken: accessToken)
    }
    
    // MARK: Get Classes
    
    /// Fetches all active classes from Google Classroom, including the first 5 assignments and their submission states.
    /// - Parameter completion: Called with the fetched classes (and first 5 assignments).
    public func getClasses(completion: @escaping (_ classes: [Class]) -> Void) {
        classroomInternal.getClasses { [classroomInternal] classes in
            let dispatchGroup = DispatchGroup()
            classes.forEach { `class` in
                dispatchGroup.enter()
                classroomInternal.addNextAssignments(toClass: `class`) {
                    dispatchGroup.leave()
                }
            }
            dispatchGroup.notify(qos: .userInitiated, queue: .main) {
                completion(classes)
            }
        }
    }
    
    // MARK: Add Next Assignments
    
    /// Adds the next 5 assignments to the provided class (including assignment states assigned).
    /// - Parameters:
    ///   - class: The class to add the next 5 assignments for.
    ///   - completion: Called with a list of the next 5 assignments.
    public func addNextAssignments(toClass class: Class, completion: @escaping () -> Void) {
        classroomInternal.addNextAssignments(toClass: `class`) {
            completion()
        }
    }
}
