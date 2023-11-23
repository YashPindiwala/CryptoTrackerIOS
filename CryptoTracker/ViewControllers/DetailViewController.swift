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
        if !isAlreadyFavorite(coin_id: passedCoin.coin_Id){ // check if the coin is not favorited
            addToFavorite(coin_id: passedCoin.coin_Id, symbol: passedCoin.symbol) // adding the coin to favorite
            favoriteButton.image = UIImage(systemName: "heart.fill") // and setting the image to filled heart
        } else { // when the coin already favorited
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
        
        // checking if the coin is favorited or not and setting the image according to ti
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
    func showDialog(){
        let confirmationView = CustomDialogConfirmation()
        confirmationView.frame = view.bounds
        confirmationView.isOpaque = false
        
        view.addSubview(confirmationView)
        view.isUserInteractionEnabled = false
        confirmationView.showDialog()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
            confirmationView.removeFromSuperview()
        })
    }
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
                    self.modifyCoin(for: self.passedCoin.coin_Id, with: jsonString.description) // modifying data for particular coin
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
        var fullURL = API.coinImage128.rawValue // url for getting image
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
        print("This is the symbol: \(symbol)")
        favoriteCoin.symbol = symbol
        coreDataStack.saveContext()
        showDialog()
    }
    
    // this method will return [true] if the coin is favorited and [false] if not
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
    
    // this method will return [true] if the description for the coin is available in CoreData and [false] if not
    func checkIfDescAvailable(for id: Int32) -> Bool{
        let fetchRequest : NSFetchRequest<CoinList> = CoinList.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "coin_Id == %i", id)
        do{
            let request = try coreDataStack.managedContext.fetch(fetchRequest)
            if let coinToCheck = request.first{
                if coinToCheck.desc != nil{
                    return true
                }
            }
        }catch{
            print("There was an error getting the object: \(error.localizedDescription)")
        }
        return false
    }
    // this method will be called if description is already available for the coin in CoreData
    func fetchCoinDescriptionAndDisplay(for id: Int32){
        let fetchRequest : NSFetchRequest<CoinList> = CoinList.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "coin_Id == %i", id) // searching parameter for the selected coin
        do{
            let request = try coreDataStack.managedContext.fetch(fetchRequest)
            if let coinDesc = request.first{ // get the first coin
                DispatchQueue.main.async {
                    self.coinDescriptionTextView.text = coinDesc.desc // set the description to the textview
                }
            }
        }catch{
            print("There was an error getting the object: \(error.localizedDescription)")
        }
    }
    
    func modifyCoin(for id: Int32, with description: String){
        let fetchRequest : NSFetchRequest<CoinList> = CoinList.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "coin_Id == %i", id) // searching the coin with particular ID
        do{
            let request = try coreDataStack.managedContext.fetch(fetchRequest)
            if let coinToUpdate = request.first{
                coinToUpdate.desc = description // updating the description for the selected coin
            }
            coreDataStack.saveContext() // saving the modified description
        }catch{
            print("There was an error getting the object: \(error.localizedDescription)")
        }
    }
}
