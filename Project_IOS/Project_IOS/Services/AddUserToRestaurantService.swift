//
//  AddUserToRestaurantService.swift
//  Project_IOS
//
//  Created by bouhedda bilel on 22/12/2023.
//

import Foundation

struct AddUserToRestaurantService {
    func addUserToRestaurant(id_user: Int, id_restaurant: Int, date: String) async throws {
            let baseURL = "http://10.248.3.21:3000/"
            let endpoint = baseURL + "users/restaurant"
            guard let url = URL(string: endpoint) else {
                throw ApiError.invalidUrl
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            let formData = AddUserToRestaurantModel(id_user: id_user, id_restaurant: id_restaurant, date: date)
            let jsonData = try JSONEncoder().encode(formData)
            request.httpBody = jsonData

            let (_, response) = try await URLSession.shared.upload(for: request, from: jsonData)

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw ApiError.invalidStatusCode
            }
        }
}
