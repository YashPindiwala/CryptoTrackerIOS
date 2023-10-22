//
//  ViewController.swift
//  CryptoTracker
//
//  Created by yash pindiwala on 2023-09-29.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    //MARK: - Property
    var coins = [Coin]()
    var coinsListArray = [CoinList]()
    var coreDataStack: CoreDataStack!
    var fetchTime: PreviousFetchTime!
    let refreshControl = UIRefreshControl()
    var coinDataSource: UITableViewDiffableDataSource<CoinDataSource,CoinList>!
    
    //MARK: - Outlets
    @IBOutlet var coinListTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        coinListTableView.addSubview(refreshControl)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        fetchTime = PreviousFetchTime()
        
        coinDataSource = UITableViewDiffableDataSource(tableView: coinListTableView){
            tableView,indexPath,item in
            let newCell = tableView.dequeueReusableCell(withIdentifier: Identifiers.coinListCell.rawValue, for: indexPath) as! CustomCoinTableViewCell
            newCell.coinNameLabel.text = item.name
            newCell.coinSymbolLabel.text = item.symbol
            newCell.coin24ChangeLabel.text = "24Hour Change: \(String(format: "%.2f", item.percent_change_24h))%"
            self.fetchImage(coinId: Int(item.coin_Id), cell: newCell)
            return newCell
        }
        
        if fetchTime.isAppAlreadyLaunchedOnce(){ // {true} if app launched previously else {false}
            fetchCoinsFromCoreData() // if it's not first launch then load data from Core Data
        }else{
            fetchCoinsList() // on first launch of app load data from API
        }
    }


    //MARK: - Methods
    
    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
        if fetchTime.isBeforeOrEqual20Minutes(){
            fetchCoinsList()
        } else {
            fetchCoinsFromCoreData()
        }
    }
    
    func createSnapshot(){
        var snapshot = NSDiffableDataSourceSnapshot<CoinDataSource, CoinList>()
        snapshot.appendSections([.coinList])
        snapshot.appendItems(coinsListArray)
        snapshot.reloadItems(coinsListArray)
        coinDataSource.apply(snapshot)
    }
    
    func fetchCoinsList(){
        print("Fetch from API")
        guard let url = URL(string: API.coinList.rawValue) else {return}
        var coinDataRequest = URLRequest(url: url)
        coinDataRequest.setValue(API.key.rawValue, forHTTPHeaderField: API.httpHeader.rawValue)
        let coinDataTask = URLSession.shared.dataTask(with: coinDataRequest){
            data, response, error in
            
            if error != nil{
                print("There was an error")
            } else {
                do{
                    guard let data = data else {return}
                    let jsonDecoder = JSONDecoder()
                    let resultCoins = try jsonDecoder.decode(CoinListing.self, from: data)
                    self.coins = resultCoins.data
                    for coin in self.coins{
                        let insertCoin = CoinList(context: self.coreDataStack.managedContext)
                        insertCoin.coin_Id = Int32(coin.id)
                        insertCoin.name = coin.name
                        insertCoin.symbol = coin.symbol
                        insertCoin.percent_change_24h = coin.quote.USD.percent_change_24h
                    }
                    self.coreDataStack.saveContext()
                    self.fetchCoinsFromCoreData()
                    self.fetchTime.setFetchTime()
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
        coinDataTask.resume()
    }
    
    func fetchCoinsFromCoreData(){
        print("Fetch from CoreData")
        let fetchRequest: NSFetchRequest<CoinList> = CoinList.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            coinsListArray = try coreDataStack.managedContext.fetch(fetchRequest)
            self.createSnapshot()
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        } catch {
            print("There was an error trying to fetch the lists - \(error.localizedDescription)")
        }
        
    }
    
    func fetchImage(coinId: Int, cell: CustomCoinTableViewCell){
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? DetailViewController else { return }
        guard let index = coinListTableView.indexPathForSelectedRow, let itemToPass = coinDataSource.itemIdentifier(for: index) else { return }
        vc.passedCoin = itemToPass
        vc.coreDataStack = coreDataStack
    }
}

