//
//  MapView.swift
//  SafeSteps
//
//  Created by Sandra Yang on 6/11/24.
//
import SwiftUI
import MapKit

struct MapView: View {
    @State private var cameraPosition: MapCameraPosition = .region(.userRegion)
    @State private var searchText = ""
    @State private var showCrimeButtons = false // Crime type buttons
    @State private var selectedCrimeType: String? = nil // Filtered crime type
    @State private var showPanicAnimation = false //panic button animation

        var crimes: [CrimeData]

    // Grouping crime types together for simplicity GUI
    private let crimeTypeMapping: [String: [String]] = [
        "Behavioral Crimes": ["Anti-social behaviour", "Public order"],
        "Theft": ["Bicycle theft", "Shoplifting", "Other theft", "Theft from the person", "Burglary", "Vehicle crime"],
        "Drugs": ["Drugs"],
        "Property Damage": ["Criminal damage and arson"],
        "Sexual Offenses and Violence": ["Violence and sexual offences"],
        "Other": ["Other crime"]
    ]

    // Filter crimes based on the selected type
    private var filteredCrimes: [CrimeData] {
        if let type = selectedCrimeType, let mappedTypes = crimeTypeMapping[type] {
            return crimes.filter { mappedTypes.contains($0.crimeType) }
        } else {
            return crimes // Show all crimes if no filter is applied
        }
    }


    var body: some View {
        NavigationStack {
            Map(position: $cameraPosition) {
                // Display crime annotations
                ForEach(filteredCrimes) { crime in
                    Annotation(crime.crimeType, coordinate: CLLocationCoordinate2D(latitude: crime.latitude, longitude: crime.longitud)) {
                        ZStack {
                            Circle()
                                .frame(width: 80, height: 80)
                                .foregroundStyle(CrimeCategory.color(for: crime.crimeType)) // Use color from CrimeCategory
                                .opacity(0.2)
                        }
                    }
                }
                
                // Pin for user location
                Marker("My location", systemImage: "paperplane", coordinate: .userLocation)
                    .tint(.red)
            }

            // Search text field
            .overlay(alignment: .topLeading) { // Align to the top-left
                HStack {
                    TextField("SEARCH-BAR", text: $searchText)
                        .font(.subheadline)
                        .padding(10)
                        .background(.white)
                        .cornerRadius(8)
                        .shadow(radius: 3)
                        .frame(maxWidth: 265) // Limit width to make it shorter
                        .onSubmit {
                            searchLocation()
                        }
                    
                    Button(action: {
                        searchLocation()
                    }) {
                        Image(systemName: "magnifyingglass")
                            .padding()
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal)
                .padding(.top, 3) // Adjust vertical spacing from top
            }
            
            // Categorize crime types in map
            .overlay(alignment: .bottomLeading) {
                // Static "Lines" Button
                Button(action: {
                    withAnimation {
                        showCrimeButtons.toggle()
                    }
                }) {
                    Image(systemName: "line.3.horizontal")
                        .font(.title)
                        .padding()
                        .background(.white)
                        .foregroundColor(.purple)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                }
                .padding(.leading, 20)
                .padding(.bottom, 20)
            }

            // Crime type buttons appear
            .overlay(alignment: .bottomLeading) {
                if showCrimeButtons {
                    VStack(spacing: 20) {
                        // Behavioral Crimes
                        Button(action: {
                            selectedCrimeType = "Behavioral Crimes"
                            withAnimation {
                                showCrimeButtons = false
                            }
                        }) {
                            buttonWithInitial(String(localized:"Behavioral-Crimes-Button"), color: .green)
                        }

                        // Theft
                        Button(action: {
                            selectedCrimeType = "Theft"
                            withAnimation {
                                showCrimeButtons = false
                            }
                        }) {
                            buttonWithInitial(String(localized: "Theft-Button"), color: .yellow)
                        }

                        // Drugs
                        Button(action: {
                            selectedCrimeType = "Drugs"
                            withAnimation {
                                showCrimeButtons = false
                            }
                        }) {
                            buttonWithInitial(String(localized: "Drugs-Button"), color: .orange)
                        }
                        // Property Damage
                        Button(action: {
                            selectedCrimeType = "Property Damage"
                            withAnimation {
                                showCrimeButtons = false
                            }
                        }) {
                            buttonWithInitial(String(localized: "Property-Damage-Button"), color: .purple)
                        }

                        // Sexual Offenses and Violence
                        Button(action: {
                            selectedCrimeType = "Sexual Offenses and Violence"
                            withAnimation {
                                showCrimeButtons = false
                            }
                        }) {
                            buttonWithInitial(String(localized: "Sexual-Violence-Button"), color: .pink)
                        }

                        // Other
                        Button(action: {
                            selectedCrimeType = "Other"
                            withAnimation {
                                showCrimeButtons = false
                            }
                        }) {
                            buttonWithInitial(String(localized: "Other-Button"), color: .gray) // gray
                        }

                        // Reset Button
                        Button(action: {
                            selectedCrimeType = nil
                            withAnimation {
                                showCrimeButtons = false
                            }
                        }) {
                            buttonWithInitial(String(localized: "Show-All-Button"), color: .black) //green
                        }
                    }
                   
                    .cornerRadius(10)
                    .padding(.leading, 30) // Align to the right of the "lines" button
                    .padding(.bottom, 86) // Positioned above the "lines" button
                }
            }
            
            //panic button
            .overlay(alignment: .bottomTrailing) {
                Button(action: {
                    callEmergencyNumber()
                    triggerHapticFeedback()
                    showPanicAnimation = true
                    withAnimation(.easeInOut(duration: 3)) {
                        showPanicAnimation = false
                    }
                }) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                        .padding()
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                }
                .padding(.trailing, 20)
                .padding(.bottom, 20)
            }
            .overlay {
                if showPanicAnimation {
                    Color.red
                        .opacity(0.6)
                        .ignoresSafeArea()
                }
            }


            //controls to add compass, 3D/2D button, and relocate the user
            .mapControls {
                MapCompass() // Compass toggle
                MapPitchToggle() // 3D/2D toggle
                MapUserLocationButton() // Relocate user button
                  
            }
        }
    }
    
    //panic button calls emergency contacts/911
    private func callEmergencyNumber() {
        let emergencyNumber = "testnumber" // Test emergency number
        if let url = URL(string: "tel://\(emergencyNumber)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            print("Calling is not supported on this device.")
        }
    }

    //panic button vibrates phone
    private func triggerHapticFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error) // Use .error for a strong vibration
    }


    // Helper Function
    private func buttonWithInitial(_ title: String, color: Color) -> some View {
        HStack(spacing: 14) {
            Circle()
                .frame(width: 50, height: 50)
                .foregroundColor(color)
                .overlay(
                    Text(String(title.prefix(1))) // Add the first letter of the title
                        .font(.headline)
                        .foregroundColor(.white)
                )
                .overlay(
                    Circle() // Add black border
                        .stroke(Color.black, lineWidth: 0.5)
                )
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: 250, alignment: .leading)
    }




    // Geocoding function
    private func searchLocation() {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(searchText) { placemarks, error in
            guard let placemark = placemarks?.first,
                  let location = placemark.location else {
                print("Location not found: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            // Update camera position to the searched location
            cameraPosition = .region(
                MKCoordinateRegion(
                    center: location.coordinate,
                    latitudinalMeters: 500,
                    longitudinalMeters: 500
                )
            )
        }
    }
}

// Setting up user location coordinate for London
extension CLLocationCoordinate2D {
    static var userLocation: CLLocationCoordinate2D {
        return .init(latitude: 51.5074, longitude: -0.1278) // London coordinates
    }
}

// Map view region centered around London
extension MKCoordinateRegion {
    static var userRegion: MKCoordinateRegion {
        return .init(center: .userLocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
    }
}

// Preview
#Preview {
    MapView(crimes: [
        CrimeData(longitud: -0.1278, latitude: 51.5074, crimeType: "Public order"),
        CrimeData(longitud: -0.1250, latitude: 51.5085, crimeType: "Other theft"),
        CrimeData(longitud: -0.1200, latitude: 51.5080, crimeType: "Theft from the person"),
        CrimeData(longitud: -0.1300, latitude: 51.5095, crimeType: "Violence and sexual offences"),
        CrimeData(longitud: -0.1100, latitude: 51.5100, crimeType: "Vehicle crime"),
        CrimeData(longitud: -0.1400, latitude: 51.5115, crimeType: "Drugs"),
        CrimeData(longitud: -0.1350, latitude: 51.5120, crimeType: "Bicycle theft"),
        CrimeData(longitud: -0.1120, latitude: 51.5150, crimeType: "Burglary"),
        CrimeData(longitud: -0.1080, latitude: 51.5180, crimeType: "Shoplifting"),
        CrimeData(longitud: -0.1150, latitude: 51.5175, crimeType: "Anti-social behaviour"),
        CrimeData(longitud: -0.1200, latitude: 51.5190, crimeType: "Possession of weapons"),
        CrimeData(longitud: -0.1050, latitude: 51.5205, crimeType: "Robbery"),
        CrimeData(longitud: -0.1070, latitude: 51.5210, crimeType: "Criminal damage and arson"),
        CrimeData(longitud: -0.1090, latitude: 51.5225, crimeType: "Other crime")
    ])
}
