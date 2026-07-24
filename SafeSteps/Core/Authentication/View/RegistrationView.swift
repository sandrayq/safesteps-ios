//
//  RegistrationView.swift
//  SafeSteps
//
//  Created by Sandra Yang on 5/11/24.
//

import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var fullName = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    //environment objects can get initialized in one place and be used in many places in the app
    
    var body: some View {
        //Background wave
        ZStack {
            Image("Image")
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            //Input fields of email and password from class InputView & buttons
            VStack(spacing: 10){
                
                //Input field for email
                InputView(text: $email,
                          title: String(localized: "Email-Address"),
                          placeholder: String(localized: "Example-Gmail"))
                .textInputAutocapitalization(.never)
                
                //Input field for name
                InputView(text: $fullName,
                          title: String(localized: "Full-Name"),
                          placeholder: String(localized:"Enter-your-full-name"))
                .textInputAutocapitalization(.words)
                
                //Input field for password
                InputView(text: $password,
                          title: String(localized: "Password-Title"),
                          placeholder: String(localized: "Enter-your-password"), isSecureField: true)
                .textInputAutocapitalization(.never)
                
                //Input field for confirm password
                ZStack(alignment: .trailing) {
                    InputView(text: $confirmPassword,
                              title: String(localized: "Confirm-Password"),
                              placeholder: String(localized:"Confirm-your-password"), isSecureField: true)
                
                    if !password.isEmpty && !confirmPassword.isEmpty { //make sure both text fields have text, if password and confirmPassword are equal, then check, if not, cross.
                        if password == confirmPassword {
                            Image(systemName: "checkmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundStyle(.green)
                        } else {
                            Image(systemName: "xmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundStyle(.red)
                        }
                    }
                }
                .textInputAutocapitalization(.never)
                    
                    //Sign in button
                    Button {
                        Task {
                            try await viewModel.createUser(withEmail: email, password: password, fullName: fullName)
                        }
                    } label: {
                        HStack {
                            Text("GET-STARTED")
                                .fontWeight(.semibold)
                        }
                        .foregroundStyle(.white)
                        .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                    }
                    .background(Color.purple)
                    .disabled(!formIsValid)
                    .opacity(formIsValid ? 1.0 : 0.5) //faded look if form isn't valid
                    .cornerRadius(10)
                    .padding(.top, 24)
                    
                    //Back to LOGIN button
                    Button {
                        dismiss()
                    } label: {
                        HStack(spacing: 5) {
                            Text("ALREADY-ACCOUNT-QUESTION?")
                                .foregroundColor(.gray)
                            Text("LOGIN-BUTTON")
                                .fontWeight(.bold)
                                .foregroundStyle(.black)
                        }
                        .font(.system(size: 14))
                        .padding(.top, 12)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    //LOGIN button is only valid if it has an email with an "@" symbol and the password with at least 6 characters
        extension RegistrationView: AuthenticationFormProtocol {
            var formIsValid: Bool {
                return !email.isEmpty
                && email.contains("@")
                && !password.isEmpty
                && password.count > 5
                && confirmPassword == password //passwords match
                && !fullName.isEmpty
            }
        }
    
    #Preview {
        RegistrationView()
            .environmentObject(AuthViewModel())
}
