//
//  SetFetchTime.swift
//  CryptoTracker
//
//  Created by yash pindiwala on 2023-10-06.
//

import Foundation
struct PreviousFetchTime{
    let previousFetch = "PreviousFetchDate" // key
    let initialLaunch = "InitialLaunch"
    let timeUserDefault = UserDefaults.standard
    
    // Save current time to the UserDefaults
    func setFetchTime(){
        timeUserDefault.setValue(Date(), forKey: previousFetch)
        timeUserDefault.synchronize()
    }
    // Retrieve the time from UserDefaults
    private func getFetchTime() -> Date{
        guard let storedDate = timeUserDefault.object(forKey: previousFetch) as? Date else { return Date()}
        return storedDate // Use storedDate as the previous fetched date
    }

    func isBeforeOrEqual20Minutes() -> Bool{
        let calendar = Calendar.current
        var status = false
        // Create a time 20 minutes ago from the current time
        if let twentyMinutesAgo = calendar.date(byAdding: .minute, value: -20, to: Date()) {
            let dateToCheck = getFetchTime() // The date you to compare

            if dateToCheck.compare(twentyMinutesAgo) == .orderedAscending { // last update was before 20 min
                status = true
            } else { // last update was within past 20 min
                status = false
            }
        }
        
        // if the app is launching for the first time just return true so the caller of this method can fetch coins from the API
        if !isAppAlreadyLaunchedOnce(){
            return true // this will fake the caller of the method that the 20 minutes has passed
        }
        return status
    }
    public func isAppAlreadyLaunchedOnce()->Bool{
        if timeUserDefault.string(forKey: initialLaunch) != nil{
                return true // not first launch of the app
            }else{
                timeUserDefault.set(true, forKey: initialLaunch)
                return false // definitely the first launch of app
            }
        }
}
