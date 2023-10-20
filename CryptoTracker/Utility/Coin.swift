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

struct CryptoData: Codable {
    let id: Int
    let name: String
    let symbol: String
    let category: String
    let description: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case symbol
        case category
        case description
    }
}

struct CryptoResponse: Codable {
    let data: [String: CryptoData]
}



