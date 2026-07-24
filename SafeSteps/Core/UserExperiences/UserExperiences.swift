//
//  UserExperiences.swift
//  SafeSteps
//
//  Created by Sandra Yang on 25/12/24.
//

import Foundation

class UserExperience: Identifiable {
    let id = UUID() // Unique identifier
    var title: String
    var date: Date
    var description: String

    init(title: String, date: Date, description: String) {
        self.title = title
        self.date = date
        self.description = description
    }
}




