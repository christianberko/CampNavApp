//
//  Event.swift
//  CampNavV1
//
//  Created by Christian Berko (RIT Student) on 4/17/25.
//

import SwiftUI


struct CampusEvent: Codable, Identifiable{
    let id = UUID()
    let title: String
    let date: String
    let link: String
    let description: String
}
 
