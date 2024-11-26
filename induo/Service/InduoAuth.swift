//
//  InduoAuth.swift
//  induo
//
//  Created by Breea Toomey on 11/19/24.
//

import Foundation
import FirebaseAuth
import GoogleSignIn
import FirebaseAuthUI
import FirebaseEmailAuthUI
import FirebaseGoogleAuthUI

class InduoAuth: NSObject, ObservableObject, FUIAuthDelegate {
    let authUI: FUIAuth? = FUIAuth.defaultAuthUI()
    
    let providers: [FUIAuthProvider] = [
        FUIEmailAuth(),
        FUIGoogleAuth(authUI: FUIAuth.defaultAuthUI()!)
    ]
    
    @Published var user: User?
    
    override init() {
        super.init()
        
        authUI?.delegate = self
        authUI?.providers = providers
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if let actualResult = authDataResult {
            user = actualResult.user
        }
    }
    
    func signOut() throws {
        try authUI?.signOut()
        user = nil
    }
}


