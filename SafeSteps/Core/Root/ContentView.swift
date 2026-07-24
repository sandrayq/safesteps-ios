//
//  ContentView.swift
//  SafeSteps
//
//  Created by Sandra Yang on 5/11/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var crimesData: [CrimeData] = []
    
    
    var body: some View {
        Group {
            //Stay signed in if already signed in before
            if viewModel.userSession != nil {
                //Tool bar for Map, Profile, and experiences
                TabView {
                    UserExperiencesView()
                        .tabItem {
                            Label("Experiences-Toolbar", systemImage: "text.book.closed")
                        }
                    MapView(crimes: crimesData)
                        .tabItem {
                            Label("Map-Toolbar", systemImage: "map")
                        }
                    ProfileView()
                        .tabItem {
                            Label("Profile-Toolbar", systemImage: "person.circle")
                        }
                }
                
            } else {
                LoginView()
            }
        }
        .onAppear {
            loadCrimes() // Load crime data when ContentView appears
        }
    }
    
    // Function to load crime data dynamically, fallsback to JSON file if it doesnt work. Update date each month
    private func loadCrimes() {
        let apiURLString = "https://data.police.uk/api/crimes-street/all-crime?lat=51.5074&lng=-0.1278" // centered around London
        guard let apiURL = URL(string: apiURLString) else {
            print("Invalid API URL, loading local JSON instead.")
            loadLocalCrimes()
            return
        }

        URLSession.shared.dataTask(with: apiURL) { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    do {
                        let decodedCrimes = try JSONDecoder().decode([CrimeData].self, from: data)
                        self.crimesData = decodedCrimes
                        print("Loaded \(decodedCrimes.count) crimes from API")
                    } catch {
                        print("Failed to decode API response, loading local JSON.")
                        self.loadLocalCrimes()
                    }
                } else {
                    print("API request failed, loading local JSON.")
                    self.loadLocalCrimes()
                }
            }
        }.resume()
    }

    // Function to load local CrimeData.json
    private func loadLocalCrimes() {
        if let path = Bundle.main.path(forResource: "CrimeData", ofType: "json"),
           let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            do {
                let decodedCrimes = try JSONDecoder().decode([CrimeData].self, from: data)
                self.crimesData = decodedCrimes
                print("Loaded \(decodedCrimes.count) crimes from local JSON")
            } catch {
                print("Failed to decode local CrimeData.json")
            }
        } else {
            print("CrimeData.json file not found")
        }
    }

}


#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
}
