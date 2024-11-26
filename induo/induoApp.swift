//
//  induoApp.swift
//  induo
//
//  Created by Breea Toomey on 9/25/24.
//

import SwiftUI

@main
struct induoApp: App {
    @UIApplicationDelegateAdaptor(induoAppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            EntryView()
                .environmentObject(InduoAuth())
                .environmentObject(InduoClothingImage())
        }
    }
}
