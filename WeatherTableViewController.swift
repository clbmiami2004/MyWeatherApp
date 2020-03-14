//
//  WeatherTableViewController.swift
//  MyWeatherApp
//
//  Created by Lambda_School_Loaner_201 on 3/13/20.
//  Copyright © 2020 Christian Lorenzo. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherTableViewController: UITableViewController, UISearchBarDelegate {
    
    //Properties:
    
    var foreCastData = [Weather]()
    
    @IBOutlet weak var searchBarOutlet: UISearchBar!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBarOutlet.delegate = self //Name of Outlet
        updateWeatherForLocation(location: "Las Vegas")
        
    }
    
    //Methods:

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) { //Delegate Function
        searchBar.resignFirstResponder() //The keyboard is hidden or it hides as soon as the user enters something on the search bar.
        
        if let locationString = searchBar.text, !locationString.isEmpty { // Making sure Location is not empty
            updateWeatherForLocation(location: locationString)
        }
    }
        
    
    
    func updateWeatherForLocation(location: String) {
        CLGeocoder().geocodeAddressString(location) { (placemarks:[CLPlacemark]?, error: Error?) in //We need to import Corelocation in order to be able to use geolocation
            if error == nil {
                if let location = placemarks?.first?.location { //Checking if we have a location
                    Weather.forecast(withLocation: location.coordinate, completion: { (results: [Weather]?) in //Location coordinate comes from latitude and longitude. We want to use this array along the app. This is why we're creating a property on top.
                        
                        if let weatherData = results {
                            self.foreCastData = weatherData // Sending the results to the array Weather.
                            
                            DispatchQueue.main.async { // Reload the tableView. All the updates need to be performed on the Main thread. Using DsipatchQueue. This triggers the number of sections and the number of rows in section. 
                                self.tableView.reloadData()
                            }
                        }
                    })
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return foreCastData.count
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let weatherObject = foreCastData[indexPath.section]
        
        // Configure the cell...
        
        cell.textLabel?.text = weatherObject.summary
        cell.detailTextLabel?.text = "\(Int(weatherObject.temperature)) °F"
        //cell.imageView?.image = UIImage(named: weatherObject.icon)

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = Calendar.current.date(byAdding: .day, value: section, to: Date())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        
        return dateFormatter.string(from: date!)
    }
}
