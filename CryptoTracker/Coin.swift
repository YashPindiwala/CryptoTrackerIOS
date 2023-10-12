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
    var id: Int
    var quote: Usd
}
struct Usd: Codable, Hashable{
    var USD: Change
}
struct Change: Codable, Hashable{
    var percent_change_24h: Double
}
