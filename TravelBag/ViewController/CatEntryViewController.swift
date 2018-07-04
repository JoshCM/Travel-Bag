//
//  catEntryViewController.swift
//  TravelBag
//
//  Created by Anonymer Eintrag on 04.07.18.
//  Copyright © 2018 Gruppe04. All rights reserved.
//

import UIKit

class CatEntryViewController: UIViewController {
    var catEntry:CatEntry!

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var entrytitle: UILabel!
    @IBOutlet weak var cat: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var descr: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        entrytitle.text = catEntry.title
        image.image = UIImage(data: catEntry.image! as Data)
        
        if let dis = catEntry.descript{
           self.descr.text = dis
        }
        if let address = catEntry.address{
            self.address.text = address
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
