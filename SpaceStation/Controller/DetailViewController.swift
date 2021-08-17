//
//  DetailViewController.swift
//  SpaceStation
//
//  Created by Juan Reyes on 8/17/21.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var stationImage: UIImageView!
    @IBOutlet var stationName: UILabel!
    @IBOutlet var stationOwner: UILabel!
    @IBOutlet var stationFounded: UILabel!
    @IBOutlet var stationStatus: UILabel!
    @IBOutlet var stationDescription: UITextView!
    
    var image: UIImage = UIImage()
    var name: String = ""
    var owner: String = ""
    var founded: String = ""
    var status: String = ""
    var resultDescription: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stationDescription.isEditable = false
        
        stationImage.image = image
        stationName.text = name
        stationOwner.text = owner
        stationFounded.text = founded
        stationStatus.text = status
        stationDescription.text = resultDescription
        
    }

}
