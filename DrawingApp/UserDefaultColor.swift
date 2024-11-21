//
//  UserDefaultColor.swift
//  DrawingApp
//
//  Created by Emmanuel Agene on 17/11/2024.
//

import Foundation
import SwiftUI
import Combine

class UserDefaultColor: ObservableObject {
    
    @Published var color: Color = .black
    
    var subscriptions = Set<AnyCancellable>()
    
    init() {
        // Loading from UserDefault
        if let data = UserDefaults.standard.data(forKey: key),
           let customColor = try? JSONDecoder().decode(CustomColor.self, from: data) {
            color = customColor.color
        }
        
        $color
            .map { color in
               try? CustomColor(color: color)
            }
            .encode(encoder: JSONEncoder())
            .sink { _ in
                
            } receiveValue: { data in
                UserDefaults.standard.set(data, forKey: self.key)
            }.store(in: &subscriptions)

        
        //Saving to userDefault
    }
    
    let key = "selectedColor"
    
}
