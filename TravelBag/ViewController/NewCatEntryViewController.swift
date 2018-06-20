//
//  NewCatEntryViewController.swift
//  TravelBag
//
//  Created by Anonymer Eintrag on 20.06.18.
//  Copyright © 2018 Gruppe04. All rights reserved.
//

import UIKit
import CoreData

class NewCatEntryViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let cats = ["Food","Sight","Housing", "Activity"]
    var cityCoreData:CityEntry?
    var imagePicker = UIImagePickerController()
    var imageChanged = false
    
    @IBOutlet weak var pickerTextField: UITextField!
    
    @IBOutlet weak var descriptionText: UITextField!
    
    @IBOutlet weak var addressText: UITextField!
    
    @IBOutlet weak var catImage: UIImageView!
    
    @IBOutlet weak var titleText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let pickerView = UIPickerView()
        pickerView.delegate = self
        imagePicker.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleImageTaped(_sender:)))
        catImage.addGestureRecognizer(tap)
        
        pickerTextField.inputView = pickerView
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cats.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cats[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerTextField.text = cats[row]
        self.view.endEditing(true)
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
        catImage.image = image
        imageChanged = true
        catImage.contentMode = .scaleAspectFill
        dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func saveEntry(_ sender: Any) {
        let context = AppDelegate.viewContext
        var category:Category?
        let catentry:CatEntry = CatEntry(context: context)
  
        for case let cat as Category in cityCoreData!.cats!{
            if cat.title == pickerTextField.text!{
                category = cat
            }
        }
        
        catentry.descript = descriptionText.text
        catentry.title = titleText.text
        
        if imageChanged{
            catentry.image = UIImagePNGRepresentation(catImage.image!) as NSData?
        }
        
        category!.addToCatent(catentry)
        try? context.save()
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
