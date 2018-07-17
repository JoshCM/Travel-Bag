    //
    //  EditEntryViewController.swift
    //  TravelBag
    //
    //  Created by Anonymer Eintrag on 13.06.18.
    //  Copyright © 2018 Gruppe04. All rights reserved.
    //
    
    import UIKit
    import CoreData
    
    
    class EditEntryViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UICollectionViewDelegate,UICollectionViewDataSource, UITextViewDelegate{
        
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
        var chosenCatEnt:CatEntry?
        var chosenCat:String?
        var editingModeEnabled:Bool = false
        
        @IBOutlet weak var foodView: UIView!
        @IBOutlet weak var sightsView: UIView!
        @IBOutlet weak var housingView: UIView!
        @IBOutlet weak var activitiesView: UIView!
        
        @IBOutlet weak var cityName: UILabel!
        @IBOutlet weak var countryName: UILabel!
        @IBOutlet weak var descriptionField: UITextView!
        
        @IBOutlet weak var imageView: UIImageView!
        
        @IBOutlet weak var foodCollectionView: UICollectionView!
        @IBOutlet weak var housingCollectionView: UICollectionView!
        @IBOutlet weak var sightCollectionView: UICollectionView!
        @IBOutlet weak var activityCollectionView: UICollectionView!
        
        override func viewDidLoad(){
            super.viewDidLoad()
            self.hideKeyboardWhenTappedArround()
            descriptionField.delegate = self
            
            foodView.isHidden = true
            sightsView.isHidden = true
            housingView.isHidden = true
            activitiesView.isHidden = true
            
            cityName.text = city.uppercased()
            countryName.text = country
            imagePicker.delegate = self
            tap = UITapGestureRecognizer(target: self, action:#selector(handleImageTaped(_sender:)))
            
            if image != nil {
                imageView.image = image
            } else {
                imageView.image = UIImage(named: "no_img")
            }
            
            loadCityCoreData()
            descriptionField.font = UIFont(name: "Verdana", size: 17)
            descriptionField.text = cityCoreData?.descript
            
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        func textViewDidBeginEditing(_ textView: UITextView){
            if textView.text == "Description"{
                textView.text = ""
            }
        }
        
        @IBAction func editButton(_ sender: UIButton) {
            if sender.title(for: .normal) == "Edit"{
                editingModeEnabled = true
                bringLabeltoEditMode()
                descriptionField.isSelectable = true
                descriptionField.isEditable = true
                imageView.addGestureRecognizer(self.tap!)
                sender.setTitle("Save", for: .normal)
                sender.setImage(UIImage(named: "save_btn"), for: .normal)
            }else{
                editingModeEnabled = false
                print(checkContentCats())
                
                self.foodCollectionView.reloadData()
                self.activityCollectionView.reloadData()
                self.housingCollectionView.reloadData()
                self.sightCollectionView.reloadData()
                
                descriptionField.isSelectable = false
                descriptionField.isEditable = false
                self.cityCoreData?.descript = descriptionField.text
                imageView.removeGestureRecognizer(self.tap!)
                if (imageChanged){
                    cityCoreData?.image = UIImagePNGRepresentation(imageView.image!) as NSData?
                }
                try? context.save()
                sender.setTitle("Edit", for: .normal)
                sender.setImage(UIImage(named:"edit_btn"), for: .normal)
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
        
        @IBAction func didUnwindFromCatEntry(_ sender:UIStoryboardSegue){
        }
        
        @IBAction func addCatEntry(_ sender: UIButton) {
            performSegue(withIdentifier: "NewCatSegue", sender: self)
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "NewCatSegue"{
                let dest = segue.destination as! NewCatEntryViewController
                dest.cityCoreData = self.cityCoreData!
            }
            else if segue.identifier == "CatSegue"{
                let dest = segue.destination as! CatEntryViewController
                
                dest.catEntry = self.chosenCatEnt!
                dest.catString = self.chosenCat!
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
        
        func checkContentCats()->Bool{
            var allEmpty = true
            
            if self.activity.catent?.count == 0{
                activitiesView.isHidden = true
            }else{
                activitiesView.isHidden = false
                allEmpty = false
            }
            
            if self.food.catent?.count == 0{
                foodView.isHidden = true
            }else{
                foodView.isHidden = false
                allEmpty = false
            }
            
            if self.housing.catent?.count == 0{
                housingView.isHidden = true
            }else{
                housingView.isHidden = false
                allEmpty = false
            }
            
            if self.sight.catent?.count == 0{
                sightsView.isHidden = true
            }else{
                sightsView.isHidden = false
                allEmpty = false
            }
            
            return allEmpty
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
            
            if checkContentCats(){
                return cell
            }
            
            let acts:[CatEntry] = self.activity.catent?.allObjects as! [CatEntry]
            let food:[CatEntry] = self.food.catent?.allObjects as! [CatEntry]
            let house:[CatEntry] = self.housing.catent?.allObjects as! [CatEntry]
            let sight:[CatEntry] = self.sight.catent?.allObjects as! [CatEntry]
            
            
            
            switch collectionView {
            case self.activityCollectionView:
                cell.catImage.image = UIImage(data: acts[indexPath.row].image! as Data)
                cell.catLabel.text = acts[indexPath.row].title
                cell.catEntry = acts[indexPath.row]
            case self.foodCollectionView:
                cell.catImage.image = UIImage(data: food[indexPath.row].image! as Data)
                cell.catLabel.text = food[indexPath.row].title
                cell.catEntry = food[indexPath.row]
            case self.housingCollectionView:
                cell.catImage.image = UIImage(data: house[indexPath.row].image! as Data)
                cell.catLabel.text = house[indexPath.row].title
                cell.catEntry = house[indexPath.row]
            case self.sightCollectionView:
                cell.catImage.image = UIImage(data: sight[indexPath.row].image! as Data)
                cell.catLabel.text = sight[indexPath.row].title
                cell.catEntry = sight[indexPath.row]
            default:
                break
            }
            
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let cell = collectionView.cellForItem(at: indexPath) as! CategoryCollectionViewCell
            self.chosenCatEnt = cell.catEntry
            
            if editingModeEnabled{
                cell.isHidden = true
                try? self.context.delete(self.context.existingObject(with: (chosenCatEnt?.objectID)!))
                try? self.context.save()
                
                switch collectionView {
                case self.activityCollectionView:
                    self.activity.removeFromCatent(chosenCatEnt!)
                case self.foodCollectionView:
                    self.food.removeFromCatent(chosenCatEnt!)
                case self.housingCollectionView:
                    self.housing.removeFromCatent(chosenCatEnt!)
                case self.sightCollectionView:
                    self.sight.removeFromCatent(chosenCatEnt!)
                default:
                    break
                }
                
                loadCityCoreData()
                
                return
            }
            
            switch collectionView {
            case self.activityCollectionView:
                self.chosenCat = "Activity"
            case self.foodCollectionView:
                self.chosenCat = "Food"
            case self.housingCollectionView:
                self.chosenCat = "Housing"
            case self.sightCollectionView:
                self.chosenCat = "Sight"
            default:
                self.chosenCat = "Categorie"
            }
            
            performSegue(withIdentifier: "CatSegue", sender: self)
            
        }
        
        func loadCityCoreData(){
            do{
                let fetchRequest : NSFetchRequest<CityEntry> = CityEntry.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "name == %@", city)
                let fetchedResults = try context.fetch(fetchRequest) as [CityEntry]
                if let acity = fetchedResults.first {
                    cityCoreData = acity
                }
            }catch{
                print("fetching cityCoreData data failed")
            }
            
        }
        
        func bringLabeltoEditMode(){
            for cell in activityCollectionView.visibleCells{
                (cell as! CategoryCollectionViewCell).catLabel.text = "Delete"
            }
            
            for cell in foodCollectionView.visibleCells{
                (cell as! CategoryCollectionViewCell).catLabel.text = "Delete"
            }
            
            for cell in housingCollectionView.visibleCells{
                (cell as! CategoryCollectionViewCell).catLabel.text = "Delete"
            }
            
            for cell in sightCollectionView.visibleCells{
                (cell as! CategoryCollectionViewCell).catLabel.text = "Delete"
            }
        }
    }
