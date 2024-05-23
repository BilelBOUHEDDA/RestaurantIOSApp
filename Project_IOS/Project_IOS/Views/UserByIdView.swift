import SwiftUI

struct UserByIdView: View {
    var id_user: Int
    @StateObject var viewModel = UserViewModel()

    var body: some View {
        ScrollView {
            VStack {
                if let user = viewModel.selected_user {
                    CardView {
                        UserInfoRow(icon: "person.fill", info: user.nom)
                        UserInfoRow(icon: "person.fill", info: user.prenom)
                        UserInfoRow(icon: "briefcase.fill", info: user.profession)
                        UserInfoRow(icon: "heart.fill", info: user.interets)
                        UserInfoRow(icon: "calendar", info: "Âge : \(user.age)")
                        UserInfoRow(icon: "envelope.fill", info: user.mail)
                        UserInfoRow(icon: "person.3.fill", info: "Genre : \(user.genre)")
                    }
                } else {
                    ProgressView()
                }
            }
            .padding(.horizontal)
        }.navigationBarTitle("Détails Utilisateur", displayMode: .inline)
        .task {
            await viewModel.loadUserById(id: id_user)
        }
    }
}

struct UserInfoRow: View {
    var icon: String
    var info: String

    var body: some View {
        HStack {
            Image(systemName: icon)
            Text(info)
                .font(.system(size: 18, weight: .medium))
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct CardView<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack {
            content
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
    }
}

struct UserByIdView_Previews: PreviewProvider {
    static var previews: some View {
        UserByIdView(id_user: 1)
    }
}
