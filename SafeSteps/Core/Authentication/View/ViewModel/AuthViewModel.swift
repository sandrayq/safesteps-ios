//
//  AuthViewModel.swift
//  SafeSteps
//
//  Created by Sandra Yang on 6/11/24.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

//Protocol so that LoginView and RegistrationView can implement the protocol and requires logic to tell if a form is valid
protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}

@MainActor //ensures publishing the UI changes back on the main thread
//Responsible for having all the functionalities associated with authenticating the user and being in charge of updating the UI.

class AuthViewModel: ObservableObject {
    //Fire base auth user
    @Published private(set) var userSession: FirebaseAuth.User?
    //created user
    @Published private(set) var currentUser: User?
    
    init() {
        self.userSession = Auth.auth().currentUser //functionality from firebase to keep users locked in 
        
        Task {
            await fetchUser()
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {
            print("DEBUG: SIGN IN Failed to log in with error \(error.localizedDescription)")
        }
    }
    
    //Asynchronous function that can potentially throw an error (in the catch block if anything goes wrong)
    func createUser(withEmail email: String, password: String, fullName: String) async throws {
        do {
            //store the created user with firebase code, and store it in property "result"
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullName: fullName, email: email) //set user data
            let encodedUser = try Firestore.Encoder().encode(user) //encoded user data
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser) //upload the user data to firebase
            await fetchUser() //once user is created, fetches the data uploaded to firebase so that it is propertly displayed on the screen
            
            //if anything goes wrong, prints out error
        } catch {
            print("DEBUG: CREATE USER Failed to create user with error \(error.localizedDescription)")
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut() //signs user out on backend
            self.userSession = nil //wipes out user session and takes user back to login screen
            self.currentUser = nil //wipes out current user data model
        } catch {
            print("DEBUG: SIGN OUT Failed to sign out with error \(error.localizedDescription)") //if error while sign out
        }
        
    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        self.currentUser = try? snapshot.data(as: User.self)
        }
}
    
