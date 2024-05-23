import SwiftUI

struct UserView: View {
    @StateObject var viewModel = UserViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.users,id:\.self) { user in
                VStack(alignment: .leading) {
                    Text(user.nom)
                        .font(.headline)
                    Text(user.prenom)
                        .font(.headline)
                    Text(user.profession)
                        .font(.headline)
                    Text(user.interets)
                        .font(.headline)
                    
                }
            }
            .navigationTitle("User")
        }
        .task {
            await viewModel.loadUsers()
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}
