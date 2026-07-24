//
//  LoginView.swift
//  SafeSteps
//
//  Created by Sandra Yang on 5/11/24.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        //Navigation stack
        NavigationStack {
            //Background wave
            ZStack {
                Image("Image")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                VStack {
                    //Introductory text
                    Text("Greetings-Title")
                        .font(.system(size: 28))
                    Spacer()
                        .frame(height: 12)
                    Text("Welcome-Text")
                        .font(.system(size: 12))
                        .foregroundStyle(.gray)
                    Spacer()
                        .frame(height: 30)
                    
                    //Input fields of email and password from class InputView
                    VStack(spacing: 10){
                        //Input field for email
                        InputView(text: $email,
                                  title: String(localized: "Email-Address"),
                                  placeholder: String(localized: "Example-Gmail"))
                        .textInputAutocapitalization(.never)
                        
                        //Input field for password
                        InputView(text: $password,
                                  title: String(localized: "Password-Title"),
                                  placeholder: String(localized: "Enter-your-password"), isSecureField: true)
                        .textInputAutocapitalization(.never)
                        
                    }
                    .padding(.horizontal)
                    
                    
                    //Sign in button
                    Button {
                        Task {
                            try await viewModel.signIn(withEmail: email, password: password)
                        }
                    } label: {
                        HStack {
                            Text("LOGIN-BUTTON")
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
                    
                    Spacer()
                        .frame(height: 50)
                    
                    //Sign up button --> Navigation LINK
                    NavigationLink {
                        RegistrationView()
                    } label: {
                        HStack(spacing: 5) {
                            Text("NO-ACCOUNT-QUESTION?")
                                .foregroundColor(.gray)
                            Text("CREATE-AN-ACCOUNT")
                                .fontWeight(.bold)
                                .foregroundStyle(.black)
                        }
                    }
                    .font(.system(size: 13))
                    .padding(.top, -28)
                }
            }
        }
    }
}
//LOGIN button is only valid if it has an email with an "@" symbol and the password with at least 6 characters
extension LoginView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
