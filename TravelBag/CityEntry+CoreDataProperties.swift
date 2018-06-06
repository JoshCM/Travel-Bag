//
//  CityEntry+CoreDataProperties.swift
//  TravelBag
//
//  Created by Joshua Mestre on 06.06.18.
//  Copyright © 2018 Gruppe04. All rights reserved.
//
//

import Foundation
import CoreData


extension CityEntry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CityEntry> {
        return NSFetchRequest<CityEntry>(entityName: "CityEntry")
    }

    @NSManaged public var name: String?
    @NSManaged public var country: String?
    @NSManaged public var descript: String?
    @NSManaged public var image: NSData?
    @NSManaged public var longitude: Double
    @NSManaged public var latitude: Double
    @NSManaged public var cats: NSSet?

}

// MARK: Generated accessors for cats
extension CityEntry {

    @objc(addCatsObject:)
    @NSManaged public func addToCats(_ value: Category)

    @objc(removeCatsObject:)
    @NSManaged public func removeFromCats(_ value: Category)

    @objc(addCats:)
    @NSManaged public func addToCats(_ values: NSSet)

    @objc(removeCats:)
    @NSManaged public func removeFromCats(_ values: NSSet)

}
