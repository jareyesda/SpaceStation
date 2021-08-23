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
    
    var spaceStationCache = [Int : Response?]()
    var imageCache = [Int : UIImage]()
    var spaceStationsOnPage = [Int : [Int]]()
    
    var webURL = "https://ll.thespacedevs.com/2.2.0/spacestation/?format=json&limit=10"
    var pageNumber: Int = 0
    
    enum SpaceStationErrors: Error {
        case noNextResults
        case badNetworkResponse
    }
    
    // Return SpaceStations from API and cache response
    func getSpaceStations(page: Int, completion: @escaping (Result<[SpaceStation], Error>) -> Void) {
        var finalWebURL: String = ""
        
        if let cachedResponse = spaceStationCache[page] {
            completion(.success(cachedResponse?.results ?? []))
            
        }
        
        if page == 0 {
            finalWebURL = webURL
        } else if let nextWebURL = spaceStationCache[page-1]??.next {
            finalWebURL = nextWebURL
        } else {
            completion(.failure(SpaceStationErrors.noNextResults))
        }
        
        NetworkManager.shared.fetchSpaceStations(finalWebURL) { (stationResponse) in
            guard let stationResponse = stationResponse else {
                completion(.failure(SpaceStationErrors.badNetworkResponse))
                return
            }
            
            self.spaceStationCache[page] = stationResponse
            
            completion(.success(stationResponse.results))
        }
    }
    
    func getStationImages(spaceStations: [SpaceStation], completion: @escaping ([Int : UIImage]) -> ()) {
        
        for spaceStation in spaceStations {
            NetworkManager.shared.getStationImage(urlString: spaceStation.imageURL) { image in
                self.imageCache[spaceStation.id] = image
            }
        }
        
        completion(imageCache)
        
    }
    
}
