//
//  SetFetchTime.swift
//  CryptoTracker
//
//  Created by yash pindiwala on 2023-10-06.
//

import Foundation
struct PreviousFetchTime{
    let previousFetch = "PreviousFetchDate"
    let initialLaunch = "InitialLaunch"
    let timeUserDefault = UserDefaults.standard
    
    func setFetchTime(){
        timeUserDefault.setValue(Date(), forKey: previousFetch)
        timeUserDefault.synchronize()
    }
    private func getFetchTime() -> Date{
        guard let storedDate = timeUserDefault.object(forKey: previousFetch) as? Date else { return Date()}
        return storedDate
            // Use storedDate as the previous fetched date
    }
    func isBeforeOrEqual20Minutes() -> Bool{
        let calendar = Calendar.current
        var status = false
        // Create a time 20 minutes ago from the current time
        if let twentyMinutesAgo = calendar.date(byAdding: .minute, value: -20, to: Date()) {
            let dateToCheck = getFetchTime() // The date you to compare

            if dateToCheck.compare(twentyMinutesAgo) == .orderedAscending {
                print("true 20 min or more before")
                status = true
            } else {
                print("false not before 20 min")
                status = false
            }
        }
        if !isAppAlreadyLaunchedOnce(){
            return true
        }
        return status
    }
    private func isAppAlreadyLaunchedOnce()->Bool{
        if timeUserDefault.string(forKey: initialLaunch) != nil{
                return true
            }else{
                timeUserDefault.set(true, forKey: initialLaunch)
                return false
            }
        }
}

