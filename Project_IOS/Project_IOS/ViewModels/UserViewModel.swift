import Foundation

@MainActor
class UserViewModel: ObservableObject {
    @Published var users: [UserModel] = []
    @Published var selected_user: UserModel?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var userService = UserService()

    func loadUsers() async {
        isLoading = true
        errorMessage = nil

        do {
            users = try await userService.fetchUsers()
        } catch {
            errorMessage = "Failed to load users: \(error)"
            print(error)
        }
        isLoading = false
    }
    
    func loadUserById(id: Int) async {
        isLoading = true
        errorMessage = nil

        do {
            selected_user = try await userService.fetchUserById(id: id)
        } catch {
            errorMessage = "Failed to load user: \(error)"
            print(error)
        }
        isLoading = false
    }
}
