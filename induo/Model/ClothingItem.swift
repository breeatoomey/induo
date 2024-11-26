//
//  ClothingItem.swift
//  induo
//
//  Created by Breea Toomey on 11/20/24.
//

import Foundation

struct ClothingImage: Hashable, Codable, Identifiable {
    var id: String
    var imageURL: Data
    var timeStamp: Double
}
