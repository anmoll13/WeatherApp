//
//  ContentView.swift
//  SwiftUI-Weather
//
//  Created by Anmol Singh on 5/15/23.
//

import SwiftUI
import CoreLocationUI
import URLImage


struct ContentView: View {
    
    @StateObject var locationManager = LocationManager()
    
    var weatherManager = WeatherManager()
    
    @State var weather: WeatherResponse?
    
    @State private var searchTerm = ""
    
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(colors: [.white, .blue], startPoint: UnitPoint.topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                
                VStack{
                    Text(weather?.name ?? "No City yet")
                        .font(.system(size: 32, weight: .medium, design: .default))
                        .foregroundColor(.black)
                        .padding()
                    VStack{
                        URLImage(URL(string: "https://openweathermap.org/img/w/\(weather?.weather[0].icon ?? "01d").png")!) { image in
                            image
                                .resizable()
                                .frame(width: 180, height: 180)
                        }

                        Text("\(String(format: "%.1f", weather?.main.temp ?? 0.0)) F")
                            .font(.system(size: 70, weight: .medium))
                            .foregroundColor(.white)

                    }
                    
                    
                    
                    LocationButton(.shareCurrentLocation){
                        //when location coordinates are received get local weather
                        locationManager.requestLocation()
                        getCurrentLocationWeather()
                    }
                    .cornerRadius(30)
                    .symbolVariant(.fill)
                    .foregroundColor(.white)
                    
                    Spacer()
                }
                
            }
        }
        //on submit search for the given city
        .searchable(text: $searchTerm)
        .onAppear(perform: setPreviousValues)
        .onSubmit(of: .search, searchByCity)
        
        
    }
    
    //load previously searched city
    func setPreviousValues(){
        let defaults = UserDefaults.standard
        if let lastSearchedCity = defaults.string(forKey: "lastSearchedCity") {
            Task{
                do {
                    weather = try await weatherManager.getCityCoordinates(enteredCity: lastSearchedCity)
                } catch {
                    print("Error getting weather: \(error)")
                }
            }
        }
    }
    //function to get current local weather once user allows coordinates
    func getCurrentLocationWeather(){
        if let location = locationManager.location {
            Task{
                do {
                    weather = try await weatherManager.getCurrentWeather(latitude: location.latitude, longitude: location.longitude)
                } catch {
                    print("Error getting weather: \(error)")
                        }
            }
        }
        else{
            print("Location Not Set Yet")
        }
    }
    //perform search for given city
    func searchByCity(){
        Task{
            do {
                weather = try await weatherManager.getCityCoordinates(enteredCity: searchTerm)
            } catch {
                print("Error getting weather: \(error)")
            }
        }
        // Save the last searched city
        let defaults = UserDefaults.standard
        defaults.set(searchTerm, forKey: "lastSearchedCity")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
