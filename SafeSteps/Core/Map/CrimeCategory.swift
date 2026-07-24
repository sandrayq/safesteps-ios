//
//  CrimeCategory.swift
//  SafeSteps
//
//  Created by Sandra Yang on 25/12/24.
//

import SwiftUI

struct CrimeCategory {
    let type: String
    let color: Color

    // Static list of categories by colors
    static let categories: [CrimeCategory] = [
        CrimeCategory(type: "Anti-social behaviour", color: .green),
        CrimeCategory(type: "Bicycle theft", color: .green),
        CrimeCategory(type: "Shoplifting", color: .yellow),
        CrimeCategory(type: "Other theft", color: .yellow),
        CrimeCategory(type: "Theft from the person", color: .orange),
        CrimeCategory(type: "Burglary", color: .orange),
        CrimeCategory(type: "Vehicle crime", color: .orange),
        CrimeCategory(type: "Drugs", color: .purple),
        CrimeCategory(type: "Public order", color: .purple),
        CrimeCategory(type: "Criminal damage and arson", color: .red),
        CrimeCategory(type: "Possession of weapons", color: .red),
        CrimeCategory(type: "Robbery", color: .red),
        CrimeCategory(type: "Violence and sexual offences", color: .red),
        CrimeCategory(type: "Other crime", color: .gray)
    ]

    // Helper function to get the color for a given crime type
    static func color(for crimeType: String) -> Color {
        return categories.first { $0.type == crimeType }?.color ?? .gray
    }
}
