//
//  Favorites+CoreDataProperties.swift
//  DynamicData
//
//  Created by 김동우 on 2022/12/17.
//
//

import Foundation
import CoreData


extension Favorites {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorites> {
        return NSFetchRequest<Favorites>(entityName: "Favorites")
    }

    @NSManaged public var id: String?
    @NSManaged public var width: String?
    @NSManaged public var height: String?
    @NSManaged public var url: String?

}
