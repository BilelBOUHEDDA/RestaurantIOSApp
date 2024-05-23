import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = RestaurantViewModel()
    @State private var selectedRestaurant: RestaurantModel?
    @StateObject private var listUserModel = ListUserInRestaurantModel()
    @State private var showingForm = true
    @State private var showingEditUserView = false
    @State private var lastUserId: Int?
    @State private var selectedLastRestaurant: Int?
    @State private var userToEdit = UserModel(
        id_user: nil,
        nom: "",
        prenom: "",
        profession: "",
        interets: "",
        age: 0,
        mail: "",
        genre: "Non spécifié"
    )
    
    private func fetchAndEditUser() async {
            guard let userId = lastUserId else { return }
            do {
                let user = try await UserService().fetchUserById(id: userId)
                print(user)
                userToEdit = user
                showingEditUserView = true
            } catch {
                print("Erreur lors de la récupération de l'utilisateur: \(error)")
            }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if let restaurants = viewModel.restaurants {
                    MapView(restaurants: restaurants, selectedRestaurant: $selectedRestaurant)
                        .sheet(item: $selectedRestaurant) { restaurant in
                            RestaurantByIdInfo(selectedRestaurantId: restaurant.id_restaurant, lastUserId: $lastUserId, selectedLastRestaurant: $selectedLastRestaurant)
                        }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        Task {
                            await fetchAndEditUser()
                        }
                    }) {
                        Text("Modifier ses informations")
                    }
                }
            }
            .sheet(isPresented: $showingEditUserView) {
                EditUserView(showingEditForm: $showingEditUserView, user: $userToEdit) { updatedUser in
                    userToEdit = updatedUser
                }
            }
            .sheet(isPresented: $showingForm) {
                AddUserView(showingForm: $showingForm) { userId in
                    lastUserId = userId
                }
            }

        }
        .task {
            await viewModel.loadRestaurants()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
