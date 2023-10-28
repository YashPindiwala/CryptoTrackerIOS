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
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressHappened))
        favoriteCollectionView.addGestureRecognizer(recognizer)

        favoriteDataSource = UICollectionViewDiffableDataSource(collectionView: favoriteCollectionView){
            collectionView,indexPath,item in
            let newCell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.favoriteCell.rawValue, for: indexPath) as! FavoriteListCollectionViewCell
            self.fetchImage(coinId: item.coin_Id, cell: newCell)
            newCell.coinSymbolLabel.text = item.symbol
            return newCell
        }
        favoriteCollectionView.delegate = self
        fetchFavoriteList()
    }
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        fetchFavoriteList()
//    }
    
    @objc func longPressHappened(gesture : UILongPressGestureRecognizer!){
        
        let tapLocation = gesture.location(in: self.favoriteCollectionView)
        guard let indexPath = self.favoriteCollectionView.indexPathForItem(at: tapLocation) else {return}
        guard let favoriteCoinToDelete = self.favoriteDataSource.itemIdentifier(for: indexPath) else {return}
        
        if gesture.state == .began{
            let ac = UIAlertController(title: "Action!", message: "Are you sure you want to delete?", preferredStyle: .actionSheet)
            ac.addAction(UIAlertAction(title: "Delete", style: .destructive){
                _ in
                self.deleteFavoriteCoin(item: favoriteCoinToDelete)
            })
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            ac.popoverPresentationController?.sourceView = favoriteCollectionView.cellForItem(at: indexPath)
            present(ac, animated: true)
        }
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
        print("Fetch called")
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
    
    func deleteFavoriteCoin(item: FavoriteList){
        coreDataStack.managedContext.delete(item)
        coreDataStack.saveContext()
        fetchFavoriteList()
    }
    

}
extension FavoriteViewController: UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if self.view.frame.size.width <= 400 {
            let phoneWidth = view.safeAreaLayoutGuide.layoutFrame.width
            let cellsInRow: CGFloat = 2.0
            let totalSpacing:CGFloat = cellsInRow * 10 * 2
            let itemWidth = (phoneWidth - totalSpacing) / cellsInRow
            if itemWidth < 0  {
                    return CGSize(width: 0, height: 0) // Replace with a valid minimum size
                }
            return CGSize(width: itemWidth, height: itemWidth/2)
        }else{
            let phoneWidth = view.safeAreaLayoutGuide.layoutFrame.width
            let cellsInRow: CGFloat = 4.0
            let totalSpacing:CGFloat = cellsInRow * 10 * 2
            let itemWidth = (phoneWidth - totalSpacing) / cellsInRow
            if itemWidth < 0  {
                    return CGSize(width: 0, height: 0) // Replace with a valid minimum size
                }
            return CGSize(width: itemWidth, height: itemWidth/2)
        }
    }
}
