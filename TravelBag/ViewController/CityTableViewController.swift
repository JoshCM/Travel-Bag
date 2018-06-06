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
        cell.Thumbnail.image = UIImage(data: cities[indexPath.row].image! as Data)
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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


