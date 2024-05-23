import Foundation

struct AddUserService {
    func addUser(formData: UserModel) async throws -> Int {
        let baseURL = "http://10.248.3.21:3000/"
        let endpoint = baseURL + "users"
        guard let url = URL(string: endpoint) else {
            throw ApiError.invalidUrl
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let jsonData = try JSONEncoder().encode(formData)
        request.httpBody = jsonData

        let (data, response) = try await URLSession.shared.upload(for: request, from: jsonData)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw ApiError.invalidStatusCode
        }
        
        guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let results = jsonObject["results"] as? [String: Any],
              let userId = results["insertId"] as? Int else {
            throw ApiError.failedToDecode
        }

        return userId
    }
}
