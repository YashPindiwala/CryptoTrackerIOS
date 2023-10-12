//
//  CoinList+CoreDataProperties.swift
//  CryptoTracker
//
//  Created by yash pindiwala on 2023-10-11.
//
//

import Foundation
import CoreData


extension CoinList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoinList> {
        return NSFetchRequest<CoinList>(entityName: "CoinList")
    }

    @NSManaged public var coin_Id: Int32
    @NSManaged public var desc: String
    @NSManaged public var image: String
    @NSManaged public var name: String
    @NSManaged public var percent_change_24h: Double
    @NSManaged public var symbol: String

}

extension CoinList : Identifiable {

}
