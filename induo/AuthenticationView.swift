//
//  AuthenticationView.swift
//  induo
//
//  Created by Breea Toomey on 11/19/24.
//

import SwiftUI

struct AuthenticationView: View {
    @EnvironmentObject var auth: InduoAuth
    @State var requestLogin = false
    
    var body: some View {
        if let authUI = auth.authUI {
            HomeView(requestLogin: $requestLogin)
                .sheet(isPresented: $requestLogin) {
                    AuthenticationViewController(authUI: authUI)
                }
        } else {
            Text("Error")
        }
    }
    
}

#Preview {
    AuthenticationView().environmentObject(InduoAuth())
}

