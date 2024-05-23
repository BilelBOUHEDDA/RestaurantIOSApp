//
// ListUserInRestaurant.swift
//  Project_IOS
//
//  Created by bouhedda bilel on 13/12/2023.
//

import Foundation

struct ListUserInRestaurantService {
    func fetchListUserInRestaurant(restaurantId: Int) async throws -> [UserModel] {
        let baseURL = "http://10.248.3.21:3000/"
        let endpoint = baseURL + "restaurants/users/\(restaurantId)"
        
        guard let url = URL(string: endpoint) else {
            throw ApiError.invalidUrl
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw ApiError.invalidStatusCode
        }

        let decodedData = try JSONDecoder().decode([UserModel].self, from: data)
        
        return decodedData
    }
}

