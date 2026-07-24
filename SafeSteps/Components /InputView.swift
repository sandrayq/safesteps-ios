//
//  InputView.swift
//  SafeSteps
//
//  Created by Sandra Yang on 5/11/24.
//

import SwiftUI

//Reusable input field 
struct InputView: View {
    //User input text variable
    @Binding var text: String
    
    //Title and placeholder of the text field variable
    let title: String
    let placeholder: String
    
    //Actual text field or secure field, always false except when specified (for passwords), if its false its just going to be a regular text field, if true it will be a secure/password field
    var isSecureField = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12){
            Text(title)
                .foregroundStyle(Color(.darkGray))
                .fontWeight(.semibold)
                .font(.footnote)
            
            //if isSecureField is true, then the text won't be visible (for password)
            if isSecureField {
                SecureField(placeholder, text: $text)
                    .font(.system(size:14))
                    .foregroundStyle(.gray) // Set text color to gray
                    .padding()
                    .background(Color.white) // Set background color to white
                    .cornerRadius(5)
                    .overlay(RoundedRectangle(cornerRadius: 5) .stroke(Color.gray, lineWidth: 0.5))// Border
            }
            else {
                TextField(placeholder, text: $text)
                    .font(.system(size:14))
                    .foregroundStyle(.gray) // Set text color to gray
                    .padding()
                    .background(Color.white) // Set background color to white
                    .cornerRadius(5)
                    .overlay(RoundedRectangle(cornerRadius: 5) .stroke(Color.gray, lineWidth: 0.5))// Border
            }
            
            
        }
    }
}

#Preview {
    //Input parameters for the variables
    InputView(text: .constant(""), title: "Email Address", placeholder: "name@example.com")
}
