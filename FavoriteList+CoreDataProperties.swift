//
//  FavoriteList+CoreDataProperties.swift
//  CryptoTracker
//
//  Created by yash pindiwala on 2023-10-20.
//
//

import Foundation
import CoreData


extension FavoriteList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteList> {
        return NSFetchRequest<FavoriteList>(entityName: "FavoriteList")
    }

    @NSManaged public var coin_Id: Int32
    @NSManaged public var symbol: String

}

extension FavoriteList : Identifiable {

}
