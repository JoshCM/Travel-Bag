//
//  Category+CoreDataProperties.swift
//  TravelBag
//
//  Created by Joshua Mestre on 06.06.18.
//  Copyright © 2018 Gruppe04. All rights reserved.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var title: String?
    @NSManaged public var catent: NSSet?

}

// MARK: Generated accessors for catent
extension Category {

    @objc(addCatentObject:)
    @NSManaged public func addToCatent(_ value: CatEntry)

    @objc(removeCatentObject:)
    @NSManaged public func removeFromCatent(_ value: CatEntry)

    @objc(addCatent:)
    @NSManaged public func addToCatent(_ values: NSSet)

    @objc(removeCatent:)
    @NSManaged public func removeFromCatent(_ values: NSSet)

}
