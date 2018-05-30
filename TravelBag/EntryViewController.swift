//
//  EntryViewController.swift
//  TravelBag
//
//  Created by Anonymer Eintrag on 30.05.18.
//  Copyright © 2018 Gruppe04. All rights reserved.
//

import UIKit

class EntryViewController: UIViewController {

    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var descriptionField: UITextView!
    var city: String = ""
    var country: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionField.text = "Description"
        cityName.text = city
        countryName.text = country
        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


