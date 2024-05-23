import Foundation

@MainActor
class RestaurantViewModel: ObservableObject {
    @Published var restaurants: [RestaurantModel]?
    @Published var selectedRestaurant: RestaurantModel? // For storing details of a selected restaurant
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var restaurantService = RestaurantServices()
    private var restaurantServiceById = RestaurantServiceByID()

    func loadRestaurants() async {
        isLoading = true
        errorMessage = nil

        do {
            restaurants = try await restaurantService.fetchRestaurants()
        } catch {
            errorMessage = "Failed to load restaurants: \(error)"
            print(error)
        }

        isLoading = false
    }
    
   
    func loadRestaurantDetailsById(_ id: Int) async {
        isLoading = true
        errorMessage = nil

        do {
            let restaurant = try await restaurantServiceById.fetchRestaurantById(id: id)
            selectedRestaurant = restaurant
        } catch {
            errorMessage = "Failed to load restaurant details: \(error)"
            print(error)
        }

        isLoading = false
    }
}
