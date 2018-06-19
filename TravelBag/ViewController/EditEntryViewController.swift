//
//  EditEntryViewController.swift
//  TravelBag
//
//  Created by Anonymer Eintrag on 13.06.18.
//  Copyright © 2018 Gruppe04. All rights reserved.
//

import UIKit
import CoreData


class EditEntryViewController: UIViewController, UIImagePickerControllerDelegate {

    var city: String = ""
    var country: String = ""
    var image: UIImage? = nil
    var descript: String = ""
    var cityCoreData:CityEntry?
    var imagePicker = UIImagePickerController()
    let context = AppDelegate.viewContext
    var imageChanged:Bool = false
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var descriptionField: UITextView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityName.text = city.uppercased()
        countryName.text = country
    
        
        
        if image != nil {
            imageView.image = image
        } else {
            imageView.image = UIImage(named: "no_img")
        }
        
        do {
            let fetchRequest : NSFetchRequest<CityEntry> = CityEntry.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "name == %@", city)
            let fetchedResults = try context.fetch(fetchRequest) as [CityEntry]
            if let acity = fetchedResults.first {
                cityCoreData = acity
            }
            
            descriptionField.font = UIFont(name: "Verdana", size: 17)
            descriptionField.text = cityCoreData?.descript
        }
        catch {
            print ("fetch task failed", error)
        }
        
        
    
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func editButton(_ sender: UIButton) {
        if sender.title(for: .normal) == "Edit"{
            descriptionField.isSelectable = true
            descriptionField.isEditable = true
            let tap = UITapGestureRecognizer(target: self, action:#selector(handleImageTaped(_sender:)))
            imageView.addGestureRecognizer(tap)
            sender.setTitle("Save", for: .normal)
        }else{
            descriptionField.isSelectable = false
            descriptionField.isEditable = false
            self.cityCoreData?.descript = descriptionField.text
            if (imageChanged){
                cityCoreData?.image = UIImagePNGRepresentation(imageView.image!) as NSData?
            }
            try? context.save()
            sender.setTitle("Edit", for: .normal)
        }
       
        
        
    }
    
    @objc func handleImageTaped(_sender:UITapGestureRecognizer){
        imagePicker.sourceType = .photoLibrary
        present(imagePicker,animated: true,completion: nil)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
