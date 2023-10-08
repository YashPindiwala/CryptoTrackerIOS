//
//  ViewController.swift
//  CryptoTracker
//
//  Created by yash pindiwala on 2023-09-29.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Property
    var coins = [Coin]()
    
    //MARK: - Outlets
    @IBOutlet var coinListTableView: UITableView!
    
    var coinDataSource: UITableViewDiffableDataSource<CoinDataSource,Coin>!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        coinDataSource = UITableViewDiffableDataSource(tableView: coinListTableView){
            tableView,indexPath,item in
            let newCell = tableView.dequeueReusableCell(withIdentifier: Identifiers.coinListCell.rawValue, for: indexPath) as! CustomCoinTableViewCell
            newCell.coinNameLabel.text = item.name
            newCell.coinSymbolLabel.text = item.symbol
            newCell.coin24ChangeLabel.text = "24Hour Change: \(String(format: "%.2f", item.quote.USD.percent_change_24h))%"
            return newCell
        }
        
        fetchCoinsList()
        let fetchTime = PreviousFetchTime()
        fetchTime.getFetchTime()
        
    }

    //MARK: - Methods
    func createSnapshot(){
        var snapshot = NSDiffableDataSourceSnapshot<CoinDataSource, Coin>()
        snapshot.appendSections([.CoinList])
        snapshot.appendItems(coins)
        snapshot.reloadSections([.CoinList])
        coinDataSource.apply(snapshot)
    }
    
    func fetchCoinsList(){
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
            DispatchQueue.main.async {
                self.createSnapshot()
            }
        }
        coinDataTask.resume()
        let fetchTime = PreviousFetchTime()
        fetchTime.setFetchTime()
    }

}

