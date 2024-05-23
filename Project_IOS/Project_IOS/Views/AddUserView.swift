import SwiftUI

struct AddUserView: View {
    @Binding var showingForm: Bool
    var onComplete: (Int) -> Void
    
    @State private var nom: String = ""
    @State private var prenom: String = ""
    @State private var profession: String = ""
    @State private var interets: String = ""
    @State private var age: String = ""
        @State private var mail: String = ""
        @State private var genre: String = "Homme"
    
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
                    
                    Button(action: {
                        Task {
                            await addUser()
                        }
                    }) {
                        Text("Ajouter un utilisateur")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                }
            }
            .navigationBarTitle("Ajouter un utilisateur", displayMode: .inline)  
        }
    }

    private func addUser() async {
        let ageInt = Int(age) ?? 0
        let user = UserModel(nom: nom, prenom: prenom, profession: profession, interets: interets, age: ageInt, mail: mail, genre: genre)
        do {
            print("Tentative d'ajout de l'utilisateur...")
                    let userId = try await AddUserService().addUser(formData: user)
                    print("Utilisateur ajouté avec succès, ID: \(userId)")
                    onComplete(userId)
                    showingForm = false
        } catch {
            print("Erreur lors de l'ajout de l'utilisateur \(error.localizedDescription)")
        }
    }
}

struct AddUserView_Previews: PreviewProvider {
    static var previews: some View {
        AddUserView(showingForm: .constant(true), onComplete: { userId in
                    print("L'ID de l'utilisateur créé est \(userId).")
                })
    }
}
