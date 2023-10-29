//
//  CoinList+CoreDataProperties.swift
//  CryptoTracker
//
//  Created by yash pindiwala on 2023-10-29.
//
//

import Foundation
import CoreData


extension CoinList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoinList> {
        return NSFetchRequest<CoinList>(entityName: "CoinList")
    }

    @NSManaged public var coin_Id: Int32
    @NSManaged public var desc: String?
    @NSManaged public var name: String
    @NSManaged public var percent_change_24h: Double
    @NSManaged public var symbol: String
    @NSManaged public var price: Double
    @NSManaged public var investment: NSSet?

}

// MARK: Generated accessors for investment
extension CoinList {

    @objc(addInvestmentObject:)
    @NSManaged public func addToInvestment(_ value: Investment)

    @objc(removeInvestmentObject:)
    @NSManaged public func removeFromInvestment(_ value: Investment)

    @objc(addInvestment:)
    @NSManaged public func addToInvestment(_ values: NSSet)

    @objc(removeInvestment:)
    @NSManaged public func removeFromInvestment(_ values: NSSet)

}

extension CoinList : Identifiable {

}
