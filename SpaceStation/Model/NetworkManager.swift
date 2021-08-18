//
//  NetworkManager.swift
//  SpaceStationAPI
//
//  Created by Juan Reyes on 8/12/21.
//

import Foundation
import UIKit

struct NetworkManager {
    
    static let shared = NetworkManager()
    
    private let dispatchQueue = DispatchQueue(label: "Image Thread")
    
    // Fetch data
    private func fetchJSON(_ url: String) -> Data {
        let urlString = url
        var dataResponse = Data()
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                dataResponse = data
            }
        }
        return dataResponse
    }
    
    // Parse JSON
    private func parse(_ json: Data) ->  Response? {
        var retVal: Response?
        let decoder = JSONDecoder()
        if let jsonData = try? decoder.decode(Response.self, from: json) {
            retVal = jsonData
        }
        return retVal
    }
    
    // Fetch space stations for given API call
    func fetchSpaceStations(_ urlString: String, callback: @escaping ([SpaceStation]) -> ()) {
        var spaceStations = [SpaceStation]()
        
        let jsonData = fetchJSON(urlString)
        spaceStations = parse(jsonData)?.results ?? [SpaceStation]()
        
        callback(spaceStations)
    }
    
    // Fetch response for given API call
    func fetchResponse(_ urlString: String, callback: @escaping (Response?) -> ()) {
        var response: Response?
        
        let jsonData = fetchJSON(urlString)
        response = parse(jsonData)
        
        callback(response)
    }
    
    func getStationImages(_ spaceStations: [SpaceStation], callback: @escaping ([Int:UIImage]) -> ()) {
        
        var stationImages = [Int:UIImage]()
        let group = DispatchGroup()
        
        for spaceStation in spaceStations {
            group.enter()
            dispatchQueue.async {
                guard let url = URL(string: spaceStation.imageURL) else {
                    return
                }
                guard let data = try? Data(contentsOf: url) else {
                    return
                }
                
                stationImages[spaceStation.id] = (UIImage(data: data)!)
                
                group.leave()
            }
        }
        
        group.notify(queue: dispatchQueue) {
            callback(stationImages)
        }
    }
}
