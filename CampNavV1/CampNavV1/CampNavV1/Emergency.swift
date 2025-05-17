//
//  Emergency.swift
//  CampNavV1
//
//  Created by Christian Berko (RIT Student) on 4/22/25.
//
import SwiftUI
import CoreLocation

struct EmergencyView: View {
    //@StateObject private var locationManager = EmergencyLocationManager()
    @State private var isAlertActive = false
    @State private var showToast = false
    @State private var toastMessage = ""
    
    var body: some View {
        ZStack {
            // Background with subtle gradient
            LinearGradient(
                gradient: Gradient(colors: [Color(.systemBackground), Color(.secondarySystemBackground)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Header
                VStack(spacing: 10) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.red)
                    
                    Text("Emergency Assistance")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                .padding(.top, 40)
                
                // Emergency options
                VStack(spacing: 20) {
                    Button(action: { showComingSoonToast() }) {
                        EmergencyOptionView(
                            icon: "cross.fill",
                            title: "Medical Emergency",
                            description: "Request medical assistance",
                            color: .red
                        )
                    }
                    
                    Button(action: { showComingSoonToast() }) {
                        EmergencyOptionView(
                            icon: "person.fill.viewfinder",
                            title: "Safety Concern",
                            description: "Report a safety threat",
                            color: .orange
                        )
                    }
                    
                    Button(action: { showComingSoonToast() }) {
                        EmergencyOptionView(
                            icon: "questionmark.circle.fill",
                            title: "Other Emergency",
                            description: "Get help for other situations",
                            color: .blue
                        )
                    }
                }
                .padding(.horizontal, 20)
                
                // Public safety contact (unchanged)
                VStack(spacing: 10) {
                    Text("Public Safety")
                        .font(.headline)
                    
                    Button(action: callPublicSafety) {
                        HStack {
                            Image(systemName: "phone.fill")
                            Text("Call Immediately")
                        }
                        .font(.title3)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal, 40)
                }
                
                Spacer()
            }
            
            // Toast message
            if showToast {
                ToastView(message: toastMessage)
                    .transition(.move(edge: .bottom))
                    .zIndex(1)
            }
        }
        .navigationBarHidden(true)
    }
    
    private func showComingSoonToast() {
        toastMessage = "Emergency alert functionality coming soon!"
        showToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showToast = false
            }
        }
    }
    
    private func callPublicSafety() {
        let phoneNumber = "tel://+15855551234" // RIT public safety number
        guard let url = URL(string: phoneNumber) else { return }
        UIApplication.shared.open(url)
    }
}

// Toast View (same as your EventsView)
//struct ToastView: View {
//    let message: String
//    
//    var body: some View {
//        Text(message)
//            .padding()
//            .background(Color.black.opacity(0.7))
//            .foregroundColor(.white)
//            .cornerRadius(8)
//            .padding(.bottom, 44)
//    }
//}


// Custom view for emergency options
struct EmergencyOptionView: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(color)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.tertiarySystemBackground))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.systemGray5), lineWidth: 1)
        )
    }
}

// Location manager specifically for emergency tracking
//class EmergencyLocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
//    private let locationManager = CLLocationManager()
//    @Published var currentLocation: CLLocation?
//    
//    override init() {
//        super.init()
//        locationManager.delegate = self
//        locationManager.requestAlwaysAuthorization() // Need always auth for background tracking
//    }
//    
//    func startActiveTracking() {
//        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
//        locationManager.distanceFilter = 2 // Very frequent updates
//        locationManager.startUpdatingLocation()
//        locationManager.allowsBackgroundLocationUpdates = true
//    }
//    
//    func stopActiveTracking() {
//        locationManager.stopUpdatingLocation()
//        locationManager.allowsBackgroundLocationUpdates = false
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        currentLocation = locations.last
//    }
//}
