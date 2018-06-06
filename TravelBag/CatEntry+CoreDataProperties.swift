//
//  CatEntry+CoreDataProperties.swift
//  TravelBag
//
//  Created by Joshua Mestre on 06.06.18.
//  Copyright © 2018 Gruppe04. All rights reserved.
//
//

import Foundation
import CoreData


extension CatEntry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CatEntry> {
        return NSFetchRequest<CatEntry>(entityName: "CatEntry")
    }

    @NSManaged public var title: String?
    @NSManaged public var descript: String?
    @NSManaged public var image: NSData?

}
