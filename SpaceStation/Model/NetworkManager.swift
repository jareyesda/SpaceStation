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
    func fetchSpaceStations(_ urlString: String, callback: @escaping (Response?) -> ()) {
        DispatchQueue.global().async {
            var response: Response?
            
            let jsonData = fetchJSON(urlString)
            response = parse(jsonData)
            
            callback(response)
        }
    }
    
    // Fetch response for given API call
    func fetchResponse(_ urlString: String, callback: @escaping (Response?) -> ()) {
        DispatchQueue.global().async {
            var response: Response?
            
            let jsonData = fetchJSON(urlString)
            response = parse(jsonData)
            
            callback(response)
        }
    }
    
    func getStationImages(_ spaceStations: [SpaceStation], callback: @escaping ([UIImage]) -> ()) {

        var stationImages = [UIImage]()
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

                stationImages.append((UIImage(data: data)!))

                group.leave()
            }
        }

        group.notify(queue: dispatchQueue) {
            callback(stationImages)
        }
    }
    
//    func fetchStationImages(_ spaceStations: [SpaceStation]) -> [UIImage] {
//
//        var stationImages = [UIImage]()
//
//        for spaceStation in spaceStations {
//            guard let url = URL(string: spaceStation.imageURL) else {
//                return []
//            }
//            URLSession.shared.dataTask(with: url) { (data, response, error) in
//                if error == nil {
//                    guard let data = data else {
//                        return
//                    }
//                    if let image = UIImage(data: data) {
//                        stationImages.append(image)
//                    }
//
//                }
//            }.resume()
//        }
//        print(stationImages)
//        return stationImages
//    }
    
}
