//
//  ARViews.swift
//  CampNavV1
//
//  Created by Christian Berko (RIT Student) on 4/26/25.
//


//
//import SwiftUI
//import RealityKit
//import ARKit
//
//struct ARBuildingView: View {
//    @State private var selectedBuilding: CampusBuilding?
//    @State private var arModelAnchor: AnchorEntity?
//    
//    let buildings: [CampusBuilding] = [
//        CampusBuilding(
//            name: "Student Alumni Hall",
//            coordinate: CLLocationCoordinate2D(latitude: 43.0830, longitude: -77.6760),
//            modelName: "sah_model"
//        ),
//        // Add other buildings...
//    ]
//    
//    var body: some View {
//        ZStack(alignment: .bottom) {
//            // AR View
//            ARViewContainer(
//                selectedBuilding: $selectedBuilding,
//                modelAnchor: $arModelAnchor
//            )
//            .edgesIgnoringSafeArea(.all)
//            
//            // Building Selection List
//            ScrollView(.horizontal, showsIndicators: false) {
//                HStack(spacing: 15) {
//                    ForEach(buildings) { building in
//                        Button(action: {
//                            selectedBuilding = building
//                            loadModel(building.modelName)
//                        }) {
//                            VStack {
//                                Image(systemName: "building.2.fill")
//                                    .font(.title)
//                                    .foregroundColor(.white)
//                                    .padding(10)
//                                    .background(Color.blue)
//                                    .clipShape(Circle())
//                                
//                                Text(building.name)
//                                    .font(.caption)
//                                    .foregroundColor(.primary)
//                            }
//                        }
//                    }
//                }
//                .padding()
//            }
//            .background(.ultraThinMaterial)
//        }
//    }
//    
//    private func loadModel(_ modelName: String) {
//        arModelAnchor?.removeFromParent()
//        
//        let anchor = AnchorEntity(plane: .horizontal)
//        if let model = try? Entity.load(named: "\(modelName).usdz") {
//            anchor.addChild(model)
//            arModelAnchor = anchor
//        }
//    }
//}
//
//struct ARViewContainer: UIViewRepresentable {
//    @Binding var selectedBuilding: CampusBuilding?
//    @Binding var modelAnchor: AnchorEntity?
//    
//    func makeUIView(context: Context) -> ARView {
//        let arView = ARView(frame: .zero)
//        
//        // Configure AR session
//        let config = ARWorldTrackingConfiguration()
//        config.planeDetection = [.horizontal]
//        arView.session.run(config)
//        
//        // Add tap gesture
//        let tapGesture = UITapGestureRecognizer(
//            target: context.coordinator,
//            action: #selector(Coordinator.handleTap)
//        arView.addGestureRecognizer(tapGesture)
//        )
//        return arView
//    }
//    
//    func updateUIView(_ uiView: ARView, context: Context) {
//        if let anchor = modelAnchor {
//            uiView.scene.addAnchor(anchor)
//        }
//    }
//    
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//    
//    class Coordinator: NSObject {
//        var parent: ARViewContainer
//        
//        init(_ parent: ARViewContainer) {
//            self.parent = parent
//        }
//        
//        @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
//            guard let arView = recognizer.view as? ARView else { return }
//            
//            let tapLocation = recognizer.location(in: arView)
//            
//            // Raycast to place model
//            if let raycastResult = arView.raycast(
//                from: tapLocation,
//                allowing: .estimatedPlane,
//                alignment: .horizontal
//            ).first {
//                if let anchor = parent.modelAnchor {
//                    anchor.transform = Transform(
//                        matrix: raycastResult.worldTransform
//                    )
//                }
//            }
//        }
//    }
//}
//
//// Building model
//struct CampusBuilding: Identifiable {
//    let id = UUID()
//    let name: String
//    let coordinate: CLLocationCoordinate2D
//    let modelName: String
//}
//
//// Preview
//struct ARBuildingView_Previews: PreviewProvider {
//    static var previews: some View {
//        ARBuildingView()
//    }
//}
