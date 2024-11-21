//
//  DrawingShape.swift
//  DrawingApp
//
//  Created by Emmanuel Agene on 16/11/2024.
//

import SwiftUI

struct DrawingShape: Shape {
  
    let point: [CGPoint]
    let engine = DrawingEngine()
    
    func path(in rect: CGRect) -> Path {
        engine.createPath(for: point)
    }
}

//#Preview {
//    DrawingShape()
//}
