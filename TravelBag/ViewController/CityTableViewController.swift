//
//  CityTableViewController.swift
//  TravelBag
//
//  Created by Joshua Mestre on 06.06.18.
//  Copyright © 2018 Gruppe04. All rights reserved.
//

import UIKit
import CoreData
import AudioToolbox

class CityTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var cities:[CityEntry]!
    var shakeState = ["Date", "City", "Country"]
    var shakeIndex = 0
    let context = AppDelegate.viewContext
    @IBOutlet weak var tableView: UITableView!
    var actCell: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCityEntries(sortedby: "Date")
        tableView.delegate = self
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    private func loadCityEntries(sortedby:String){
        let fetchRequest:NSFetchRequest = CityEntry.fetchRequest()
        let sortdiscriptor:NSSortDescriptor
        switch sortedby {
        case "Date":
            break
        case "Country":
            sortdiscriptor = NSSortDescriptor(key: "country", ascending: false)
            fetchRequest.sortDescriptors = [sortdiscriptor]
        case "City":
            sortdiscriptor = NSSortDescriptor(key: "name", ascending: false)
            fetchRequest.sortDescriptors = [sortdiscriptor]
        default:
            break
        }
        do{
            try cities = context.fetch(fetchRequest) as [CityEntry]
            cities.reverse()
        }catch{
            fatalError("Laden hat nicht so geklappt")
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"cityTableCell") as! CityTableViewCell
        cell.cityName.text = cities[indexPath.row].name
        cell.countryName.text = cities[indexPath.row].country
        
        if cities[indexPath.row].image == nil{
            cell.Thumbnail.image = UIImage(named: "no_img")
        }else{
            cell.Thumbnail.image = UIImage(data: cities[indexPath.row].image! as Data)
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.actCell = indexPath.row
        performSegue(withIdentifier: "toEntry", sender: self);
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is EditEntryViewController
        {
            let evc = segue.destination as? EditEntryViewController
            evc?.country = cities[self.actCell].country!
            evc?.city = cities[self.actCell].name!
            if cities[self.actCell].image != nil {
                evc?.image = UIImage(data: cities[self.actCell].image! as Data)
            }
            
        }
    }
    
    
    @IBAction func didUnwindFromEditEntry(_ sender: UIStoryboardSegue){
        tableView.reloadData()
    }
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        shakeIndex = (shakeIndex+1)%3
        loadCityEntries(sortedby: shakeState[shakeIndex])
        print("Device was shaken! Sorted by ",shakeState[shakeIndex])
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


