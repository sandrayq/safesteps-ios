//
//  User.swift
//  SafeSteps
//
//  Created by Sandra Yang on 6/11/24.
//

//Data model for our user, to sign in and out and creating user objects
import Foundation
struct User: Identifiable, Codable {
    let id: String
    let fullName: String
    let email: String
    
    //Profile picture with user's initials
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullName) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return ""
    }
}

//mock profile
extension User {
    static var MOCK_USER = User(id: NSUUID().uuidString, fullName: "Fei Qiu", email: "test@gmail.com")
}
