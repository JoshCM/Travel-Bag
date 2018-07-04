//
//  CityTableViewController.swift
//  TravelBag
//
//  Created by Joshua Mestre on 06.06.18.
//  Copyright © 2018 Gruppe04. All rights reserved.
//

import UIKit
import CoreData

class CityTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    var cities:[CityEntry]!
    let context = AppDelegate.viewContext
    @IBOutlet weak var tableView: UITableView!
    var actCell: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCityEntries()
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    private func loadCityEntries(){
        let fetchRequest:NSFetchRequest = CityEntry.fetchRequest()
        do{
            try cities = context.fetch(fetchRequest) as [CityEntry]
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


