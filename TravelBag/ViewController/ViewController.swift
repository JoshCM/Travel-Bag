//
//  ViewController.swift
//  TravelBag
//
//  Created by Anonymer Eintrag on 30.05.18.
//  Copyright © 2018 Gruppe04. All rights reserved.
//

import UIKit
import MapKit


class ViewController: UIViewController {

    @IBOutlet weak var panView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    let initialZoom:CLLocationDistance! = 1000000
    var regionRadius :CLLocationDistance?
    let initLoc = CLLocation(latitude: 50.095845, longitude:8.218644)
    var actLoc : CLLocation!
    var actCountry: String?
    var actCity: String?
    
    func centerMaponLocation(location:CLLocation){
        let coordRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius!, regionRadius!)
        mapView.setRegion(coordRegion, animated: true)
    }
    
    @IBAction func searchButton(_ sender: Any) {
        let goec = CLGeocoder()
        goec.geocodeAddressString(searchField.text!, completionHandler: {(placemarks,error)->Void in
            
            var location:CLLocation?
            
            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
                self.actCountry = placemarks.first?.country
                self.actCity = placemarks.first?.locality
                self.addButton.isEnabled = true
            }
            
            if let location = location {
                self.actLoc = location
                self.regionRadius! /= 10
                self.centerMaponLocation(location: location)
                self.regionRadius! *= 10
            } else {
                print("No Matching Location Found")
            }
        })
    }
    
    
    @IBAction func didUnwindFromEntry(_ sender: UIStoryboardSegue){
            let origin = sender.source as! EntryViewController
            
            let marker = Marker(locationName: origin.city, coordinate: CLLocationCoordinate2D(latitude: origin.latitude, longitude: origin.longitude))
            mapView.addAnnotation(marker)
    }
    
    @IBAction func didUnwindFromTable(_ sender: UIStoryboardSegue){
        
    }
    
    
    @IBAction func tableSegue(_ sender: UIPanGestureRecognizer) {
        let state = sender.state
        if state == UIGestureRecognizerState.began{
            performSegue(withIdentifier: "cityTable", sender: nil)
        }
    }
    
    @IBAction func addEntryButton(_ sender: Any) {
        performSegue(withIdentifier: "addEntry", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is EntryViewController
        {
            let evc = segue.destination as? EntryViewController
            evc?.country = actCountry!
            evc?.city = actCity!
            evc?.latitude = actLoc.coordinate.latitude 
            evc?.longitude = actLoc.coordinate.longitude 
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.isRotateEnabled = false
        searchField.delegate = self
        addButton.isEnabled = false
        actLoc = initLoc
        self.regionRadius = initialZoom
        let marker = Marker(locationName: "unter den Eichen",coordinate: self.initLoc.coordinate)
        centerMaponLocation(location: initLoc)
        mapView.addAnnotation(marker)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
extension ViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchButton(self)
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        regionRadius = initialZoom
        centerMaponLocation(location: actLoc)
        
        return true
    }
}
















