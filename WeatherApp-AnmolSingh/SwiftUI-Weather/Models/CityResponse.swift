//
//  CityResponse.swift
//  SwiftUI-Weather
//
//  Created by Anmol Singh on 5/16/23.
//

import Foundation

// MARK: - CityResponse
struct CityResponse: Codable {
    let name: String
    //let localNames: [String: String]
    let lat: Double
    let lon: Double
    let country: String
    let state: String
    
    enum CodingKeys: String, CodingKey {
        case name
        //case localNames = "local_names"
        case lat
        case lon
        case country
        case state
    }
}
