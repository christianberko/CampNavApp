import SwiftUI
import MapKit
import CoreLocation
import ARKit
import RealityKit

struct MapView: View {
    enum ViewMode: String, CaseIterable {
        case map = "Campus Map"
        case ar = "AR Navigation"
    }
    
    @StateObject private var locationManager = LocationManager()
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var selectedViewMode: ViewMode = .map
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // View Mode Picker
                Picker("View Mode", selection: $selectedViewMode) {
                    ForEach(ViewMode.allCases, id: \.self) { mode in
                        Text(mode.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color(.systemGroupedBackground))
                
                // Main Content
                ZStack {
                    if selectedViewMode == .map {
                        mapLayer
                            .overlay(alignment: .bottomTrailing) {
                                locationButton
                                    .padding(.trailing, 16)
                                    .padding(.bottom, 16)
                            }
                    } else {
                        ARPlaceholderView()
                    }
                }
            }
            .navigationTitle("Campus Navigation")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            .alert(
                "Location Access Required",
                isPresented: $locationManager.showPermissionAlert,
                actions: {
                    Button("Cancel", role: .cancel) {}
                    Button("Open Settings") {
                        locationManager.openSettings()
                    }
                },
                message: {
                    Text("Please enable location access in Settings to see your position on the map.")
                }
            )
            .onAppear {
                locationManager.requestLocationPermission()
            }
        }
    }
    
    private var mapLayer: some View {
        Map(position: $cameraPosition) {
            if locationManager.authorizationStatus == .authorizedWhenInUse ||
               locationManager.authorizationStatus == .authorizedAlways {
                UserAnnotation()
            }
        }
        .mapStyle(.hybrid)
        .mapControls {
            MapCompass()
            MapScaleView()
        }
    }
    
    private var locationButton: some View {
        Button {
            handleLocationButtonTap() // ← Use this instead of direct code
        } label: {
            Image(systemName: "location.fill")
                .font(.body.bold())
                .padding(10)
                .background(.thickMaterial)
                .cornerRadius(4)
                .shadow(radius: 3)
        }
    }
    
    private func handleLocationButtonTap() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestLocationPermission()
        case .denied, .restricted:
            locationManager.showPermissionAlert = true
        case .authorizedAlways, .authorizedWhenInUse:
            guard let userLocation = locationManager.lastLocation else {
                locationManager.startUpdatingLocation()
                return
            }
            
            withAnimation(.easeInOut) {
                // Use MapCamera for smoother transitions
                cameraPosition = .camera(
                    MapCamera(
                        centerCoordinate: userLocation,
                        distance: 400,  // Zoom distance in meters
                        heading: 0,     // Direction the camera is pointing
                        pitch: 45       // Camera angle (0 = straight down)
                    )
                )
            }
        @unknown default:
            break
        }
    }
    
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var showPermissionAlert = false
    @Published var lastLocation: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocationPermission() {
        let status = locationManager.authorizationStatus
        
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if status == .denied || status == .restricted {
            showPermissionAlert = true
        } else {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            showPermissionAlert = true
        default:
            break
        }
    }
    
    func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
    
    func startUpdatingLocation() {
           locationManager.startUpdatingLocation()
       }
       
       func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           guard let location = locations.last else { return }
           lastLocation = location.coordinate
           print("Updated location: \(location.coordinate)")
       }
}

struct ARPlaceholderView: View {
    @State private var showBuildingList = false
    @State private var selectedBuilding: Building?
    
    let buildings = [
        Building(name: "Wallace Library", floorPlan: "floorA"),
        Building(name: "Student Alumni Union", floorPlan: "SAUFloorPlans"),
        Building(name: "Student Alumni Union", floorPlan: "SAUFloorPlans")
        // Add other buildings...
    ]
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image(systemName: "arkit")
                    .font(.system(size: 60))
                    .foregroundColor(.accentColor)
                
                Text("AR Campus Navigation")
                    .font(.title2.bold())
                
                Text("View building floor plans and navigate campus")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 40)
                
                Button(action: {
                    showBuildingList = true
                }) {
                    Text("View Floor Plans")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 15)
                        .background(Color.blue)
                        .clipShape(Capsule())
                }
                .padding(.top, 20)
                .sheet(isPresented: $showBuildingList) {
                    BuildingListView(buildings: buildings) { building in
                        selectedBuilding = building
                    }
                }
                .sheet(item: $selectedBuilding) { building in
                    PDFViewer(fileName: building.floorPlan)
                }
            }
        }
    }
}

struct Building: Identifiable {
    let id = UUID()
    let name: String
    let floorPlan: String // PDF filename without extension
}

struct BuildingListView: View {
    let buildings: [Building]
    let onSelect: (Building) -> Void
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            List(buildings) { building in
                Button(action: {
                    onSelect(building)
                    dismiss()
                }) {
                    HStack {
                        Image(systemName: "building.columns")
                            .foregroundColor(.blue)
                        Text(building.name)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("Select Building")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct PDFViewer: View {
    let fileName: String
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            PDFKitView(fileName: fileName)
                .navigationTitle("Floor Plan")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            dismiss()
                        }
                    }
                }
        }
    }
}

import PDFKit

struct PDFKitView: UIViewRepresentable {
    let fileName: String
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.displayDirection = .vertical
        
        if let url = Bundle.main.url(forResource: fileName, withExtension: "pdf") {
            pdfView.document = PDFDocument(url: url)
        }
        
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: Context) {}
}


//extension CLLocationCoordinate2D {
//    static var myLocation: CLLocationCoordinate2D {
//        return .init(latitude: 43.0844, longitude: -77.6749)
//    }
//}
//
//extension MKCoordinateRegion {
//    static var myRegion: MKCoordinateRegion {
//        return .init(center: .myLocation, latitudinalMeters: 500, longitudinalMeters: 500)
//    }
//}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
