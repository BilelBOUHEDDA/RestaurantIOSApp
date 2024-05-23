import SwiftUI

struct RestaurantDetailView: View {
    var restaurant: RestaurantModel

    var body: some View {
        VStack {
            Text(restaurant.nom)
                .font(.title)
                .padding()

            AsyncImage(url: restaurant.photoURL) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image.resizable()
                         .aspectRatio(contentMode: .fit)
                         .frame(maxWidth: 300, maxHeight: 300)
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .padding()
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }
        }
        .padding()
    }
}


