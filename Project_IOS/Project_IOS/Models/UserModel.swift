//
//  UserModel.swift
//  Project_IOS
//
//  Created by bouhedda bilel on 13/12/2023.
//

import Foundation

struct UserModel: Codable, Hashable,Identifiable {
    var id_user: Int?
    var id : Int { id_user ?? 0}
    var nom: String
    var prenom: String
    var profession: String
    var interets: String
    var age: Int
    var mail: String
    var genre: String
    
}
