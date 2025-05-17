import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @AppStorage("isWelcomeSheetShowing") var isWelcomeSheetShowing = true
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding = false
    @AppStorage("isUserSignedIn") var isUserSignedIn = false
    
    var body: some View {
        Group {
            if !hasCompletedOnboarding {
                WelcomeView(hasCompletedOnboarding: $hasCompletedOnboarding)
            } else if !isUserSignedIn {
                SignInView(isUserSignedIn: $isUserSignedIn)
            } else {
                mainAppView
            }
        }
        .accentColor(Color(red: 0.38, green: 0.71, blue: 0.92)) // Consistent accent color
    }
    
    private var mainAppView: some View {
        TabView(selection: $selectedTab) {
            // Home/Events Tab
            EventsView()
                .tabItem {
                    VStack {
                        Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                        Text("Home")
                    }
                }
                .tag(0)
            
            // Map Tab
            MapView()
                .tabItem {
                    VStack {
                        Image(systemName: selectedTab == 1 ? "map.fill" : "map")
                        Text("Map")
                    }
                }
                .tag(1)
            EmergencyView()
                        .tabItem {
                            VStack {
                                Image(systemName: selectedTab == 2 ? "sos" : "sos")
                                Text("Emergency")
                            }
                        }
                        .tag(2)
            
            // Clubs Tab
            ClubsView()
                .tabItem {
                    VStack {
                        Image(systemName: selectedTab == 4 ? "person.3.fill" : "person.3")
                        Text("Clubs")
                    }
                }
                .tag(3)
            
            // Settings Tab
            SettingsView()
                .tabItem {
                    VStack {
                        Image(systemName: selectedTab == 4 ? "gearshape.fill" : "gearshape")
                        Text("Settings")
                    }
                }
                .tag(4)
        }
        .tint(Color(red: 0.38, green: 0.71, blue: 0.92)) // Tab bar tint
    }
}

// MARK: - Onboarding Views

struct PageInfo: Identifiable {
    let id = UUID()
    let label: String
    let text: String
    let image: String
    let gradient: [Color]
}

let pages = [
    PageInfo(
        label: "Welcome to CampNav",
        text: "Your all-in-one campus guide for navigation, events, and safety!",
        image: "figure.walk",
        gradient: [Color(red: 0.97, green: 0.47, blue: 0.48), Color(red: 0.96, green: 0.35, blue: 0.67)]
    ),
    PageInfo(
        label: "AR Navigation",
        text: "Find your way with immersive, real-time AR directions.",
        image: "arkit",
        gradient: [Color(red: 0.38, green: 0.71, blue: 0.92), Color(red: 0.22, green: 0.42, blue: 0.94)]
    ),
    PageInfo(
        label: "Personalized Events",
        text: "Stay in the loop with happenings tailored to your interests.",
        image: "calendar",
        gradient: [Color(red: 0.28, green: 0.80, blue: 0.71), Color(red: 0.18, green: 0.45, blue: 0.82)]
    ),
    PageInfo(
        label: "Safety Alerts",
        text: "Report hazards and stay informed about campus safety.",
        image: "bell.badge.fill",
        gradient: [Color(red: 0.65, green: 0.49, blue: 0.98), Color(red: 0.44, green: 0.28, blue: 0.92)]
    )
]

struct WelcomeView: View {
    @Binding var hasCompletedOnboarding: Bool
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            // Dynamic gradient background based on current page
            LinearGradient(
                gradient: Gradient(colors: pages[currentPage].gradient),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack {
                // Page content
                TabView(selection: $currentPage) {
                    ForEach(Array(pages.enumerated()), id: \.element.id) { index, page in
                        OnboardingPageView(page: page)
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: 500)
                
                // Page indicators
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? Color.white : Color.white.opacity(0.5))
                            .frame(width: 8, height: 8)
                            .scaleEffect(index == currentPage ? 1.2 : 1.0)
                            .animation(.spring(), value: currentPage)
                    }
                }
                .padding(.bottom, 30)
                
                // Continue button
                Button {
                    if currentPage < pages.count - 1 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        hasCompletedOnboarding = true
                    }
                } label: {
                    Text(currentPage < pages.count - 1 ? "Next" : "Get Started")
                        .font(.headline)
                        .foregroundColor(pages[currentPage].gradient.first ?? .blue)
                        .frame(width: 200, height: 50)
                        .background(Color.white)
                        .clipShape(Capsule())
                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.bottom, 50)
            }
        }
    }
}

struct OnboardingPageView: View {
    let page: PageInfo
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: page.image)
                .font(.system(size: 80))
                .foregroundColor(.white)
                .shadow(radius: 5)
            
            VStack(spacing: 15) {
                Text(page.label)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text(page.text)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
        }
    }
}

// MARK: - Auth Views

struct SignInView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isSigningIn = false
    @Binding var isUserSignedIn: Bool
    
    var body: some View {
        ZStack {
            // Dynamic gradient background
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.28, green: 0.80, blue: 0.71), Color(red: 0.18, green: 0.45, blue: 0.82)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Content
            VStack(spacing: 0) {
                Spacer()
                
                // App logo/icon
                Image(systemName: "map.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.white)
                    .padding(.bottom, 30)
                
                // Card container
                VStack(spacing: 25) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Welcome to CampNav")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Color(red: 0.18, green: 0.45, blue: 0.82))
                        
                        Text("Sign in to continue")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    // Form fields
                    VStack(spacing: 16) {
                        CustomTextField(
                            text: $email,
                            placeholder: "Email",
                            icon: "envelope.fill",
                            isSecure: false
                        )
                        
                        CustomTextField(
                            text: $password,
                            placeholder: "Password",
                            icon: "lock.fill",
                            isSecure: true
                        )
                    }
                    
                    // Sign in button
                    Button(action: signIn) {
                        if isSigningIn {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Sign In")
                                .font(.system(size: 16, weight: .semibold))
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .disabled(email.isEmpty || password.isEmpty || isSigningIn)
                    .frame(height: 50)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color(red: 0.38, green: 0.71, blue: 0.92), Color(red: 0.22, green: 0.42, blue: 0.94)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(color: Color(red: 0.22, green: 0.42, blue: 0.94).opacity(0.3), radius: 10, x: 0, y: 5)
                    
                    // Forgot password
                    Button(action: {}) {
                        Text("Forgot Password?")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(red: 0.38, green: 0.71, blue: 0.92))
                    }
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    // Sign up prompt
                    HStack {
                        Text("Don't have an account?")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        
                        NavigationLink {
                            SignUpView()
                        } label: {
                            Text("Sign Up")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color(red: 0.38, green: 0.71, blue: 0.92))
                        }
                    }
                }
                .padding(25)
                .background(Color(.systemBackground))
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
                .padding(.horizontal, 30)
                
                Spacer()
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
    
    private func signIn() {
        isSigningIn = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isSigningIn = false
            isUserSignedIn = true
        }
    }
}

// Custom Text Field Component
struct CustomTextField: View {
    @Binding var text: String
    let placeholder: String
    let icon: String
    let isSecure: Bool
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(Color(red: 0.38, green: 0.71, blue: 0.92))
                .frame(width: 20)
            
            if isSecure {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.systemGray5), lineWidth: 1)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(text.isEmpty ? Color.clear : Color(red: 0.38, green: 0.71, blue: 0.92).opacity(0.3), lineWidth: 1)
        )
    }
}

struct SignUpView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isSigningUp = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.28, green: 0.80, blue: 0.71), Color(red: 0.18, green: 0.45, blue: 0.82)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Sign up card
            VStack(spacing: 30) {
                // Header
                VStack(spacing: 10) {
                    Text("Create Account")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Join our community")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                // Form
                VStack(spacing: 20) {
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    SecureField("Confirm Password", text: $confirmPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: signUp) {
                        if isSigningUp {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Sign Up")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .disabled(email.isEmpty || password.isEmpty || password != confirmPassword || isSigningUp)
                    .padding()
                    .background(email.isEmpty || password.isEmpty || password != confirmPassword ? Color.gray : Color.white)
                    .foregroundColor(Color(red: 0.28, green: 0.80, blue: 0.71))
                    .clipShape(Capsule())
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                }
                .padding(.horizontal, 30)
                
                // Footer
                Button {
                    dismiss()
                } label: {
                    Text("Already have an account? Sign In")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
            }
            .padding(.vertical, 40)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color(.systemBackground))
                    .shadow(radius: 20)
                    .padding(.horizontal, 20)
            )
        }
        .navigationBarHidden(true)
    }
    
    private func signUp() {
        isSigningUp = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isSigningUp = false
            dismiss()
        }
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
