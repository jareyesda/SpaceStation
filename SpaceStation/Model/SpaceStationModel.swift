//
//  SpaceStationModel.swift
//  SpaceStation
//
//  Created by Juan Reyes on 8/12/21.
//

import Foundation
import UIKit

struct SpaceStationModel {
    let id: Int
    let name: String
    let status, type: Status
    let founded: String
    let deorbited: String?
    let resultDescription: String
    let orbit: Orbit
    let owners: [Owner]
    let imageURL: String
}
