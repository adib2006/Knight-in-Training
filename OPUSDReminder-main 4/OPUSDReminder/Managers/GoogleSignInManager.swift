//
//  GoogleSignInManager.swift
//  OPUSDReminder
//
//  Created by Adib Aayan on 12/29/21.
//

import Foundation
import GoogleSignIn

/// Handles signing in to Google, and adding scopes.
class GoogleSignInManager {
    
    // MARK: - Public Properties
    
    static var hasScopes: Bool {
        guard let user = user else { return false }
        guard let grantedScopes = user.grantedScopes else { return false }
        if grantedScopes.contains(coursesScope) {
            return true
        }
        else {
            return false
        }
    }
    
    // MARK: - Private Properties
    
    private static let clientID: String = "118211344917-vtqbdmkks39u1n4l4b1l00cueq077f4m.apps.googleusercontent.com"
    private static let serverClientID: String = "118211344917-h4fajihslb5hv4aksd4k3p916lnvu6md.apps.googleusercontent.com"
    // is it ok that this is ".me" for push notifications?
//    private static let courseWorkScope = "https://www.googleapis.com/auth/classroom.coursework.students.readonly"
    
    private static let coursesScope = "https://www.googleapis.com/auth/classroom.courses.readonly"
    private static let courseWorkScope = "https://www.googleapis.com/auth/classroom.coursework.me.readonly"
    private static let pushNotifScope = "https://www.googleapis.com/auth/classroom.push-notifications"
    
    private static var user: GIDGoogleUser?
    
    private static let signInConfig: GIDConfiguration = {
      return GIDConfiguration.init(clientID: clientID, serverClientID: serverClientID)
    }()
}
    
// MARK: - Public Methods

extension GoogleSignInManager {
    
    // MARK: Restore Previous Sign In
    
    /// Attempts to restore a previously authenticated user without interaction.
    /// - Parameter completion: Completion is called with `true` if the user's previous sign-in session was restored successfully, and a refreshed access token is also provided. The completion is called with `false` if a previous sign-in session was not able to be restored, in which case the accessToken is `nil`.
    static func restorePreviousSignIn(completion: @escaping (_ signedIn: Bool, _ accessToken: String?) -> Void) {
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil || user == nil {
                completion(false, nil)
            }
            else {
                self.user = user
                getToken(forUser: user!) { accessToken in
                    completion(true, accessToken)
                }
            }
        }
    }
    
    // MARK: Sign In
    
    /// Signs in the current user, calling the completion upon success.
    /// - Parameters:
    ///   - vc: The view controller to present the Google Sign In interface from.
    ///   - completion: The completion to call upon a successful sign in. The completion is provided with a new access token for the currently authorized scopes.
    static func signIn(fromVC vc: UIViewController, completion: @escaping (_ accessToken: String) -> Void) {
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: vc) { user, error in
            guard error == nil else {
                print("Error signing in to Google: \(error!)")
                return
            }
            guard let user = user else {
                print("After signing in to Google, user was nil.")
                return
            }
            self.user = user
            getToken(forUser: user) { accessToken in
                completion(accessToken)
            }
        }
    }
    
    // MARK: Add Scopes
    
    /// Adds the scopes for the current user.
    /// - Parameters:
    ///   - vc: The view controller to present the request from.
    ///   - completion: An escaping closure that is called if the scopes have been added successfully. The completion is provided with the newly authorized access token.
    static func addScopes(fromVC vc: UIViewController, completion: @escaping (_ accessToken: String) -> Void) {
        GIDSignIn.sharedInstance.addScopes([coursesScope, courseWorkScope, pushNotifScope], presenting: vc) { user, error in
            if let error = error {
                print("Found error while adding scopes: \(error).")
                return
            }
            guard let currentUser = user else {
                print("Hmm... user was nil.")
                return
            }
            self.user = currentUser
            
            guard hasScopes else {
                print("User does not have necessary scopes.")
                return
            }
            
            getToken(forUser: currentUser) { accessToken in
                completion(accessToken)
            }
        }
    }
    
    // MARK: Sign Out
    
    /// Signs out the current user.
    static func signOut() {
        GIDSignIn.sharedInstance.signOut()
    }
    
    // MARK: Disconnect
    
    /// Disconnects the previously granted scope and signs the user out.
    static func disconnect() {
        GIDSignIn.sharedInstance.disconnect { error in
            if let error = error {
                print("Encountered error disconnecting scope: \(error).")
            }
            self.signOut()
        }
    }
}
    
// MARK: - Private Methods

extension GoogleSignInManager {
    
    // MARK: Get Token
    
    /// Gets the access token for the user.
    private static func getToken(forUser user: GIDGoogleUser, completion: @escaping (_ accessToken: String) -> Void) {
        user.authentication.do { authentication, error in
            guard error == nil else { return }
            guard let authentication = authentication else { return }
            completion(authentication.accessToken)
        }
    }
}
