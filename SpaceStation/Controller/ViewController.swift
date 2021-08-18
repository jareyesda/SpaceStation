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
    
    // Data source for my CollectionView
    var spaceStations = [SpaceStation]()
        
    // Dictionary that handles the caching. Int conforms to the page number
    var spaceStationsCache = [Int: [SpaceStation]]()
    
    var imageCache = [Int:[Int: UIImage]?]() {
        didSet{
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
        
        spaceStationsCache[pageNumber] = SpaceStationAPI.shared.getSpaceStations()
        spaceStations = spaceStationsCache[pageNumber] ?? [SpaceStation]()
        
        SpaceStationAPI.shared.updateWebURL(pageNumber) { url in
            return
        }
        
        fetchStationImages()
        
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
    
    func setPageView() {
        // reset data
        spaceStations.removeAll()
        
        setSpaceStationCache()
        
        // Populate my spaceStations array via the cache.
        spaceStations = spaceStationsCache[pageNumber] ?? [SpaceStation]()
        
        // Fetch and cache images
        fetchStationImages()
        
    }
    
    //MARK: - Setting cache for Space Station data
    private func setSpaceStationCache() {
        spaceStationsCache[pageNumber] = SpaceStationAPI.shared.getSpaceStations()
    }
    
    //MARK: - Fetching images (Asynchronously) and setting its cache
    private func fetchStationImages() {
        if imageCache[pageNumber] == nil {
            activity.startAnimating()
            networkManager.getStationImages(spaceStationsCache[pageNumber] ?? [SpaceStation]()) { [self] (images) in
                DispatchQueue.main.async {
                    self.activity.stopAnimating()
                    imageCache[pageNumber] = images
                }
            }
        }
        
    }
    //MARK: - Navigating to next page
    @IBAction func nextPage(_ sender: UIButton) {
        
        pageNumber += 1
        if spaceStationsCache[pageNumber] == nil {
            setPageView()
        } else {
            spaceStations = spaceStationsCache[pageNumber]!
        }
        
        nextButton.isEnabled = false
        previousButton.isEnabled = true
        
    }
    
    //MARK: - Navigating to previous page
    @IBAction func previousPage(_ sender: UIButton) {
        
        pageNumber -= 1
        if spaceStationsCache[pageNumber] == nil {
            setPageView()
        } else {
            spaceStations = spaceStationsCache[pageNumber]!
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
        cell.image.image = imageCache[pageNumber]??[spaceStations[indexPath.row].id]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {

            guard let photo = imageCache[pageNumber]??[spaceStations[indexPath.row].id] else {
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



