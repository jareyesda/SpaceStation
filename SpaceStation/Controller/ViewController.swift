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
    
    var spaceStations = [SpaceStationModel]()
    var spaceStationData: SpaceStations?
    var spaceStationsCache = [Int: SpaceStations]() {
        didSet {
            collectionView.reloadData()
        }
    }
        
    var imageCache = [Int:[Int: UIImage]]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var pageNumber: Int = 1 {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var webURL = "https://ll.thespacedevs.com/2.2.0/spacestation/?format=json&limit=10"
            
    //MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setPageView(webURL)
        fetchStationImages()
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
        layout.minimumInteritemSpacing = 10
    }
    
    func setPageView(_ urlString: String) {
        // reset data
        spaceStations.removeAll()
        spaceStationData = nil
        
        setSpaceStationArrayAndCache(url: urlString)
        
    }
    
    //MARK: - Network call for Space Station Data
    private func setSpaceStationArrayAndCache(url: String) {
        networkManager.fetchSpaceStations(url) { [self] result in
            guard let results = result?.results else {
                return
            }
            for result in results {
                spaceStations.append(
                    SpaceStationModel(
                        id: result.id,
                        name: result.name,
                        status: result.status,
                        type: result.type,
                        founded: result.founded,
                        deorbited: result.deorbited,
                        resultDescription: result.resultDescription,
                        orbit: result.orbit,
                        owners: result.owners,
                        imageURL: result.imageURL)
                )
            }

            spaceStationsCache[pageNumber] = result
            spaceStationData = result
            if pageNumber == 1 {
                webURL = (spaceStationData?.next)!

            } else if pageNumber == 2 {
                webURL = (spaceStationData?.previous)!
            }

        }
    }
    
    //MARK: - Fetching images (Asynchronously)
    private func fetchStationImages() {
        if imageCache[pageNumber] == nil {
            networkManager.getStationImages(spaceStations) { [self] (images) in
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
        setPageView(webURL)
        
    }
    
    @IBAction func previousPage(_ sender: UIButton) {
        pageNumber -= 1
        setPageView(webURL)
    }
    
    
}

//MARK: - CollectionView Delegate Methods & Data Source
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return spaceStations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SpaceStationCell
        
        cell.name.text = spaceStationsCache[pageNumber]?.results[indexPath.row].name
        cell.country.text = spaceStationsCache[pageNumber]?.results[indexPath.row].owners.first?.name
        cell.image.image = imageCache[pageNumber]?[spaceStations[indexPath.row].id]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(webURL)
    }
    
    
}



