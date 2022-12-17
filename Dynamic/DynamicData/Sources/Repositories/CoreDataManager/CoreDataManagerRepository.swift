//
//  CoreDataManager.swift
//  DynamicData
//
//  Created by 김동우 on 2022/12/17.
//

import Foundation
import DynamicDomain
import CoreData

enum CoreDataEntityName: String {
    case favoriteImageData = "FavoriteImageData"
}

public class DefaultCoreDataManagerRepository: CoreDataManagerRepository {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    public func createGIFImageData(_ data: OriginalDomainModel) {
        guard let entity = NSEntityDescription.entity(forEntityName: CoreDataEntityName.favoriteImageData.rawValue,
                                                      in: self.context),
              let favoriteData = NSManagedObject.init(entity: entity, insertInto: self.context) as? FavoriteImageData else { return }
        
        
    }
    
    public func removeGIFImageData(_ data: OriginalDomainModel) {
        
    }
    
    public func checkGIFImageDataIsExist() async throws -> Bool {
        return true
    }
}
