import SwiftUI
import RealityKit
import ARKit

struct ContentView : View {
    var body: some View {
        ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        let config = ARWorldTrackingConfiguration()
        config.environmentTexturing = .automatic
        arView.session.run(config)
        
        do {
            let modelEntity = try ModelEntity.load(named: "hhkb_studio")
            
                modelEntity.generateCollisionShapes(recursive: true)
                
                let anchorEntity = AnchorEntity(world: [0, 0, -0.5])
                anchorEntity.addChild(modelEntity)
                
                arView.scene.anchors.append(anchorEntity)
                
        } catch {
            fatalError("3dモデルの読み込みに失敗した: \(error)")
        }

        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

#Preview {
    ContentView()
}
