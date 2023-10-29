//
//  API.swift
//  CryptoTracker
//
//  Created by yash pindiwala on 2023-10-06.
//

import Foundation
enum API: String{
    case key = "669ab313-c575-4483-8bb1-16f1a4cc1410"
    case httpHeader = "X-CMC_PRO_API_KEY"
    case coinList = "https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest"
    case coinDescription = "https://pro-api.coinmarketcap.com/v2/cryptocurrency/info?id="
    case coinImage128 = "https://s2.coinmarketcap.com/static/img/coins/128x128/"
}
enum CoinDataSource{
    case coinList
}
enum FavoriteSection{
    case favorite
}
enum InvestmentSection{
    case investment
}
enum Identifiers: String{
    case coinListCell = "coinListItem"
    case favoriteCell = "favoriteCell"
    case investmentCell = "investmentCell"
}
