//
//  DrawingView.swift
//  DrawingApp
//
//  Created by Emmanuel Agene on 16/11/2024.
//

import SwiftUI

struct DrawingView: View {
    
    @Environment(\.scenePhase) var scenePhase
    
    @StateObject var drawingDocuments = DrawingDocument()
    @State private var deletedLines = [Line]()
    
    @StateObject var selectedColor = UserDefaultColor()
    @SceneStorage("selectedLineWidth") private var selectedLineWidth: Double = 1
    
    
    let engine = DrawingEngine()
    
    @State private var showConfirmation: Bool = false
    
    var body: some View {
        
        VStack {
            
            HStack {
                ColorPicker("Line Color", selection: $selectedColor.color)
                    .labelsHidden()
                
                Slider(value: $selectedLineWidth, in: 1...20) {
                    Text("Line Width")
                }.frame(maxWidth: 100)
                Text(String(format: "%.0f", selectedLineWidth))
                
                Spacer()
                
                Button(action: {
                    
                    let last = drawingDocuments.lines.removeLast()
                    deletedLines.append(last)
                    
                }, label: {
                    Image(systemName: "arrow.uturn.backward.circle")
                        .imageScale(.large)
                }).disabled(drawingDocuments.lines.count == 0)
                
                
                Button(action: {
                    
                  let last = deletedLines.removeLast()
                    
                    drawingDocuments.lines.append(last)
                    
                }, label: {
                    Image(systemName: "arrow.uturn.forward.circle")
                        .imageScale(.large)
                }).disabled(deletedLines.count == 0)
                
                Button("Delete") {
                    showConfirmation.toggle()
                    
                }
                .foregroundColor(.red)
                .confirmationDialog("Are you sure you want to Delete Everything..?", isPresented: $showConfirmation) {
                    
                    Button("Delete", role: .destructive) {
                        drawingDocuments.lines = [Line]()
                        deletedLines = [Line]()
                    }
                   
                }
            }
            .padding()
            
            ZStack {
                Color.white
                
                ForEach(drawingDocuments.lines) { line in
                    DrawingShape(point: line.points)
                        .stroke(line.color, style: StrokeStyle(lineWidth: line.lineWidth, lineCap: .round, lineJoin: .round))
                }
            }
//            Canvas { context, size in
//                
//                for line in lines {
//                    
//                    var path = engine.createPath(for: line.points)
//                    
////                    context.stroke(path, with: .color(line.color), lineWidth: line.lineWidth)
//                    
//                    context.stroke(path, with: .color(line.color), style: StrokeStyle(lineWidth: line.lineWidth, lineCap: .round, lineJoin: .round))
//                    
//                }
//            }
            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local).onChanged({ value in
                let newPoint = value.location
                if value.translation.width + value.translation.height == 0 {
                    //TODO: use selection color and linewidth
                    drawingDocuments.lines.append(Line(points: [newPoint], color: selectedColor.color, lineWidth: 5))
                } else {
                    let index = drawingDocuments.lines.count - 1
                    drawingDocuments.lines[index].points.append(newPoint)
                }
            })
                .onEnded({ value in
                    if let last = drawingDocuments.lines.last?.points, last.isEmpty {
                        drawingDocuments.lines.removeLast()
                    }
                })
            )
        }
        .onChange(of: scenePhase, perform: { newValue in
            if newValue == .background {
                drawingDocuments.save()
            }
        })
      
        
    }
}

#Preview {
    DrawingView()
}
