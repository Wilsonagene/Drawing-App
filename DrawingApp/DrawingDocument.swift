//
//  DrawingDocument.swift
//  DrawingApp
//
//  Created by Emmanuel Agene on 17/11/2024.
//

import Foundation
import Combine


class DrawingDocument: ObservableObject {
    
    @Published var lines = [Line]()
//    {
//        didSet {
//            save()
//        }
//    }
    
    var subcription = Set<AnyCancellable>()
    
    init() {
        //load data
        if FileManager.default.fileExists(atPath: url.path),
           let data = try? Data(contentsOf: url) {
            let decoder = JSONDecoder()
            do {
                let lines = try decoder.decode([Line].self, from: data)
                self.lines = lines
            } catch {
                print("DEcoding Error \(error)")
            }
        }
        
        $lines
            .filter({ $0.isEmpty })
//            .throttle(for: 2, scheduler: RunLoop.main, latest: true) //Fixed per interval
            .debounce(for: 2, scheduler: RunLoop.main) //Bursty Events
            .sink { [unowned self] lines in
            self.save()
        }.store(in: &subcription)
        
    }
    
//    func save()  {
//        DispatchQueue.global(qos: .background).async { [unowned self] in
//            let encoder = JSONEncoder()
//            let data = try? encoder.encode(lines)
//            
//            do {
//                try data?.write(to: self.url)
//            } catch {
//                print("Error Saving: \(error)")
//            }
//        }
//        
//    }
    func save() {
        DispatchQueue.global(qos: .background).async { [unowned self] in
            let encoder = JSONEncoder()
            guard let data = try? encoder.encode(self.lines) else {
                print("Failed to encode lines.")
                return
            }
            
            // Ensure the directory exists
            let directory = self.url.deletingLastPathComponent()
            do {
                // Create the directory if it doesn't exist
                try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
                
                // Write data to the file
                try data.write(to: self.url)
                print("Data saved successfully.")
            } catch {
                print("Error Saving: \(error)")
            }
        }
    }

    
    var url: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory.appendingPathComponent("Document").appendingPathComponent("json")
    }
    
}
