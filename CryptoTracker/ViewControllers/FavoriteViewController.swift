//
//  FavoriteViewController.swift
//  CryptoTracker
//
//  Created by yash pindiwala on 2023-10-21.
//

import UIKit
import CoreData

class FavoriteViewController: UIViewController {
    
    //MARK: - Property
    var coreDataStack: CoreDataStack!
    var favoriteList = [FavoriteList]()
    var favoriteDataSource: UICollectionViewDiffableDataSource<FavoriteSection,FavoriteList>!
    
    //MARK: - Outlets
    @IBOutlet var favoriteCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        favoriteDataSource = UICollectionViewDiffableDataSource(collectionView: favoriteCollectionView){
            collectionView,indexPath,item in
            let newCell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.favoriteCell.rawValue, for: indexPath) as! FavoriteListCollectionViewCell
            self.fetchImage(coinId: item.coin_Id, cell: newCell)
            newCell.coinSymbolLabel.text = item.symbol
            return newCell
        }
        fetchFavoriteList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFavoriteList()
    }
    
    //MARK: - Methods
    func createSnapshot(){
        var snapshot = NSDiffableDataSourceSnapshot<FavoriteSection,FavoriteList>()
        snapshot.appendSections([.favorite])
        snapshot.appendItems(favoriteList)
        snapshot.reloadItems(favoriteList)
        favoriteDataSource.apply(snapshot)
    }
    
    func fetchFavoriteList(){
        let fetchRequest: NSFetchRequest<FavoriteList> = FavoriteList.fetchRequest()
        do{
            favoriteList = try coreDataStack.managedContext.fetch(fetchRequest)
            createSnapshot()
        }catch{
            print("There was an error fetching: \(error.localizedDescription)")
        }
    }
    
    func fetchImage(coinId: Int32, cell: FavoriteListCollectionViewCell){
        var fullURL = API.coinImage128.rawValue // url for getting image
        fullURL.append("\(coinId).png") // appending the name of the image to get image location on internet
        guard let imagePath = URL(string: fullURL) else {return}
        let imageTask = URLSession.shared.downloadTask(with: imagePath){
            url,response,error in
            
            if error == nil, let url = url, let data = try?Data(contentsOf: url), let image = UIImage(data: data){
                // if there is no error, there is data, the data can be converted to UIImage object then set image for the image view for the cell which is passed.
                DispatchQueue.main.sync { // the main thread should be used to update UI changes
                    cell.coinImageView.image = image
                }
            } else {
                // if there is no Image then set the image to Noimage asset
                DispatchQueue.main.sync {
                    cell.coinImageView.image = UIImage(named: "noImage")
                }
            }
        }
        imageTask.resume()// resuming the imageTask, as it is by default in postponed state.
    }
    

}
