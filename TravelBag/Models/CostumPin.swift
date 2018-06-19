//
//  CostumPin.swift
//  TravelBag
//
//  Created by Anika Degreif on 16.06.18.
//  Copyright © 2018 Gruppe04. All rights reserved.
//

import Foundation
import MapKit

class CostumPin: MKAnnotationView {
    
    override var annotation: MKAnnotation? {
        willSet {
            guard let marker = newValue as? Marker else {return}
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            if let imageName = marker.imageName {
                image = UIImage(named: imageName)
            } else {
                image = nil
            }
        }
    }
}
