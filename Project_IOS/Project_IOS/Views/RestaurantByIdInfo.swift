        import SwiftUI

        struct RestaurantByIdInfo: View {
            @StateObject var viewModelRestaurant = RestaurantViewModel()
            @StateObject var viewModelListUserInRestaurant = ListUserInRestaurantModel()
            var selectedRestaurantId: Int
            @Binding var lastUserId: Int?
            @Binding var selectedLastRestaurant: Int?
            @State private var isUserInRestaurant = false
            @State private var isUserTryingToJoinAnotherRestaurant = false
            @State private var showAlert = false // Pour afficher une alerte


            

            var body: some View {
                NavigationView {
                    VStack {
                            // Affichage des informations du restaurant
                            if let restaurant = viewModelRestaurant.selectedRestaurant {
                                HStack(alignment: .top, spacing: 15) {
                                    AsyncImage(url: restaurant.photoURL) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                        case .success(let image):
                                            image.resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 100, height: 100)
                                                .cornerRadius(10)
                                                .shadow(radius: 5)
                                        case .failure:
                                            Image(systemName: "photo")
                                                .frame(width: 100, height: 100)
                                                .background(Color.gray.opacity(0.3))
                                                .cornerRadius(10)
                                        @unknown default:
                                            EmptyView()
                                        }
                                    }

                                    VStack(alignment: .leading) {
                                        Text(restaurant.nom)
                                            .font(.title)
                                            .bold()
                                            .foregroundColor(.primary)
                                        HStack {
                                            Image(systemName: "mappin.and.ellipse")
                                                .font(.system(size: 20))
                                                .foregroundColor(.primary)

                                            Text(restaurant.adresse)
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                        }
                                        
                                        HStack {
                                            Image(systemName: "info.circle")
                                                .font(.system(size: 20))
                                                .foregroundColor(.primary)

                                            Text(restaurant.bio)
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                        }
                                        
                                        HStack {
                                            Image(systemName: "phone.fill")
                                                .font(.system(size: 20))
                                                .foregroundColor(.primary)

                                            Text(restaurant.phoneNumber)
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                        }

                                    }
                                    .padding(.vertical)
                                }
                            }
                        
                        if let list_user = viewModelListUserInRestaurant.listUserInRestaurant {
                            Text("Liste des personnes présentes dans le restaurant")
                                .font(.headline)
                                .padding()
                                .multilineTextAlignment(.center)

                            List(list_user, id: \.id) { user in
                                NavigationLink(destination: UserByIdView(id_user: user.id_user ?? 0)) {
                                    VStack(alignment: .leading) {
                                        Text(user.nom)
                                            .font(.headline)
                                        Text(user.prenom)
                                            .font(.subheadline)
                                    }
                                }
                            }
                            .listStyle(PlainListStyle())
                        }
                        
                        if let userId = lastUserId {
                            Button(isUserInRestaurant ? "Sortir du restaurant" : "Rentrer dans le restaurant") {
                                Task {
                                    if isUserInRestaurant {
                                        await removeUserFromRestaurant(userId: userId,restaurantId: selectedRestaurantId)
                                        isUserInRestaurant = false
                                        
                                    }
                                    else {
                                        await removeUserFromRestaurant(userId: userId,restaurantId: selectedLastRestaurant ?? 1)
                                        await addUserToRestaurant(userId: userId)
                                        isUserInRestaurant = true
                                        selectedLastRestaurant = selectedRestaurantId
                                        
                                    }
                                }
                            }
                        }
                    }
                    .task {
                                        await loadInitialData()
                        await viewModelRestaurant.loadRestaurantDetailsById(selectedRestaurantId)
                        await viewModelListUserInRestaurant.loadListUserInRestaurant(restaurantId: selectedRestaurantId)
                    }
                }
            }
            
            private func addUserToRestaurant(userId: Int) async {
                let currentDate = getCurrentDate()
                do {
                    try await AddUserToRestaurantService().addUserToRestaurant(id_user: userId, id_restaurant: selectedRestaurantId, date: currentDate)
                    await viewModelListUserInRestaurant.loadListUserInRestaurant(restaurantId: selectedRestaurantId)
                } catch {
                    print("Erreur lors de l'ajout de l'utilisateur au restaurant")
                }
            }

            private func getCurrentDate() -> String {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                return dateFormatter.string(from: Date())
            }
            
            private func removeUserFromRestaurant(userId: Int, restaurantId: Int) async {
                    do {
                        try await RemoveUserFromRestaurant().removeUserFromRestaurant(id_user: userId, id_restaurant: restaurantId)
                        await viewModelListUserInRestaurant.loadListUserInRestaurant(restaurantId: restaurantId)
                    } catch {
                        print("Erreur lors de la suppression de l'utilisateur du restaurant")
                    }
                }

            private func loadInitialData() async {
                await viewModelRestaurant.loadRestaurantDetailsById(selectedRestaurantId)
                await viewModelListUserInRestaurant.loadListUserInRestaurant(restaurantId: selectedRestaurantId)
                updateIsUserInRestaurant()
            }
            
            
                
                private func updateIsUserInRestaurant() {
                    if let userId = lastUserId, let list_user = viewModelListUserInRestaurant.listUserInRestaurant {
                        isUserInRestaurant = list_user.contains(where: { $0.id_user == userId })
                    }
                }
                
            private func userIsInAnotherRestaurant() -> Bool {
                if isUserInRestaurant == true{
                    return true
                }
                return false
            }
                
            }

    

        struct RestaurantByIdInfo_Previews: PreviewProvider {
            static var previews: some View {
                RestaurantByIdInfo(selectedRestaurantId: 1, lastUserId: .constant(123), selectedLastRestaurant: .constant(123))
            }
        }
