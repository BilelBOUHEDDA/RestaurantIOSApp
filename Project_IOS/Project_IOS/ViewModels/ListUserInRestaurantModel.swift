import Foundation

@MainActor
class ListUserInRestaurantModel: ObservableObject {
    @Published var listUserInRestaurant: [UserModel]?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var listUserInRestaurantService = ListUserInRestaurantService()

    func loadListUserInRestaurant(restaurantId: Int) async {
            isLoading = true
            errorMessage = nil

            do {
                let user_list = try await listUserInRestaurantService.fetchListUserInRestaurant(restaurantId: restaurantId)
                listUserInRestaurant = user_list
            } catch {
                errorMessage = "Failed to load users: \(error)"
                print(error)
            }
            isLoading = false
        }
    }
