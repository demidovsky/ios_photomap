//
//  CatMapController.swift
//  CatMap
//
//  Created by Митрошка on 26.02.17.
//  Copyright © 2017 dimmy.pro. All rights reserved.
//

import UIKit
import MapKit

class CatMapController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    var photos = [PhotoInfo]()
    {
        didSet { updateMap() }
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        testRequest()

    }

        
    func updateMap()
    {
        clearMap()
        self.mapView.addAnnotations(photos)
    }
    
    func clearMap()
    {
        self.mapView.removeAnnotations(mapView.annotations)
    }

    func testRequest()
    {
        let service = APIService()
        service.find(tag: "cat", success: { photos in
            print("CAT MAP SUCCESS: ", photos)
            
            // т.к. получение данных из сети выполняется в фоне,
            // то и замыкание, в котором находится этот текст, срабатывает там же.
            // обращаться из фона в UI негоже,
            // поэтому переключаемся в основной поток
            DispatchQueue.main.async
            {
                self.photos = photos
            }
            
        }) { error in
            print("CAT MAP ERROR: ", error)
        }
    }

}
