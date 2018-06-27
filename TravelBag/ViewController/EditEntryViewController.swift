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
    var activity,food,sight,housing:Category!
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var countryName: UILabel!
    
    @IBOutlet weak var descriptionField: UITextView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var foodCollectionView: UICollectionView!
    @IBOutlet weak var housingCollectionView: UICollectionView!
    @IBOutlet weak var sightCollectionView: UICollectionView!
    @IBOutlet weak var activityCollectionView: UICollectionView!
    
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
        activityCollectionView.reloadData()
        foodCollectionView.reloadData()
        housingCollectionView.reloadData()
        sightCollectionView.reloadData()
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
        
        let catList = cityCoreData?.cats
        for case let cat as Category in catList!{
            switch cat.title{
            case "Activity"?:
                self.activity = cat
            case "Food"?:
                self.food = cat
            case "Housing"?:
                self.housing = cat
            case "Sight"?:
                self.sight = cat
            default:
                return 0
            }
        }
        
        switch collectionView {
        case self.activityCollectionView:
            return (self.activity.catent?.count)!
        case self.foodCollectionView:
            return (self.food.catent?.count)!
        case self.housingCollectionView:
            return (self.housing.catent?.count)!
        case self.sightCollectionView:
            return (self.sight.catent?.count)!
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        let acts:[CatEntry] = self.activity.catent?.allObjects as! [CatEntry]
        let food:[CatEntry] = self.food.catent?.allObjects as! [CatEntry]
        let house:[CatEntry] = self.housing.catent?.allObjects as! [CatEntry]
        let sight:[CatEntry] = self.sight.catent?.allObjects as! [CatEntry]
        
        
        
        switch collectionView {
        case self.activityCollectionView:
            cell.catImage.image = UIImage(data: acts[indexPath.row].image! as Data)
        case self.foodCollectionView:
            cell.catImage.image = UIImage(data: food[indexPath.row].image! as Data)
        case self.housingCollectionView:
            cell.catImage.image = UIImage(data: house[indexPath.row].image! as Data)
        case self.sightCollectionView:
            cell.catImage.image = UIImage(data: sight[indexPath.row].image! as Data)
        default:
            break
        }
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
