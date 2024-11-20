//
//  ClothingPopupView.swift
//  induo
//
//  Created by Jack Seymour
//

import SwiftUI

struct ClothingPopupView: View {
    let imageName: String
    @Binding var isShowingPopup: Bool
    
    @State private var selectedType: String = "Top" // Default selected type
    let clothingTypes = ["Top", "Bottom", "Overall", "Inner", "Outer"] // Types of clothing
    
    var body: some View {
        NavigationView {
            VStack {
                // Display the selected clothing item image
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .cornerRadius(10)
                
                // Action buttons
                HStack {
                    Button(action: {
                        print("Delete tapped")
                        isShowingPopup = false
                    }) {
                        Text("Delete")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    NavigationLink(destination: ContentView()) {
                        Text("Make Outfit")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(hex: "#3f13a4"))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
                
                // Clothing type picker
                VStack(alignment: .leading) {
                    Text("Clothing Type")
                        .font(.headline)
                        .padding(.bottom, 5)
                    
                    Picker("Select Type", selection: $selectedType) {
                        ForEach(clothingTypes, id: \.self) { type in
                            Text(type).tag(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle()) // Optional: Use a segmented control style
                    .padding(.horizontal)
                }
                .padding(.bottom, 20)
                
                // Close button
                Button(action: {
                    isShowingPopup = false
                }) {
                    Text("Close")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
    }
}

struct ClothingPopupView_Previews: PreviewProvider {
    static var previews: some View {
        ClothingPopupView(imageName: "outfit1", isShowingPopup: .constant(true))
    }
}
