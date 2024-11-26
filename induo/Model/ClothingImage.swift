//
//  ClothingImage.swift
//  induo
//
//  Created by Breea Toomey on 11/20/24.
//

import Foundation

struct ClothingImage: Hashable, Codable, Identifiable {
    var id: UUID
    var clothingType: String
    var timeStamp: Double
}
