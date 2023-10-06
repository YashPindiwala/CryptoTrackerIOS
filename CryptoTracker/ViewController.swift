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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fetchCoinsList()
        let fetchTime = PreviousFetchTime()
        fetchTime.getFetchTime()
    }

    //MARK: - Methods
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
        }
        coinDataTask.resume()
        let fetchTime = PreviousFetchTime()
        fetchTime.setFetchTime()
    }

}

