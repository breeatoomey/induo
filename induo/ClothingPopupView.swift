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
    
    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .cornerRadius(10)
            
            // Action buttons
            HStack {
                Button(action: {
                    print("Add tapped")
                    isShowingPopup = false
                }) {
                    Text("Add")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
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
                
                Button(action: {
                    print("Make Outfit tapped") //Current print statement placehold
                    isShowingPopup = false
                }) {
                    Text("Make Outfit")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
            
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

struct ClothingPopupView_Previews: PreviewProvider {
    static var previews: some View {
        ClothingPopupView(imageName: "outfit1", isShowingPopup: .constant(true))
    }
}
