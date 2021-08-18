//
//  SpaceStationAPI.swift
//  SpaceStation
//
//  Created by Juan Reyes on 8/18/21.
//

import Foundation

class SpaceStationAPI {
    
    static let shared = SpaceStationAPI()
    
    var webURL = "https://ll.thespacedevs.com/2.2.0/spacestation/?format=json&limit=10"
    
    func getSpaceStations() -> [SpaceStation] {
        var spaceStations = [SpaceStation]()
        
        NetworkManager.shared.fetchSpaceStations(webURL) { (stations) in
            spaceStations = stations
        }
        
        return spaceStations
    }
    
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
