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
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        config.environmentTexturing = .none
        arView.session.run(config)
        
        do {
            let anchorEntity = AnchorEntity(plane: .any)
            let modelEntity = try Entity.loadModel(named: "gyoza")
            
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
    
    class Coordinator: NSObject {
        var view: ARView?
        
        @objc
        func handleLongPress(_ recognizer: UITapGestureRecognizer? = nil) {
            guard let view = self.view else { return }
            
            let tapLocation = recognizer!.location(in: view)
            
            if let entity = view.entity(at: tapLocation) as? ModelEntity {
                if let anchorEntity = entity.anchor {
                    print("coordinatorが実行された")
                    anchorEntity.removeFromParent()
                }
            }
        }
    }
    
}

#Preview {
    ContentView()
}
