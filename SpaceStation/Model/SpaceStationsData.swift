// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let spaceStations = try? newJSONDecoder().decode(SpaceStations.self, from: jsonData)

import Foundation

// MARK: - SpaceStations
struct SpaceStations: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Result]
}

// MARK: - Result
struct Result: Codable {
    let id: Int
    let url: String
    let name: String
    let status, type: Status
    let founded: String
    let deorbited: String?
    let resultDescription: String
    let orbit: Orbit
    let owners: [Owner]
    let imageURL: String

    enum CodingKeys: String, CodingKey {
        case id, url, name, status, type, founded, deorbited
        case resultDescription = "description"
        case orbit, owners
        case imageURL = "image_url"
    }
}

enum Orbit: String, Codable {
    case lowEarthOrbit = "Low Earth Orbit"
}

// MARK: - Owner
struct Owner: Codable {
    let id: Int
    let url: String
    let name, abbrev: String
}

// MARK: - Status
struct Status: Codable {
    let id: Int
    let name: String
}
