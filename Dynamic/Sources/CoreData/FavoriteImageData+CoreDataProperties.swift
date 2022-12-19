//
//  FavoriteImageData+CoreDataProperties.swift
//  Dynamic
//
//  Created by 김동우 on 2022/12/17.
//
//

import Foundation
import CoreData


extension FavoriteImageData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteImageData> {
        return NSFetchRequest<FavoriteImageData>(entityName: "FavoriteImageData")
    }

    @NSManaged public var imageData: Data?
    @NSManaged public var id: String?
    @NSManaged public var height: String?
    @NSManaged public var width: String?

}

extension FavoriteImageData : Identifiable {

}
