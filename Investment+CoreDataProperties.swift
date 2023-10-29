//
//  Investment+CoreDataProperties.swift
//  CryptoTracker
//
//  Created by yash pindiwala on 2023-10-29.
//
//

import Foundation
import CoreData


extension Investment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Investment> {
        return NSFetchRequest<Investment>(entityName: "Investment")
    }

    @NSManaged public var price: Double
    @NSManaged public var qnty: Double
    @NSManaged public var coin_Id: Int32
    @NSManaged public var coin: CoinList?

}

extension Investment : Identifiable {

}
