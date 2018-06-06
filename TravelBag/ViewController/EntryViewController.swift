//
//  EntryViewController.swift
//  TravelBag
//
//  Created by Anonymer Eintrag on 30.05.18.
//  Copyright © 2018 Gruppe04. All rights reserved.
//

import UIKit

class EntryViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    var imagePicker = UIImagePickerController()
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var descriptionField: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    var city: String = ""
    var country: String = ""
    var latitude:Double = 0
    var longitude:Double = 0
    var imageChanged:Bool = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionField.text = "Description"
        cityName.text = city
        countryName.text = country
        imagePicker.delegate = self
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        imageChanged = true
        imageView.contentMode = .scaleAspectFill
        dismiss(animated: true, completion: nil)
            
        
    }
    
    @IBAction func saveEntry(_ sender: Any) {
        let context = AppDelegate.viewContext
        let city:CityEntry = CityEntry(context: context)
        
        city.name = cityName.text
        city.country = countryName.text
        city.descript = descriptionField.text
        city.latitude = latitude
        city.longitude = longitude
        if (imageChanged){
            city.image = UIImagePNGRepresentation(imageView.image!) as NSData?
        }
        print("gesavt")
        
        
        
    }
    @IBAction func imageTapped(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker,animated: true,completion: nil)
        print("Hallo")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


