//
//  EntryView.swift
//  induo
//
//  Created by Breea Toomey on 11/20/24.
//

import SwiftUI

struct EntryView: View {
    var body: some View {
        AuthenticationView()
    }
}

#Preview {
    EntryView()
        .environmentObject(InduoAuth())
}
