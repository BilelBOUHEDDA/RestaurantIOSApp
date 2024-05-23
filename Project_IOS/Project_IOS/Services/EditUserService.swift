import Foundation

struct EditUserService {
    func editUser(userId: Int, formData: UserModel) async throws {
        let baseURL = "http://10.248.3.21:3000/"
        let endpoint = baseURL + "users/\(userId)"
        guard let url = URL(string: endpoint) else {
            throw ApiError.invalidUrl
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT" 
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let jsonData = try JSONEncoder().encode(formData)
        request.httpBody = jsonData

        let (_, response) = try await URLSession.shared.upload(for: request, from: jsonData)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw ApiError.invalidStatusCode
        }
    }
}
