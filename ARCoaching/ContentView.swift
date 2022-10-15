//
//  ContentView.swift
//  ARCoaching
//
//  Created by Zaid Neurothrone on 2022-10-15.
//

import ARKit
import RealityKit
import SwiftUI

struct ContentView : View {
  var body: some View {
    ARViewContainer().edgesIgnoringSafeArea(.all)
  }
}

extension ARView: ARCoachingOverlayViewDelegate {
  func addCoaching() {
    let coachingOverlay = ARCoachingOverlayView()
    coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    coachingOverlay.goal = .horizontalPlane
    coachingOverlay.session = self.session
    coachingOverlay.delegate = self
    self.addSubview(coachingOverlay)
  }
  
  private func addVirtualObjects() {
    let box = ModelEntity(mesh: .generateBox(size: 0.3), materials: [SimpleMaterial(color: .green, isMetallic: true)])
    
    guard let anchor = self.scene.anchors.first(where: { $0.name == "Plane Anchor" }) else {
      return
    }
    
    anchor.addChild(box)
  }
  
  public func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
    addVirtualObjects()
  }
}

struct ARViewContainer: UIViewRepresentable {
  func makeUIView(context: Context) -> ARView {
    let arView = ARView(frame: .zero)
    let anchor = AnchorEntity(plane: .horizontal)
    anchor.name = "Plane Anchor"
    arView.scene.addAnchor(anchor)
    arView.addCoaching()
    return arView
  }
  
  func updateUIView(_ uiView: ARView, context: Context) {}
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
#endif
