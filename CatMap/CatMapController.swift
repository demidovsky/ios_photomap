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
        
        mapView.delegate = self
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let nextViewController = segue.destination as? DetailsController,
            let photo = sender as? PhotoInfo
        else { return }
        nextViewController.photoToShow = photo
        
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





extension CatMapController:MKMapViewDelegate
{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        guard
            let photoToShow = annotation as? PhotoInfo
        else
        {
            return nil
        }
        
        
        let id = "photoAnnotationId"
        
        
        var photoView = mapView.dequeueReusableAnnotationView(withIdentifier: id)
        
        if photoView == nil
        {
            photoView = MKPinAnnotationView(annotation: photoToShow, reuseIdentifier: id)
        }
        
        let imageView = UIImageView(frame:CGRect(x: 0, y: 0, width: 50, height: 50))
        imageView.contentMode = .scaleAspectFill
        imageView.showImage(url: photoToShow.smallURL)
        
        photoView?.leftCalloutAccessoryView = imageView
        photoView?.canShowCallout = true
        
        photoView?.annotation = photoToShow
        
        photoView?.rightCalloutAccessoryView = UIButton(type: UIButtonType.detailDisclosure)
        
        return photoView
    }
    
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        guard
            let photo = view.annotation as? PhotoInfo
        else { return }
        
        performSegue(withIdentifier: "showDetails", sender: photo)
    }
}





