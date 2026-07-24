//
//  ProfileView.swift
//  SafeSteps
//
//  Created by Sandra Yang on 6/11/24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        if let user = viewModel.currentUser {
            List {
                Section {
                    HStack {
                        //PFP
                        Text(user.initials)
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .frame(width: 72, height: 72)
                            .background(Color(.systemPurple))
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 4) {
                            //USER AND EMAIL (PROFILE HEADER)
                            Text(user.fullName)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .padding(.top, 4)
                            
                            Text(user.email)
                                .font(.footnote)
                                .foregroundStyle(.purple)
                        }
                    }
                }
                //from  SettingsRowView create rows
                //General row
                Section(String(localized:"General-Heading")) {
                    //Profile basics
                    HStack {
                        SettingsRowView(imageName: "gear",
                                        title: String(localized:"Version-Functionality"),
                                        tintColor: Color(.systemPurple))
                        Spacer()
                        Text("1.0.0")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                    }
                }
                
                //Account rows
                Section(String(localized:"Account-Heading")) {
                    Button {
                        viewModel.signOut()
                    } label: {
                        SettingsRowView(imageName: "arrow.left.circle.fill", title: String(localized:"Sign-Out"), tintColor: .purple)
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
}
