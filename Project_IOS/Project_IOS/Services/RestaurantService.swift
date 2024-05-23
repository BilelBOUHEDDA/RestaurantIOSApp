import Foundation

enum ApiError: Error {
    case failed
    case failedToDecode
    case invalidUrl
    case invalidStatusCode
}

struct RestaurantServices {
    func fetchRestaurants() async throws -> [RestaurantModel] {
        let baseURL = "http://10.248.3.21:3000/"
        let endpoint = baseURL + "restaurants"
        guard let url = URL(string: endpoint) else {
            throw ApiError.invalidUrl
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw ApiError.invalidStatusCode
        }

        let decodedData = try JSONDecoder().decode([RestaurantModel].self, from: data)

        return decodedData
    }
}
