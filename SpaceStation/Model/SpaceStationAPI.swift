//
//  SpaceStationAPI.swift
//  SpaceStation
//
//  Created by Juan Reyes on 8/18/21.
//

import Foundation
import UIKit

class SpaceStationAPI {
    
    static let shared = SpaceStationAPI()
    
    var spaceStationCache = [Int : SpaceStation]()
    var imageCache = [Int : UIImage]()
    var spaceStationsOnPage = [Int : [Int]]()
    
    var webURL = "https://ll.thespacedevs.com/2.2.0/spacestation/?format=json&limit=10"
    var pageNumber: Int = 1
    
    // Return SpaceStations from API
    func getSpaceStations() -> [SpaceStation] {
        var spaceStations = [SpaceStation]()
        
        NetworkManager.shared.fetchSpaceStations(webURL) { (stations) in
            spaceStations = stations
        }
        
        return spaceStations
    }
    
    // Add space station to caches
    func setSpaceStationsCache() {
        
        let spaceStations = getSpaceStations()
        var spaceStationIDs = [Int]()
        
        for spaceStation in spaceStations {
            if spaceStationCache[spaceStation.id] == nil {
                spaceStationCache[spaceStation.id] = spaceStation
            }
            
            spaceStationIDs.append(spaceStation.id)
            
        }
        
        spaceStationsOnPage[pageNumber] = spaceStationIDs
    }
    
    // Fetch space station images from API and add to cache
    func fetchStationImages() {
        let spaceStations = getSpaceStations()
        NetworkManager.shared.getStationImages(spaceStations) { [self] images in
            for (spaceStation, image) in zip(spaceStations, images) {
                imageCache[spaceStation.id] = image
            }
        }
    }
    
    // Return URL for the next/previous page
    func updateWebURL(_ pageNumber: Int) {
        if pageNumber == 1 {
            NetworkManager.shared.fetchResponse(webURL) { response in
                self.webURL = (response?.next)!
            }
        } else if pageNumber == 2 {
            NetworkManager.shared.fetchResponse(webURL) { response in
                self.webURL = (response?.previous)!
            }
        }
    }
    
    
}
