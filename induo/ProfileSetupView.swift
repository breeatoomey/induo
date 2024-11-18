//
//  ProfileSetupView.swift
//  induo
//
//  Created by Jack Seymour on 11/4/24.
//

import SwiftUI
import CoreLocation

// Profile setup page
struct ProfileSetupView: View {
    @State private var name = ""
    @State private var age = ""
    @State private var gender = "Select"
    @State private var location = ""
    @State private var styleDescription = ""
    
    let genders = ["Select", "Male", "Female", "Non-binary", "Other"]
    
    @State private var stepIndex = 0 // Track the current question
    private let backgroundColors = [Color.purple, Color.gray, Color.white] // Rotating background colors
    
    @StateObject private var locationManager = LocationManager() // For fetching location

    var body: some View {
        ZStack {
            backgroundColors[stepIndex % backgroundColors.count]
                .ignoresSafeArea() // Cover the entire screen with background color
            
            VStack {
                VStack(alignment: .leading, spacing: 20) {
                    Text("AI Style Quiz")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 10)
                    
                    // Display each question based on stepIndex
                    if stepIndex == 0 {
                        Text("What's your name?")
                            .font(.headline)
                        TextField("Enter your name", text: $name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    } else if stepIndex == 1 {
                        Text("How old are you?")
                            .font(.headline)
                        TextField("Enter your age", text: $age)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    } else if stepIndex == 2 {
                        Text("Gender")
                            .font(.headline)
                        Picker("Select your gender", selection: $gender) {
                            ForEach(genders, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding()
                        .background(Color(.systemGray5))
                        .cornerRadius(10)
                    }
                     else if stepIndex == 3 {
                        Text("Describe your style")
                            .font(.headline)
                        TextEditor(text: $styleDescription)
                            .frame(height: 150)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            )
                    }
                    
                    // Navigation buttons
                    HStack {
                        if stepIndex > 0 {
                            Button(action: {
                                withAnimation {
                                    stepIndex -= 1
                                }
                            }) {
                                Text("Back")
                                    .font(.headline)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue.opacity(0.7))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                        
                        Spacer()
                        
                        if stepIndex < 3 {
                            Button(action: {
                                withAnimation {
                                    stepIndex += 1
                                }
                            }) {
                                Text("Next")
                                    .font(.headline)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.green.opacity(0.7))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        } else {
                            NavigationLink(destination: ClosetView()) {
                                Text("Submit")
                                    .font(.headline)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding(.top, 20)
                }
                .padding()
            }
        }
        .navigationTitle("Create Profile")
    }
}

// LocationManager to handle location services
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var city: String?
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func requestLocation() {
        manager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if let placemark = placemarks?.first {
                self?.city = placemark.locality // Update with the city name
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
}

#Preview {
    NavigationStack {
        ProfileSetupView()
    }
}
