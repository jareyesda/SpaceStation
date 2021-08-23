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
    
//    var stationImages = [UIImage]() {
//        didSet {
//            collectionView.reloadData()
//        }
//    }
    
    var stationImages = [Int : UIImage]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var pageNumber: Int = 0 {
        didSet {
            collectionView.reloadData()
        }
    }
    
                    
    //MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        updatePage()
        updateImages(spaceStations: spaceStations)
        
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
    
    
    func updatePage() {
        SpaceStationAPI.shared.getSpaceStations(page: pageNumber, completion: { (result) in
            switch result {
            
            case .success(let spaceStations):
                DispatchQueue.main.async {
                    self.spaceStations = spaceStations
                    self.updateImages(spaceStations: self.spaceStations)
                }
                
            case .failure(let error):
                print(error)
            }
        })
        

    }
    
    func updateImages(spaceStations: [SpaceStation]) {
        SpaceStationAPI.shared.getStationImages(spaceStations: spaceStations) { imageDict in
            DispatchQueue.main.async {
                print("current space station array is: \(self.spaceStations)")
                print("current images are: \(self.stationImages)")
                self.stationImages = imageDict
            }
        }
    }

    //MARK: - Navigating to next page
    @IBAction func nextPage(_ sender: UIButton) {
        
        pageNumber += 1
        SpaceStationAPI.shared.pageNumber = pageNumber
        updatePage()
        
        nextButton.isEnabled = false
        previousButton.isEnabled = true
        
    }
    
    //MARK: - Navigating to previous page
    @IBAction func previousPage(_ sender: UIButton) {
        
        pageNumber -= 1
        SpaceStationAPI.shared.pageNumber = pageNumber
        updatePage()
        
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
        
        let spaceStation = spaceStations[indexPath.row]
        
        cell.name.text = spaceStation.name
        cell.country.text = spaceStation.owners.first?.name
        cell.image.image = stationImages[spaceStation.id]
        
        return cell
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(stationImages)
//        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
//
//            guard let photo = stationImages[indexPath.row] else {
//                return
//            }
//
//            vc.image = photo
//            vc.name = spaceStations[indexPath.row].name
//            vc.owner = spaceStations[indexPath.row].owners.first!.name
//            vc.founded = spaceStations[indexPath.row].founded
//            vc.status = spaceStations[indexPath.row].status.name
//            vc.resultDescription = spaceStations[indexPath.row].resultDescription
//
//            navigationController?.pushViewController(vc, animated: true)
//
//        }
    }
    
    
}
