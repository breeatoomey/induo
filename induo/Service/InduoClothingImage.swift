//
//  InduoClothingImage.swift
//  induo
//
//  Created by Breea Toomey on 11/20/24.
//

import Foundation
import Firebase
import FirebaseFirestore

class InduoClothingImage: ObservableObject {
    func uploadImage(userId: String, id: String, clothingType: String) {
        let db = Firestore.firestore()
        let userDocRef = db.collection("users").document(userId)
        
        let imageRef = userDocRef.collection("clothing images")
        
        imageRef.addDocument(data: ["id": id,
                                    "clothing type": clothingType,
                                    "timestamp": Date().timeIntervalSince1970,
                                   ])
    }
}


