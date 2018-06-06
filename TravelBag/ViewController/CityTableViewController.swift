//
//  CityTableViewController.swift
//  TravelBag
//
//  Created by Joshua Mestre on 06.06.18.
//  Copyright © 2018 Gruppe04. All rights reserved.
//

import UIKit
import CoreData

class CityTableViewController: UITableViewController {
    var cities:[CityEntry]!
    let context = AppDelegate.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCityEntries()

        // Do any additional setup after loading the view.
    }
    
    private func loadCityEntries(){
        let fetchRequest:NSFetchRequest = CityEntry.fetchRequest()
        do{
            try cities = context.fetch(fetchRequest) as [CityEntry]
        }catch{
            fatalError("Laden hat nicht so geklappt")
        }
        
        for city in cities{
            print(city.name)
        }
        
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
