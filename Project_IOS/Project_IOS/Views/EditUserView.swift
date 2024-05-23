import Foundation
import SwiftUI

struct EditUserView: View {
    @Binding var showingEditForm: Bool
    @Binding var user: UserModel
    var onComplete: (UserModel) -> Void

    @State private var nom: String = ""
    @State private var prenom: String = ""
    @State private var profession: String = ""
    @State private var interets: String = ""
    @State private var age: String = "" 
    @State private var mail: String = ""
    @State private var genre: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Informations Personnelles")) {
                    HStack {
                        Image(systemName: "person.fill")
                        TextField("Nom", text: $nom)
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    HStack {
                        Image(systemName: "person.fill")
                        TextField("Prénom", text: $prenom)
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    HStack {
                        Image(systemName: "briefcase.fill")
                        TextField("Profession", text: $profession)
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    HStack {
                        Image(systemName: "heart.fill")
                        TextField("Intérêts", text: $interets)
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    HStack {
                        Image(systemName: "calendar")
                        TextField("Âge", text: $age)
                            .keyboardType(.numberPad)
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                    HStack {
                        Image(systemName: "envelope.fill")
                        TextField("Mail", text: $mail)
                            .keyboardType(.emailAddress)
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                    Picker("Genre", selection: $genre) {
                        Text("Homme").tag("Homme")
                        Text("Femme").tag("Femme")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    Button("Modifier ses informations") {
                        let updatedUser = UserModel(
                            id_user: user.id_user,
                            nom: nom,
                            prenom: prenom,
                            profession: profession,
                            interets: interets,
                            age: Int(age) ?? 0,
                            mail: mail,
                            genre: genre
                        )
                        Task {
                            await updateUser(updatedUser)
                        }
                    }
                    .disabled(nom.isEmpty || prenom.isEmpty || mail.isEmpty)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(8)
                    
                }
            }
            .navigationBarTitle("Modifier ses informations", displayMode: .inline)
            .onAppear {
                loadUserData()
            }
        }
    }

    private func loadUserData() {
        nom = user.nom
        prenom = user.prenom
        profession = user.profession
        interets = user.interets
        age = String(user.age)
        mail = user.mail
        genre = user.genre
        print(age)
    }

    private func updateUser(_ updatedUser: UserModel) async {
            do {
                guard let userId = updatedUser.id_user else { return }
                try await EditUserService().editUser(userId: userId, formData: updatedUser)
                onComplete(updatedUser)
                showingEditForm = false
            } catch {
                print("Erreur lors de la mise à jour de l'utilisateur: \(error)")
            }
        }
}

struct EditUserView_Previews: PreviewProvider {
    static var previews: some View {
        let user = UserModel(id_user: 1, nom: "Doe", prenom: "John", profession: "Developer", interets: "Coding", age: 30, mail: "john@example.com", genre: "Homme")
        EditUserView(showingEditForm: .constant(true), user: .constant(user)) { updatedUser in
        }
    }
}

