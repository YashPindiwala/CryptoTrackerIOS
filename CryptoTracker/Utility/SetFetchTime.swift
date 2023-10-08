//
//  SetFetchTime.swift
//  CryptoTracker
//
//  Created by yash pindiwala on 2023-10-06.
//

import Foundation
struct PreviousFetchTime{
    let previousFetch = "PreviousFetchDate"
    let timeUserDefault = UserDefaults.standard
    let previousFetchDate = Date()
    
    func setFetchTime(){
        timeUserDefault.setValue(previousFetchDate, forKey: previousFetch)
        timeUserDefault.synchronize()
    }
    func getFetchTime(){
        if let storedDate = timeUserDefault.object(forKey: previousFetch) as? Date {
            // Use storedDate as the previous fetched date
            print("Stored date: \(storedDate)")
        }
    }
}
