//
//  Coin.swift
//  CryptoTracker
//
//  Created by yash pindiwala on 2023-10-06.
//

import Foundation
struct CoinListing: Codable, Hashable{
    var data: [Coin]
}
struct Coin: Codable, Hashable{
    var name: String
    var symbol: String
}
