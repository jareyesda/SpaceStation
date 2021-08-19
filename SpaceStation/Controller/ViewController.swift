//
//  ViewController.swift
//  SpaceStation
//
//  Created by Juan Reyes on 8/12/21.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - IB Outlets
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var previousButton: UIButton!
    @IBOutlet var activity: UIActivityIndicatorView!
    
    //MARK: - Variables/Constants
    let networkManager = NetworkManager()
    
    // Data source for CollectionView
    var spaceStations = [SpaceStation]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var stationImages = [UIImage?]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var pageNumber: Int = 1 {
        didSet {
            collectionView.reloadData()
        }
    }
    
                    
    //MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        createPageView()
        
        previousButton.isEnabled = false
        
    }
    
    //MARK: - Applying cell UI
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setCellUI()
    }
    
    //MARK: - CollectionView UI Config
    private func setCellUI() {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
    }
    
    func createPageView() {
        // Reset data
        spaceStations.removeAll()
        stationImages.removeAll()
        
        // Set space station array
        spaceStations = SpaceStationAPI.shared.getSpaceStations()
        // Cache the space station array that was set
        SpaceStationAPI.shared.setSpaceStationsCache()
        
        // Set space station images array
        SpaceStationAPI.shared.fetchStationImages()
        for spaceStation in spaceStations {
            stationImages.append(SpaceStationAPI.shared.imageCache[spaceStation.id])
        }
        
        // Update URL for the next clickable page
        SpaceStationAPI.shared.updateWebURL(pageNumber)
        
        print("Creating new page")
        
    }
    
    func fetchPageView() {
        // Reset data
        spaceStations.removeAll()
        stationImages.removeAll()
        
        // Set space station array
        for spaceStationID in SpaceStationAPI.shared.spaceStationsOnPage[pageNumber]! {
            spaceStations.append(SpaceStationAPI.shared.spaceStationCache[spaceStationID]!)
        }
        
        // Set space station images array
        for spaceStationID in SpaceStationAPI.shared.spaceStationsOnPage[pageNumber]! {
            DispatchQueue.main.async {
                self.stationImages.append(SpaceStationAPI.shared.imageCache[spaceStationID]!)
            }
        }
        
        print("Fetching a page")
        
    }
    
    //MARK: - Fetching images (Asynchronously) and setting its cache
//    private func fetchStationImages() {
//        if imageCache[pageNumber] == nil {
//            activity.startAnimating()
//            networkManager.getStationImages(spaceStationsCache[pageNumber] ?? [SpaceStation]()) { [self] (images) in
//                DispatchQueue.main.async {
//                    self.activity.stopAnimating()
//                    imageCache[pageNumber] = images
//                }
//            }
//        }
//
//    }
    //MARK: - Navigating to next page
    @IBAction func nextPage(_ sender: UIButton) {
        
        pageNumber += 1
        SpaceStationAPI.shared.pageNumber = pageNumber
        if SpaceStationAPI.shared.spaceStationsOnPage[pageNumber] == nil {
            createPageView()
        } else {
            fetchPageView()
        }
        
        nextButton.isEnabled = false
        previousButton.isEnabled = true
        
    }
    
    //MARK: - Navigating to previous page
    @IBAction func previousPage(_ sender: UIButton) {
        
        pageNumber -= 1
        SpaceStationAPI.shared.pageNumber = pageNumber
        if SpaceStationAPI.shared.spaceStationsOnPage[pageNumber] == nil {
            createPageView()
        } else {
            fetchPageView()
        }
        
        nextButton.isEnabled = true
        previousButton.isEnabled = false
        
    }

}

//MARK: - CollectionView Delegate Methods & Data Source
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return spaceStations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SpaceStationCell
        
        cell.name.text = spaceStations[indexPath.row].name
        cell.country.text = spaceStations[indexPath.row].owners.first?.name
        cell.image.image = stationImages[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(SpaceStationAPI.shared.spaceStationCache.keys)
        print(SpaceStationAPI.shared.imageCache.keys)
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {

            guard let photo = stationImages[indexPath.row] else {
                return
            }

            vc.image = photo
            vc.name = spaceStations[indexPath.row].name
            vc.owner = spaceStations[indexPath.row].owners.first!.name
            vc.founded = spaceStations[indexPath.row].founded
            vc.status = spaceStations[indexPath.row].status.name
            vc.resultDescription = spaceStations[indexPath.row].resultDescription

            navigationController?.pushViewController(vc, animated: true)

        }
    }
    
    
}



