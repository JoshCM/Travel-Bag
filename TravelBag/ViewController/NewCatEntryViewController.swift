//
//  NewCatEntryViewController.swift
//  TravelBag
//
//  Created by Anonymer Eintrag on 20.06.18.
//  Copyright © 2018 Gruppe04. All rights reserved.
//

import UIKit
import CoreData

class NewCatEntryViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    let cats = ["Food","Sight","Housing", "Activity"]
    var cityCoreData:CityEntry?
    var imagePicker = UIImagePickerController()
    var imageChanged = false
    var tap:UITapGestureRecognizer?
    
    @IBOutlet weak var pickerTextField: UITextField!
    
    @IBOutlet weak var descriptionText: UITextView!
    
    @IBOutlet weak var addressText: UITextView!
    
    @IBOutlet weak var catImage: UIImageView!
    
    @IBOutlet weak var titleText: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedArround()
        
        descriptionText.delegate = self
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        imagePicker.delegate = self
        pickerTextField.inputView = pickerView
        descriptionText.layer.borderWidth = 0.5
        descriptionText.layer.borderColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.1).cgColor
        descriptionText.layer.cornerRadius = 5
        addressText.layer.borderWidth = 0.5
        addressText.layer.borderColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.1).cgColor
        addressText.layer.cornerRadius = 5
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func saveEntry(_ sender: Any) {
        if (!(pickerTextField.text! == "" && titleText.text! == "")){
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
            
            if let address = addressText.text{
                catentry.address = address
            }
            
            if imageChanged{
                catentry.image = UIImagePNGRepresentation(catImage.image!) as NSData?
            }else{
                catentry.image = UIImagePNGRepresentation(UIImage(named: "no_img")!) as NSData?
            }
            
            category!.addToCatent(catentry)
            try? context.save()
            self.performSegue(withIdentifier: "backtoCityList", sender: self)
            
        }else{
            if pickerTextField.text == ""{
                pickerTextField.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.1)
            }
            if titleText.text == ""{
                titleText.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.1)
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.view.transform = CGAffineTransform(translationX: 0, y: -200)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.view.transform = CGAffineTransform(translationX: 0, y: 0)
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
    
    @IBAction func imageTaped(_ sender: Any) {
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
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
