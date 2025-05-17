import SwiftUI



struct Club: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let members: Int
    let category: String
    let meetingTime: String?
    let location: String?
    let advisor: String?
    let description: String?
    
    // For previews and sample data
    static let sampleClubs = [
        Club(name: "Debate Team", icon: "mic.fill", members: 24, category: "Academic",
             meetingTime: "Wed 3-4 PM", location: "Student Union 205", advisor: "Prof. Smith",
             description: "Competitive debate team open to all students."),
        
        Club(name: "Robotics Club", icon: "atom", members: 18, category: "STEM",
             meetingTime: "Fri 2-5 PM", location: "Engineering Bldg 101", advisor: "Dr. Lee",
             description: "Build robots and compete in national competitions."),
        
        Club(name: "Film Society", icon: "film.fill", members: 32, category: "Arts",
             meetingTime: "Tue 7-9 PM", location: "Liberal Arts 306", advisor: "Prof. Johnson",
             description: "Weekly film screenings and discussions about cinema."),
        
        Club(name: "Computer Science Guild", icon: "laptopcomputer", members: 45, category: "STEM",
             meetingTime: "Mon 6-8 PM", location: "Golisano 209", advisor: "Dr. Chen",
             description: "Hackathons, workshops, and tech talks for CS students."),
        
        Club(name: "Environmental Alliance", icon: "leaf.fill", members: 28, category: "Activism",
             meetingTime: "Thu 4-5:30 PM", location: "Sustainability Center", advisor: "Dr. Rodriguez",
             description: "Promoting sustainability initiatives on campus."),
        
        Club(name: "Chess Club", icon: "checkerboard.rectangle", members: 15, category: "Recreation",
             meetingTime: "Wed 6-8 PM", location: "Campus Center Game Room", advisor: "Prof. Williams",
             description: "Casual and competitive play for all skill levels."),
        
        Club(name: "Entrepreneurship Society", icon: "dollarsign.circle.fill", members: 22, category: "Business",
             meetingTime: "Mon 5-6:30 PM", location: "Saunders 115", advisor: "Prof. Davis",
             description: "Helping students develop business ideas and startups."),
        
        Club(name: "Photography Club", icon: "camera.fill", members: 19, category: "Arts",
             meetingTime: "Thu 7-9 PM", location: "Art Building Darkroom", advisor: "Prof. Kim",
             description: "Photo walks, workshops, and gallery exhibitions."),
        
        Club(name: "International Students Association", icon: "globe", members: 65, category: "Cultural",
             meetingTime: "Fri 4-6 PM", location: "Global Village", advisor: "Dr. Patel",
             description: "Cultural exchange and support for international students."),
        
        Club(name: "Volunteer Corps", icon: "hands.sparkles.fill", members: 40, category: "Community Service",
             meetingTime: "Sat 10AM-12PM", location: "Student Activities Office", advisor: "Prof. Taylor",
             description: "Organizing community service projects in the local area."),
        
        Club(name: "Cybersecurity Club", icon: "lock.shield.fill", members: 27, category: "STEM",
             meetingTime: "Tue 5-7 PM", location: "Cybersecurity Lab", advisor: "Dr. Wilson",
             description: "Ethical hacking competitions and security workshops.")
    ]
}



struct ClubsView: View {
    @State private var allClubs = Club.sampleClubs
    @State private var searchText = ""
    @State private var selectedCategory = "All"
    @State private var showCreateClub = false
    
    private let categories = ["All", "Academic", "Arts", "STEM", "Sports", "Cultural"]
    
    // Gradient colors for club cards
    private let cardGradients = [
        [Color(red: 0.97, green: 0.47, blue: 0.48), Color(red: 0.96, green: 0.35, blue: 0.67)],
        [Color(red: 0.38, green: 0.71, blue: 0.92), Color(red: 0.22, green: 0.42, blue: 0.94)],
        [Color(red: 0.28, green: 0.80, blue: 0.71), Color(red: 0.18, green: 0.45, blue: 0.82)],
        [Color(red: 1.00, green: 0.78, blue: 0.33), Color(red: 0.96, green: 0.48, blue: 0.33)],
        [Color(red: 0.65, green: 0.49, blue: 0.98), Color(red: 0.44, green: 0.28, blue: 0.92)]
    ]
    
    private var filteredClubs: [Club] {
        var result = allClubs
        
        if selectedCategory != "All" {
            result = result.filter { $0.category == selectedCategory }
        }
        
        if !searchText.isEmpty {
            result = result.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        
        return result
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // Category filter scroll view
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(categories, id: \.self) { category in
                                CategoryPill(
                                    title: category,
                                    isSelected: selectedCategory == category
                                ) {
                                    withAnimation(.spring()) {
                                        selectedCategory = category
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                    }
                    .background(Color(.systemBackground))
                    
                    // Clubs grid
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible())], spacing: 16) {
                        ForEach(filteredClubs) { club in
                            NavigationLink {
                                ClubDetailView(club: club)
                            } label: {
                                ClubCardView(club: club, gradient: cardGradients.randomElement()!)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(16)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Campus Clubs")
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showCreateClub = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.headline)
                            .padding(8)
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                }
            }
            .sheet(isPresented: $showCreateClub) {
                CreateClubView { newClub in
                    allClubs.append(newClub)
                }
            }
        }
    }
}

// MARK: - Components

struct ClubCardView: View {
    let club: Club
    let gradient: [Color]
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: gradient),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .aspectRatio(1, contentMode: .fill)
                
                Image(systemName: club.icon)
                    .font(.system(size: 32))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(club.name)
                    .font(.system(size: 16, weight: .semibold))
                    .lineLimit(1)
                
                Text("\(club.members) members")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemBackground))
        }
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.separator).opacity(0.3), lineWidth: 0.5)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 3)
    }
}

struct ClubDetailView: View {
    let club: Club
    @State private var isJoined = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header with gradient background
                ZStack(alignment: .bottomLeading) {
                    LinearGradient(
                        gradient: Gradient(colors: [Color.blue, Color.purple]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(height: 200)
                    .overlay(
                        Image(systemName: club.icon)
                            .font(.system(size: 80))
                            .foregroundColor(.white.opacity(0.2))
                            .offset(x: 100, y: 50)
                    )
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(club.name)
                            .font(.largeTitle.bold())
                            .foregroundColor(.white)
                        
                        HStack(spacing: 16) {
                            Label("\(club.members) members", systemImage: "person.2.fill")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.9))
                            
                            Label(club.category, systemImage: "tag.fill")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.9))
                        }
                    }
                    .padding()
                }
                
                // Club info section
                VStack(alignment: .leading, spacing: 16) {
                    if let description = club.description {
                        Text("About")
                            .font(.headline)
                        Text(description)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    
                    Divider()
                    
                    // Meeting info
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Meeting Information")
                            .font(.headline)
                        
                        InfoRow(icon: "clock", text: club.meetingTime ?? "Not specified")
                        InfoRow(icon: "mappin", text: club.location ?? "Location TBD")
                        InfoRow(icon: "person.fill", text: club.advisor ?? "Advisor TBD")
                    }
                }
                .padding()
                
                // Join button
                Button {
                    withAnimation {
                        isJoined.toggle()
                    }
                } label: {
                    Text(isJoined ? "Joined ✓" : "Join Club")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isJoined ? Color.green : Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .padding(.bottom)
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CategoryPill: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.accentColor : Color(.secondarySystemBackground))
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct InfoRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.accentColor)
                .frame(width: 24)
            Text(text)
            Spacer()
        }
    }
}

struct CreateClubView: View {
    @Environment(\.dismiss) var dismiss
    @State private var clubName = ""
    @State private var clubDescription = ""
    @State private var selectedCategory = "Academic"
    @State private var meetingTime = ""
    @State private var location = ""
    @State private var advisorName = ""
    @State private var selectedIcon = "person.3.fill"
    @State private var isSubmitted = false
    
    let categories = ["Academic", "Arts", "STEM", "Sports", "Cultural"]
    let icons = ["person.3.fill", "book.fill", "paintpalette.fill", "music.note", "atom", "sportscourt.fill"]
    var completion: (Club) -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Basic Info") {
                    TextField("Club Name", text: $clubName)
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { category in
                            Text(category)
                        }
                    }
                    
                    Picker("Icon", selection: $selectedIcon) {
                        ForEach(icons, id: \.self) { icon in
                            Label {
                                Text("Type")
                            } icon: {
                                Image(systemName: icon)
                            }
                        }
                    }
                }
                
                Section("Meeting Info") {
                    TextField("Meeting Time", text: $meetingTime)
                    TextField("Location", text: $location)
                    TextField("Advisor Name", text: $advisorName)
                }
                
                Section("Description") {
                    TextEditor(text: $clubDescription)
                        .frame(minHeight: 100)
                }
                
                Section {
                    Button("Submit for Approval") {
                        let newClub = Club(
                            name: clubName,
                            icon: selectedIcon,
                            members: 1, // Starting with creator as first member
                            category: selectedCategory,
                            meetingTime: meetingTime,
                            location: location,
                            advisor: advisorName,
                            description: clubDescription
                        )
                        completion(newClub)
                        isSubmitted = true
                    }
                    .disabled(!isFormValid)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .listRowBackground(isFormValid ? Color.accentColor : Color.gray)
                }
            }
            .navigationTitle("New Club")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("Submitted!", isPresented: $isSubmitted) {
                Button("OK") { dismiss() }
            } message: {
                Text("Your club has been submitted for approval.")
            }
        }
    }
    
    private var isFormValid: Bool {
        !clubName.isEmpty && !clubDescription.isEmpty
    }
}

#Preview{
    ClubsView()
}
