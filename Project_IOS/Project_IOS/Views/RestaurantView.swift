import SwiftUI

struct RestaurantsView: View {
    @StateObject var viewModel = RestaurantViewModel()

    var body: some View {
        NavigationView {
            if let restaurants = viewModel.restaurants {
                List(restaurants ,id:\.self) { restaurant in
                    VStack(alignment: .leading) {
                        Text(restaurant.nom)
                            .font(.headline)
                        AsyncImage(url: restaurant.photoURL) { phase in
                                switch phase {
                                    case .empty:
                                        ProgressView()
                                    case .success(let image):
                                        image.resizable()
                                             .aspectRatio(contentMode: .fit)
                                             .frame(width: 100, height: 100)
                                    case .failure:
                                        Image(systemName: "photo")
                                    @unknown default:
                                        EmptyView()
                                }
                            }
                    }
                }
            }
        }
        .navigationTitle("Restaurant")
        .task {
            await viewModel.loadRestaurants()
        }
    }
}

struct RestaurantsView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantsView()
    }
}
