//
//  Weather.swift
//  MyWeatherApp
//
//  Created by Lambda_School_Loaner_201 on 3/13/20.
//  Copyright © 2020 Christian Lorenzo. All rights reserved.
//

import Foundation
import CoreLocation


struct Weather {
    let summary: String
    let icon: String
    let temperature: Double
    
    enum SerializationError: Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    init(json: [String: Any]) throws {
        guard let summary = json["summary"] as? String else { throw SerializationError.missing("Summary is missing") }
        guard let icon = json["icon"] as? String else { throw SerializationError.missing("Icon is missing") }
        guard let temperature = json["temperatureMax"] as? Double else { throw SerializationError.missing("Temperature is missing") }
        
        self.summary = summary
        self.icon = icon
        self.temperature = temperature
    }
    
    static let basePath = "https://api.darksky.net/forecast/0cbd162841ae26295c2a901a89a7bfec/"
    
    static func forecast(withLocation location: CLLocationCoordinate2D, completion: @escaping ([Weather]?) -> ()) {
        let url = basePath + "\(location.latitude),\(location.longitude)"
        let request = URLRequest(url: URL(string: url)!)
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            var foreCastArray: [Weather] = []
            
            if let data = data {
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let dailyForeCast = json["daily"] as? [String: Any] {
                            if let dailyData = dailyForeCast["data"] as? [[String: Any]] {
                                for dataPoint in dailyData {
                                    if let weatherObject = try? Weather(json: dataPoint) {
                                        foreCastArray.append(weatherObject)
                                    }
                                }
                            }
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
                
                completion(foreCastArray)
            }
        }
        
        dataTask.resume()
    }
}
