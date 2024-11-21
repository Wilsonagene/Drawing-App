//
//  Line.swift
//  DrawingApp
//
//  Created by Emmanuel Agene on 16/11/2024.
//

import Foundation
import SwiftUI


struct Line: Identifiable, Codable {
    
    var points: [CGPoint]
    var color: Color {
        get {
            customColor.color
        }
        set {
            do {
                customColor = try CustomColor(color: newValue)
            } catch {
                print("Failed to initialize CustomColor: \(error)")
            }
        }
    }
    private var customColor: CustomColor
    var lineWidth: CGFloat
    
    var id = UUID()
    
    init(points: [CGPoint], color: Color, lineWidth: CGFloat) {
        self.points = points
        self.lineWidth = lineWidth
        self.id = UUID()
        do {
            self.customColor = try CustomColor(color: color)
        } catch {
            print("Failed to initialize CustomColor: \(error)")
            self.customColor = CustomColor() // Provide a fallback default
        }
    }
}

struct CustomColor: Codable {
    
    var green: Double = 0
    var blue: Double = 0
    var red: Double = 0
    var opacity: Double = 1
    
    init() {}
    
    init(color: Color) throws {
        if let components = color.cgColor?.components, components.count >= 3 {
            self.red = components[0]
            self.green = components[1]
            self.blue = components[2]
            self.opacity = components.count > 3 ? components[3] : 1.0
        } else {
            throw NSError(domain: "CustomColor", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid Color components"])
        }
    }
    
    var color: Color {
        Color(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}


//struct Line: Identifiable, Codable {
//    
//    var points: [CGPoint]
//    var color: Color {
//        get {
//            customColor.color
//        }
//        set {
//            customColor = CustomColor(color: newValue) // ERROR: Call can throw, but it is not marked with 'try' and the error is not handled
//        }
//    }
//    private var customColor: CustomColor
//    var lineWidth: CGFloat
//    
//    let id = UUID()
//    
//    init(points: [CGPoint], color: Color, lineWidth: CGFloat) {
//        self.points = points
//        self.customColor = CustomColor(from: color) //ERROR: Argument type 'Color' does not conform to expected type 'Decoder'
//        self.lineWidth = lineWidth
//        self.id = UUID()
//    }
//    
//}
//
//
//struct CustomColor: Codable {
//    
//    var green: Double = 0
//    var blue: Double = 0
//    var red: Double = 0
//    var opacity: Double = 1
//    
//    init(color: Color) throws {
//        if let componets = color.cgColor?.components {
//            if componets.count > 2 {
//                self.red = componets[0]
//                self.green = componets[1]
//                self.blue = componets[2]
//            }
//            
//            if  componets.count > 3 {
//                self.opacity = componets[3]
//            }
//        }
//    }
//    
//    var color: Color {
//        Color(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
//    }
//    
//}
