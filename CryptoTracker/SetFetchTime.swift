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
        print("Time Set")
    }
    func getFetchTime(){
        print("Time get")
        if let storedDate = timeUserDefault.object(forKey: previousFetch) as? Date {
            // Use storedDate as the current date
            print("Stored date: \(storedDate)")
        }
    }
}
