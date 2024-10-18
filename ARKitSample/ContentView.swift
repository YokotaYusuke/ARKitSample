import SwiftUI
import RealityKit
import ARKit
import UIKit

struct ContentView : View {
    var body: some View {
        ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
        
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        config.environmentTexturing = .none
        arView.session.run(config)
        
        do {
            let anchorEntity = AnchorEntity(plane: .any)
            let modelEntity = try Entity.loadModel(named: "tenshinhan")
            
            modelEntity.generateCollisionShapes(recursive: true)
            anchorEntity.addChild(modelEntity)
            
            arView.installGestures(for: modelEntity as Entity & HasCollision)
            arView.scene.addAnchor(anchorEntity)
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
