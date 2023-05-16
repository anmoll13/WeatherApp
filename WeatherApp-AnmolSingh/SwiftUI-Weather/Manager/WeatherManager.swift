//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Anmol Singh on 5/15/23.
//

import Foundation
import CoreLocation

class WeatherManager {
    
    //get current weather given the latitude and longitude
    func getCurrentWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> WeatherResponse {
        
        guard let url = URL(string:"https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=a21cc1d6d69eb4e22ab851ccb8baff8b&units=imperial")
            else {fatalError("URL Missing")}
        
        let urlRequest = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {fatalError("Error fetching Data")}
        
        let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
        
        return weatherResponse
    }
    
    
    //function to get city coordinates using the name
    func getCityCoordinates(enteredCity: String) async throws -> WeatherResponse {
        
        guard let url = URL(string:"https://api.openweathermap.org/geo/1.0/direct?q=\(enteredCity.replacingOccurrences(of: " ", with: "%20")),us&limit=1&appid=a21cc1d6d69eb4e22ab851ccb8baff8b")
            else {fatalError("URL Missing")}
        
        let urlRequest = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {fatalError("Error fetching Data")}
        

        do {
            let cityResponseArray = try JSONDecoder().decode([CityResponse].self, from: data)
            guard let cityResponse = cityResponseArray.first else { return try await getCurrentWeather(latitude: 33.0136764, longitude: -96.6925096) }
            print(cityResponse)
            
            return try await getCurrentWeather(latitude: cityResponse.lat, longitude: cityResponse.lon)
            
        } catch {
            print("Error decoding JSON: \(error)")
        }
        
        //default value in case no city response (Plano, TX)
        return try await getCurrentWeather(latitude: 33.0136764, longitude: -96.6925096)
    }
}









