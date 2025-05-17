import SwiftUI

struct SettingsView: View {
    @State private var preferredRoute: String = "Both"
    @State private var isDarkMode: Bool = false
    @State private var enableAR: Bool = true
    @State private var accessibilityRoutes: Bool = false
    @State private var notificationsEnabled: Bool = true
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    // Profile Section
                    VStack(spacing: 16) {
                        ZStack {
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Color.purple]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 3))
                            
                            Image(systemName: "person.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                        }
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                        
                        Text("Christian Berko")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("RIT Student")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 32)
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemBackground))
                    
                    // App Settings
                    VStack(spacing: 0) {
                        // Navigation Preferences
                        SettingsSection(title: "NAVIGATION PREFERENCES") {
                            SettingsRow(
                                icon: "point.topleft.down.curvedto.point.bottomright.up",
                                title: "Route Preference",
                                value: preferredRoute,
                                options: ["Indoor", "Outdoor", "Both"],
                                selection: $preferredRoute
                            )
                            
                            SettingsToggleRow(
                                icon: "figure.roll",
                                title: "Accessibility Routes",
                                isOn: $accessibilityRoutes
                            )
                        }
                        
                        // App Appearance
                        SettingsSection(title: "APP APPEARANCE") {
                            SettingsToggleRow(
                                icon: "moon.fill",
                                title: "Dark Mode",
                                isOn: $isDarkMode
                            )
                            
                            SettingsRow(
                                icon: "paintpalette.fill",
                                title: "App Theme",
                                value: "Default",
                                options: ["Default", "RIT Colors", "Dark", "Light"],
                                selection: .constant("Default")
                            )
                        }
                        
                        // Features
                        SettingsSection(title: "FEATURES") {
                            SettingsToggleRow(
                                icon: "arkit",
                                title: "AR Navigation",
                                isOn: $enableAR
                            )
                            
                            SettingsToggleRow(
                                icon: "bell.badge.fill",
                                title: "Notifications",
                                isOn: $notificationsEnabled
                            )
                        }
                        
                        // Support
                        SettingsSection(title: "SUPPORT") {
                            SettingsNavigationRow(
                                icon: "questionmark.circle.fill",
                                title: "Help Center",
                                action: {}
                            )
                            
                            SettingsNavigationRow(
                                icon: "envelope.fill",
                                title: "Contact Us",
                                action: {}
                            )
                            
                            SettingsNavigationRow(
                                icon: "star.fill",
                                title: "Rate App",
                                action: {}
                            )
                        }
                    }
                    .padding(.bottom, 32)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: saveSettings) {
                        Text("Save")
                            .fontWeight(.semibold)
                    }
                }
            }
        }
    }
    
    private func saveSettings() {
        // Logic to save settings
        print("Settings Saved:")
        print("Preferred Route: \(preferredRoute)")
        print("Dark Mode: \(isDarkMode)")
        print("Enable AR: \(enableAR)")
        print("Accessibility Routes: \(accessibilityRoutes)")
        print("Notifications: \(notificationsEnabled)")
    }
}

// MARK: - Components

struct SettingsSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.secondary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            
            VStack(spacing: 0) {
                content
            }
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let value: String
    let options: [String]
    @Binding var selection: String
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .frame(width: 24)
                
                Text(title)
                    .font(.system(size: 16))
                
                Spacer()
                
                Picker(selection: $selection, label: Text(value)) {
                    ForEach(options, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .accentColor(.secondary)
            }
            .padding(16)
            
            Divider()
                .padding(.leading, 56)
        }
    }
}

struct SettingsToggleRow: View {
    let icon: String
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .frame(width: 24)
                
                Text(title)
                    .font(.system(size: 16))
                
                Spacer()
                
                Toggle("", isOn: $isOn)
                    .labelsHidden()
            }
            .padding(16)
            
            Divider()
                .padding(.leading, 56)
        }
    }
}

struct SettingsNavigationRow: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 0) {
                HStack {
                    Image(systemName: icon)
                        .foregroundColor(.blue)
                        .frame(width: 24)
                    
                    Text(title)
                        .font(.system(size: 16))
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color(.tertiaryLabel))
                }
                .padding(16)
                
                Divider()
                    .padding(.leading, 56)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
