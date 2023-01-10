//
//  CoreDataManagerTests.swift
//  DynamicData
//
//  Created by 김동우 on 2022/12/29.
//

import XCTest
import Foundation
import DynamicDomain
@testable import DynamicData
import CoreData

final class CoreDataManagerTests: XCTestCase {
    private let identifier: String = "dongdong.DynamicData"
    private let model: String = "DynamicCoreData"
    
    lazy var persistentContainer: NSPersistentContainer = {
        let bundle = Bundle(identifier: self.identifier)
        guard let modelURL = bundle?.url(forResource: self.model, withExtension: "momd") else {
            print(CoreDataError.containerError,"ModelURL create - 실패")
            return NSPersistentContainer()
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            print(CoreDataError.containerError,"NSPersistentContainer create - 실패")
            return NSPersistentContainer()
        }
        
        let container = NSPersistentContainer(name: self.model, managedObjectModel: managedObjectModel)
        
        container.loadPersistentStores(completionHandler: { (store, error) in
            if let error = error {
                fatalError("loadPersistentStores - 실패 \(error)")
            }
        })
        
        return container
    }()
    
    func testCreateImageData() {
        var testResult = false
        let context = persistentContainer.viewContext
        guard let entity: Favorites = NSEntityDescription.insertNewObject(forEntityName: CoreDataEntityName.favorites.rawValue, into: context) as? Favorites else { return }
        
        entity.height = "300"
        entity.width = "300"
        entity.id = "1234"
        entity.url = "1234"
        
        do {
            try context.save()
            testResult = true
        } catch {
            print(CoreDataError.saveError)
        }
        
        XCTAssertEqual(testResult, true)
    }
    
    func testRequestFavoritesData() throws {
        let request = Favorites.fetchRequest()
        let context = persistentContainer.viewContext
        var testResult = false
        let id = "1234"
        var dataCount = 0

        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let data = try context.fetch(request)
            
            if data.count == 0 {
                
            } else {
                dataCount = data.count
            }
        } catch {
            throw CoreDataError.requestError
        }
        
        XCTAssertEqual(dataCount, 1)
    }
    
    func testRemoveImageData() throws {
        let id = "1234"
        var testResult = false
        let request = Favorites.fetchRequest()
        let context = persistentContainer.viewContext
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        let data = try context.fetch(request)
        
        do {
            if data.count == 0 {
                testResult = false
            } else {
                context.delete(data[0])
                try context.save()
                testResult = true
            }
        } catch {
            throw CoreDataError.deleteError
        }
        
        XCTAssertEqual(testResult, true)
    }
}
