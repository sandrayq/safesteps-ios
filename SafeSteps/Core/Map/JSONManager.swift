//
//  JSONManager.swift
//  SafeSteps
//
//  Created by Sandra Yang on 19/12/24.
//

import Foundation

struct CrimeData: Identifiable, Codable {
    var id = UUID() // Automatically generated
    var longitud: Double
    var latitude: Double
    var crimeType: String

    enum CodingKeys: String, CodingKey {
        case longitud = "Longitude"
        case latitude = "Latitude"
        case crimeType = "Crime type"
    }
}

// Decode JSON data using a generic extension
extension Bundle {
    func decode<T: Decodable>(file: String) -> T {
        // Find the file
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("File \(file) not found in the app bundle.")
        }

        // Load the data
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Could not load data from file \(file).")
        }

        // Decode the data
        let decoder = JSONDecoder()
        guard let loadedData = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file). Please check the JSON format.")
        }

        print("") // Debug confirmation
        return loadedData
    }
}
