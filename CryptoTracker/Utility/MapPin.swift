//
//  MapPin.swift
//  CryptoTracker
//
//  Created by yash pindiwala on 2023-10-19.
//

import Foundation
import MapKit

class MapPin: NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String?, city: String?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = city
    }
}
