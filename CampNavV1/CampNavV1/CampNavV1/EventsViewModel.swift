//
//  EventsViewModel.swift
//  CampNavV1
//
//  Created by Christian Berko (RIT Student) on 4/17/25.
//

import SwiftUI

class EventsViewModel: ObservableObject {
    @Published var events: [CampusEvent] = []
    
    func fetchEvents(){
        guard let url = URL(string: "http://129.21.63.14:3000/api/events") else{
            print("ur url is ass nigga get a new one")
            return
        }
        
        URLSession.shared.dataTask(with: url) {data, response, error in
            if let data = data {
                do{
                    let event = try JSONDecoder().decode(CampusEvent.self, from: data)
                    DispatchQueue.main.sync {
                        self.events = [event]
                    }
                } catch{
                    print("Decoding error: \(error)")
                }
            } else if let error = error{
                print("Error fetching data: \(error)")
            }
        }.resume()
    }
}

#Preview {
    
}
