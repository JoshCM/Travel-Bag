//
//  EditEntryViewController.swift
//  TravelBag
//
//  Created by Anonymer Eintrag on 13.06.18.
//  Copyright © 2018 Gruppe04. All rights reserved.
//

import UIKit
import CoreData


class EditEntryViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UICollectionViewDelegate,UICollectionViewDataSource{

    var city: String = ""
    var country: String = ""
    var image: UIImage? = nil
    var descript: String = ""
    var cityCoreData:CityEntry?
    var imagePicker = UIImagePickerController()
    var tap:UITapGestureRecognizer?
    let context = AppDelegate.viewContext
    var imageChanged:Bool = false
    var imageArray = [UIImage(named:"no_img"),UIImage(named:"no_img"),UIImage(named:"no_img"),UIImage(named:"no_img")]
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var descriptionField: UITextView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var foodCollectionView: UICollectionView!
    
    @IBOutlet weak var SightCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityName.text = city.uppercased()
        countryName.text = country
        imagePicker.delegate = self
        tap = UITapGestureRecognizer(target: self, action:#selector(handleImageTaped(_sender:)))
        
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
            imageView.addGestureRecognizer(self.tap!)
            sender.setTitle("Save", for: .normal)
        }else{
            descriptionField.isSelectable = false
            descriptionField.isEditable = false
            self.cityCoreData?.descript = descriptionField.text
            imageView.removeGestureRecognizer(self.tap!)
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
    
    @IBAction func didUnwindFromNewCatEntry(_ sender: UIStoryboardSegue){
        for case let cat as Category in cityCoreData!.cats!{
            for case let ent as CatEntry in cat.catent!{
                print(ent.title)
            }
        }
    }
    
    @IBAction func addCatEntry(_ sender: UIButton) {
        performSegue(withIdentifier: "NewCatSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewCatSegue"{
            let dest = segue.destination as! NewCatEntryViewController
            dest.cityCoreData = self.cityCoreData!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.foodCollectionView{
            print("hallo i bims")
        }
        else{
            print("keine ahnung wer du bist")
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        cell.catImage.image = imageArray[indexPath.row]
        return cell
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
