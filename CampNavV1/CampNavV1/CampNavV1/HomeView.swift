import SwiftUI

struct EventsView: View {
    // Sample categories for filtering
    let categories = ["All", "Clubs", "Campus-wide Events", "RIT Athletics", "Workshops"]
    @State private var selectedCategory = "All"
    
    // Gradient colors for cards
    let cardGradients = [
        [Color(red: 0.97, green: 0.47, blue: 0.48), Color(red: 0.96, green: 0.35, blue: 0.67)],
        [Color(red: 0.38, green: 0.71, blue: 0.92), Color(red: 0.22, green: 0.42, blue: 0.94)],
        [Color(red: 0.28, green: 0.80, blue: 0.71), Color(red: 0.18, green: 0.45, blue: 0.82)],
        [Color(red: 1.00, green: 0.78, blue: 0.33), Color(red: 0.96, green: 0.48, blue: 0.33)],
        [Color(red: 0.65, green: 0.49, blue: 0.98), Color(red: 0.44, green: 0.28, blue: 0.92)]
    ]
    
    var filteredEvents: [Event] {
        if selectedCategory == "All" {
            return sampleEvents
        } else {
            return sampleEvents.filter { $0.category == selectedCategory }
        }
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
                    
                    // Events feed
                    LazyVStack(spacing: 12) {
                        ForEach(filteredEvents) { event in
                            NavigationLink {
                                EventDetailView(event: event)
                            } label: {
                                EventCard(event: event, gradient: cardGradients.randomElement()!)
                                    .padding(.horizontal, 12)
                                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 24)
                }
            }
            .navigationTitle("Upcoming Events")
            .navigationBarTitleDisplayMode(.large)
            .background(Color(.systemGroupedBackground))
        }
    }
}

// Event Detail View
struct EventDetailView: View {
    let event: Event
    @State private var isReminded = false
    @State private var showToast = false
    @State private var toastMessage = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header with gradient
                ZStack(alignment: .bottomLeading) {
                    LinearGradient(
                        gradient: Gradient(colors: [Color.blue, Color.purple]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(height: 250)
                    .overlay(
                        Image(systemName: "calendar")
                            .font(.system(size: 100))
                            .foregroundColor(.white.opacity(0.2))
                            .offset(x: 100, y: 50)
                    )
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(event.title)
                            .font(.largeTitle.bold())
                            .foregroundColor(.white)
                        
                        Text(event.category)
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .padding()
                }
                
                // Event details
                VStack(alignment: .leading, spacing: 16) {
                    if let description = event.description {
                        Text("About")
                            .font(.title2.bold())
                            .padding(.bottom, 4)
                        
                        Text(description)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    
                    Divider()
                    
                    // Date and time
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Date & Time")
                            .font(.headline)
                        
                        HStack(spacing: 20) {
                            VStack(alignment: .leading, spacing: 8) {
                                Label(event.date, systemImage: "calendar")
                                Label(event.time, systemImage: "clock")
                            }
                            
                            Spacer()
                            
                            Button {
                                isReminded.toggle()
                                showToast(message: "Reminders coming soon!")
                            } label: {
                                VStack {
                                    Image(systemName: isReminded ? "bell.fill" : "bell")
                                        .font(.title2)
                                    Text(isReminded ? "Reminded" : "Remind Me")
                                        .font(.caption)
                                }
                                .foregroundColor(isReminded ? .yellow : .accentColor)
                            }
                        }
                    }
                    
                    Divider()
                    
                    // Location
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Location")
                            .font(.headline)
                        
                        HStack(spacing: 20) {
                            Label(event.location, systemImage: "mappin.and.ellipse")
                            
                            Spacer()
                            
                            Button {
                                showToast(message: "AR navigation coming soon!")
                            } label: {
                                VStack {
                                    Image(systemName: "arrow.triangle.turn.up.right.diamond.fill")
                                        .font(.title2)
                                    Text("Take Me There")
                                        .font(.caption)
                                }
                                .foregroundColor(.accentColor)
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .overlay(
                   ToastView(message: toastMessage)
                       .opacity(showToast ? 1 : 0)
                       .animation(.easeInOut(duration: 0.3)),
                   alignment: .bottom
               )
               .background(Color(.systemGroupedBackground))
               .navigationBarTitleDisplayMode(.inline)
           }
           
           private func showToast(message: String) {
               toastMessage = message
               showToast = true
               DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                   withAnimation {
                       showToast = false
                   }
               }
           }
       }

       struct ToastView: View {
           let message: String
           
           var body: some View {
               Text(message)
                   .padding()
                   .background(Color.black.opacity(0.7))
                   .foregroundColor(.white)
                   .cornerRadius(8)
                   .padding(.bottom, 44)
           }
       }

// Category filter pill
struct CategoryPillEvents: View {
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
                        .fill(isSelected ? Color.blue : Color(.secondarySystemBackground))
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// Event card view
struct EventCard: View {
    let event: Event
    let gradient: [Color]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Event image placeholder with gradient
            LinearGradient(
                gradient: Gradient(colors: gradient),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 200)
            .overlay(
                VStack {
                    Spacer()
                    HStack {
                        Text(event.category.uppercased())
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.black.opacity(0.4))
                            .cornerRadius(4)
                        Spacer()
                    }
                    .padding(12)
                }
            )
            
            // Event details
            VStack(alignment: .leading, spacing: 8) {
                Text(event.title)
                    .font(.system(size: 18, weight: .bold))
                    .lineLimit(2)
                
                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        Label(event.date, systemImage: "calendar")
                        Label(event.time, systemImage: "clock")
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Label(event.location, systemImage: "mappin.and.ellipse")
                    }
                }
                .font(.system(size: 14))
                .foregroundColor(.secondary)
            }
            .padding(16)
            .background(Color(.systemBackground))
        }
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.separator).opacity(0.3), lineWidth: 0.5)
        )
    }
}

// Event Model
struct Event: Identifiable {
    let id = UUID()
    let title: String
    let date: String
    let time: String
    let location: String
    let image: String
    let category: String
    let description: String?
}


// Sample Data
let sampleEvents = [
    Event(
        title: "Tech Club Meetup",
        date: "March 30, 2025",
        time: "6:00 PM",
        location: "Student Center",
        image: "event1",
        category: "Clubs",
        description: "Join us for our monthly tech club gathering where we'll discuss the latest in software development and network with fellow tech enthusiasts."
    ),
    Event(
        title: "Music Night",
        date: "April 5, 2025",
        time: "8:00 PM",
        location: "Main Hall",
        image: "event2",
        category: "Campus-wide Events",
        description: "An evening of live performances from student bands and solo artists across various genres. Free admission for all students."
    ),
    Event(
        title: "Career Fair",
        date: "April 12, 2025",
        time: "10:00 AM",
        location: "Gymnasium",
        image: "event3",
        category: "Campus-wide Events",
        description: "Connect with top employers from various industries looking to hire RIT students. Bring your resume and dress professionally."
    ),
    Event(
        title: "Men's Tennis vs Hobart",
        date: "April 17, 2025",
        time: "03:00 PM",
        location: "Gordon Field House",
        image: "event3",
        category: "RIT Athletics",
        description: "Cheer on our RIT Tigers as they face Hobart College in an exciting tennis match. Free for students with ID."
    ),
    Event(
        title: "iOS Development Workshop",
        date: "April 20, 2025",
        time: "2:00 PM",
        location: "Golisano College",
        image: "event4",
        category: "Workshops",
        description: "Learn the fundamentals of iOS app development in this hands-on workshop. No prior experience required. Bring your Mac laptop."
    ),
    Event(
        title: "Film Festival",
        date: "April 22, 2025",
        time: "7:00 PM",
        location: "Ingle Auditorium",
        image: "event5",
        category: "Campus-wide Events",
        description: "Screening of student-produced short films followed by Q&A with the filmmakers. Free popcorn for all attendees."
    )
]
struct EventsView_Previews: PreviewProvider {
    static var previews: some View {
        EventsView()
    }
}
