//
//  RestaurantModel.swift
//  Project_IOS
//
//  Created by bouhedda bilel on 13/12/2023.
//

import Foundation

struct RestaurantModel:  Hashable, Decodable, Identifiable {
    var id_restaurant: Int
    var nom: String
    var latitude : Double
    var longitude : Double
    var photoURL: URL
    var adresse: String
    var bio: String
    var phoneNumber:String
    
    var id: Int {
        id_restaurant
    }
}
