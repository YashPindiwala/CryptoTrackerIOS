//
//  DetailViewController.swift
//  CryptoTracker
//
//  Created by yash pindiwala on 2023-10-13.
//

import UIKit

class DetailViewController: UIViewController {
    
    var passedCoin: CoinList!

    @IBOutlet var coinImageView: UIImageView!
    @IBOutlet var coinDescriptionTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = passedCoin.name
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: nil, action: nil)
        fetchImage(coinId: Int(passedCoin.coin_Id))
        fetchCoinsDescription()
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
