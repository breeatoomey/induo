//
//  ClosetView.swift
//  induo
//
//  Created by Jack Seymour
//

import SwiftUI
import Firebase

// Define ClothingItem struct
struct ClothingItem: Identifiable {
    var id: String
    var imageURL: String
}

// ClosetViewModel with mock data for testing
class ClosetViewModel: ObservableObject {
    @Published var clothingItems = [ClothingItem]() // ClothingItem contains image and metadata.

    init() {
        #if canImport(FirebaseFirestore) && canImport(FirebaseStorage)
        fetchClothingItems()
        #else
        loadMockData() // Use mock data when Firebase is not available
        #endif
    }
    
    #if canImport(FirebaseFirestore) && canImport(FirebaseStorage)
    private var db = Firestore.firestore()
    private var storage = Storage.storage()
    
    func fetchClothingItems() {
        db.collection("closetItems").getDocuments { snapshot, error in
            if let snapshot = snapshot {
                self.clothingItems = snapshot.documents.compactMap { document in
                    let data = document.data()
                    let imageURL = data["imageURL"] as? String ?? ""
                    return ClothingItem(id: document.documentID, imageURL: imageURL)
                }
            }
        }
    }
    #endif
    
    // Mock data function for testing without Firebase
    func loadMockData() {
        self.clothingItems = [
            ClothingItem(id: "1", imageURL: "clothes1"),
            ClothingItem(id: "2", imageURL: "clothes2"),
            ClothingItem(id: "3", imageURL: "clothes3")
            // Add more placeholders if needed
        ]
    }
}

struct ClosetView: View {
    @ObservedObject private var viewModel = ClosetViewModel()
    @State private var selectedImage: String? = nil
    @State private var isShowingPopup = false
    @State private var isShowingUploadView = false
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 10) {
                    ForEach(viewModel.clothingItems) { item in
                        Button(action: {
                            selectedImage = item.imageURL
                            isShowingPopup = true
                        }) {
                            AsyncImage(url: URL(string: item.imageURL)) { image in
                                image.resizable().scaledToFit()
                            } placeholder: {
                                Color.gray.opacity(0.2)
                            }
                            .frame(width: 60, height: 60)
                            .cornerRadius(5)
                        }
                    }
                }
                .padding()
            }
            
            // "Upload Clothing" button
            Button(action: {
                isShowingUploadView = true
            }) {
                Text("Upload Clothing")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.purple.opacity(0.7))
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .padding(.bottom, 20)

            // "Shop my Closet!" button to navigate back to ContentView
            NavigationLink(destination: ContentView()) {
                Text("Shop my Closet!")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green.opacity(0.7))
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .padding(.bottom, 20)
        }
        .navigationTitle("My Closet")
        .sheet(isPresented: $isShowingPopup) {
            if let selectedItem = selectedImage {
                ClothingPopupView(imageName: selectedItem, isShowingPopup: $isShowingPopup)
            }
        }
        .sheet(isPresented: $isShowingUploadView) {
            UploadClothingView(isShowingUploadView: $isShowingUploadView)
        }
    }
}

struct ClosetView_Previews: PreviewProvider {
    static var previews: some View {
        ClosetView()
    }
}
