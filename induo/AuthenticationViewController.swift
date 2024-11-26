//
//  AuthenticationViewController.swift
//  induo
//
//  Created by Breea Toomey on 11/19/24.
//

import Foundation
import SwiftUI
import UIKit
import FirebaseAuthUI

struct AuthenticationViewController: UIViewControllerRepresentable {
    var authUI: FUIAuth

    func makeUIViewController(context: Context) -> UINavigationController {
        return authUI.authViewController()
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        // We don’t do any updates so we leave this blank.
    }
}
