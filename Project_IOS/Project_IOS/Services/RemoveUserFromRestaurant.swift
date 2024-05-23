//
//  RemoveUserFromRestaurant.swift
//  Project_IOS
//
//  Created by dany raphael on 09/01/2024.
//

import Foundation
struct RemoveUserFromRestaurant {
    func removeUserFromRestaurant(id_user: Int, id_restaurant: Int) async throws {
        let baseURL = "http://10.248.3.21:3000/"
        let endpoint = "\(baseURL)users/restaurant/\(id_user)/\(id_restaurant)"
        
        guard let url = URL(string: endpoint) else {
            throw ApiError.invalidUrl
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        let (_, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw ApiError.invalidStatusCode
        }
    }
}
