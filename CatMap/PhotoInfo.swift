//
//  PhotoInfo.swift
//  CatMap
//
//  Created by Митрошка on 26.02.17.
//  Copyright © 2017 dimmy.pro. All rights reserved.
//

import Foundation
import MapKit

class PhotoInfo:NSObject, MKAnnotation
{
    var lat:Double
    var lon:Double
    var title:String?
    var smallURL:String
    var largeURL:String
    
    // MKAnnotation
    var coordinate: CLLocationCoordinate2D
    {
        return CLLocationCoordinate2D(latitude: self.lat, longitude: self.lon)
    }
    
    init?(json:[String:Any])
    {
        guard
            let lat = json["latitude"] as? String,
            let lon = json["longitude"] as? String,
            let title = json["title"] as? String,
            let smallURL = json["url_s"] as? String,
            let largeURL = json["url_l"] as? String
        else
        {
            return nil
        }
        
        self.lat = Double(lat)!
        self.lon = Double(lon)!
        self.title = title
        self.smallURL = smallURL
        self.largeURL = largeURL
    }
}
