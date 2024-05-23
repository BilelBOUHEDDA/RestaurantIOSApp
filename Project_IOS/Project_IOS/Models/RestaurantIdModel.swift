//
//  RestaurantIdModel.swift
//  Project_IOS
//
//  Created by bouhedda bilel on 20/12/2023.
//

import Foundation

struct RestaurantIdModel : Codable, Hashable {
    var id_restaurant: Int
    var nom: String
    var photoURL: URL
}
