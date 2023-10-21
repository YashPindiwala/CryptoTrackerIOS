//
//  DetailViewController.swift
//  CryptoTracker
//
//  Created by yash pindiwala on 2023-10-13.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {
    
    //MARK: - Property
    var passedCoin: CoinList!
    var coreDataStack: CoreDataStack!
    
    //MARK: - Outlets
    @IBOutlet var coinImageView: UIImageView!
    @IBOutlet var coinDescriptionTextView: UITextView!
    @IBOutlet var favoriteButton: UIBarButtonItem!
    
    //MARK: - Actions
    @IBAction func favoriteButtonAction(_ sender: UIBarButtonItem) {
        if !isAlreadyFavorite(coin_id: passedCoin.coin_Id){
            addToFavorite(coin_id: passedCoin.coin_Id, symbol: passedCoin.description)
            favoriteButton.image = UIImage(systemName: "heart.fill")
        } else {
            let ac = UIAlertController(title: "Already Favorited!", message: "\(passedCoin.name) is already in favorites.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel))
            present(ac, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        guard let passedCoin = passedCoin else {return}
        navigationItem.title = passedCoin.name
        
        if isAlreadyFavorite(coin_id: passedCoin.coin_Id){
            favoriteButton.image = UIImage(systemName: "heart.fill")
        } else {
            favoriteButton.image = UIImage(systemName: "heart")
        }
        
        fetchImage(coinId: Int(passedCoin.coin_Id))
        
        if checkIfDescAvailable(for: passedCoin.coin_Id){
            // if coin description is available then get data from Core Data
            fetchCoinDescriptionAndDisplay(for: passedCoin.coin_Id) // from Core Data
        } else {
            // if coin description is no available then get data from API
            fetchCoinsDescription() // from API and then after loading it from Core Data
        }
    }
    
    //MARK: - Methods
    func fetchCoinsDescription(){
        var urlString = API.coinDescription.rawValue
        urlString = urlString.appending("\(Int32(passedCoin.coin_Id))")
        guard let url = URL(string: urlString) else {return}
        var coinDescriptionReq = URLRequest(url: url)
        coinDescriptionReq.setValue(API.key.rawValue, forHTTPHeaderField: API.httpHeader.rawValue)
        let coinDescriptionTask = URLSession.shared.dataTask(with: coinDescriptionReq){
            data, response, error in
            
            if error != nil{
                print("There was an error")
            } else {
                do{
                    guard let data = data else {return}
                    
                    let cryptoResponse = try JSONDecoder().decode(CryptoResponse.self, from: data)
                    guard let jsonString = cryptoResponse.data["\(self.passedCoin.coin_Id)"] else {return}
                    self.modifyCoin(for: self.passedCoin.coin_Id, with: jsonString.description) // modifying data for particu;ar coin
                    self.fetchCoinDescriptionAndDisplay(for: self.passedCoin.coin_Id) // getting the coin description and displaying in the textview
                } catch DecodingError.valueNotFound(let error, let message){
                    print("Value is missing: \(error) \(message.debugDescription)")
                } catch DecodingError.typeMismatch(let error, let message){
                    print("Types do not match: \(error) \(message.debugDescription)")
                } catch DecodingError.keyNotFound(let error, let message){
                    print("Incorrect property name: \(error) \(message.debugDescription)")
                } catch {
                    print("Unknown error has occurred \(error.localizedDescription)")
                }
            }
        }
        coinDescriptionTask.resume()
    }
    
    func fetchImage(coinId: Int){
        var fullURL = "https://s2.coinmarketcap.com/static/img/coins/128x128/" // url for getting image
        fullURL.append("\(coinId).png") // appending the name of the image to get image location on internet
        guard let imagePath = URL(string: fullURL) else {return}
        let imageTask = URLSession.shared.downloadTask(with: imagePath){
            url,response,error in
            
            if error == nil, let url = url, let data = try?Data(contentsOf: url), let image = UIImage(data: data){
                // if there is no error, there is data, the data can be converted to UIImage object then set image for the image view for the cell which is passed.
                DispatchQueue.main.sync { // the main thread should be used to update UI changes
                    self.coinImageView.image = image
                }
            } else {
                // if there is no Image then set the image to Noimage asset
                DispatchQueue.main.sync {
                    self.coinImageView.image = UIImage(named: "noImage")
                }
            }
        }
        imageTask.resume()// resuming the imageTask, as it is by default in postponed state.
    }
    
    //MARK: - Methods related to CoreData
    
    func addToFavorite(coin_id id: Int32, symbol: String){
        let favoriteCoin = FavoriteList(context: coreDataStack.managedContext)
        favoriteCoin.coin_Id = id
        favoriteCoin.symbol = symbol
        coreDataStack.saveContext()
    }
    
    func isAlreadyFavorite(coin_id id: Int32) -> Bool{
        let fetchRequest: NSFetchRequest<FavoriteList> = FavoriteList.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "coin_Id == %i", id)
        do{
            let request = try coreDataStack.managedContext.fetch(fetchRequest)
            if request.first != nil{
                return true
            }
        }catch{
            print("There was an error fetching: \(error.localizedDescription)")
        }
        return false
    }
    
    func checkIfDescAvailable(for id: Int32) -> Bool{
        let fetchRequest : NSFetchRequest<CoinList> = CoinList.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "coin_Id == %i", id)
        do{
            let request = try coreDataStack.managedContext.fetch(fetchRequest)
            if let coinToCheck = request.first{
                if coinToCheck.desc != nil{
                    return true
                }else{
                    return false
                }
            }
        }catch{
            print("There was an error getting the object: \(error.localizedDescription)")
        }
        return false
    }
    
    func fetchCoinDescriptionAndDisplay(for id: Int32){
        let fetchRequest : NSFetchRequest<CoinList> = CoinList.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "coin_Id == %i", id)
        do{
            let request = try coreDataStack.managedContext.fetch(fetchRequest)
            if let coinDesc = request.first{
                DispatchQueue.main.async {
                    self.coinDescriptionTextView.text = coinDesc.desc
                }
            }
        }catch{
            print("There was an error getting the object: \(error.localizedDescription)")
        }
    }
    
    func modifyCoin(for id: Int32, with description: String){
        let fetchRequest : NSFetchRequest<CoinList> = CoinList.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "coin_Id == %i", id)
        do{
            let request = try coreDataStack.managedContext.fetch(fetchRequest)
            if let coinToUpdate = request.first{
                coinToUpdate.desc = description
            }
            coreDataStack.saveContext()
        }catch{
            print("There was an error getting the object: \(error.localizedDescription)")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
