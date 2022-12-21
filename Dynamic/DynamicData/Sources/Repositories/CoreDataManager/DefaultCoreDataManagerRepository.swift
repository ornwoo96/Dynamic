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
    case favorites = "Favorites"
}

public class DefaultCoreDataManagerRepository: CoreDataManagerRepository {
    public static let shared = DefaultCoreDataManagerRepository()
    
    private let identifier: String = "dongdong.DynamicData"
    private let model: String = "DynamicCoreData"
    
    lazy var persistentContainer: NSPersistentContainer = {
        let bundle = Bundle(identifier: self.identifier)
        guard let modelURL = bundle?.url(forResource: self.model, withExtension: "momd") else {
            return NSPersistentContainer()
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            print("modelURL 가져오기 실패")
            return NSPersistentContainer()
        }
        
        let container = NSPersistentContainer(name: self.model, managedObjectModel: managedObjectModel)
        
        container.loadPersistentStores(completionHandler: { (store, error) in
            if let error = error {
                fatalError("persistentContainer 생성 실패\(error)")
            }
        })
        
        return container
        
    }()
    
    public func createGIFImageData(_ height: String,
                                   _ width: String,
                                   _ id: String,
                                   _ url: String) {
        let context = persistentContainer.viewContext
        guard let entity: Favorites = NSEntityDescription.insertNewObject(forEntityName: CoreDataEntityName.favorites.rawValue, into: context) as? Favorites else { return }
        
        entity.height = height
        entity.width = width
        entity.id = id
        entity.url = url
        
        do {
            try context.save()
            print("coreData image save - 성공")
        } catch {
            print("coreData image save - 실패")
        }
    }
    
    public func removeGIFImageData(_ id: String) {
        let request = Favorites.fetchRequest()
        let context = persistentContainer.viewContext
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let data = try context.fetch(request)
            
            if data.count == 0 {
                return
            } else {
                context.delete(data[0])
                try context.save()
                print("GIF Image 삭제 - 완료")
                return
            }
        } catch {
            print(error.localizedDescription)
            return
        }
    }
    
    public func checkGIFImageDataIsExist(_ id: String) async throws -> Bool {
        let request = Favorites.fetchRequest()
        let context = persistentContainer.viewContext

        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let data = try context.fetch(request)
            
            if data.count == 0 {
                return false
            } else {
                return true
            }
            
        } catch {
            print("coreData check 실패")
            return false
        }
    }
    
    public func requestFavoriteData(_ id: String) async throws -> FavoriteDomainModel {
        let request = Favorites.fetchRequest()
        let context = persistentContainer.viewContext
        
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let data = try context.fetch(request)
            
            if data.count == 0 {
                return FavoriteDomainModel.empty
            } else {
                let domainModel = FavoriteDomainModel(url: data[0].url ?? "",
                                                      width: data[0].width ?? "",
                                                      height: data[0].height ?? "",
                                                      id: data[0].id ?? "")
                return domainModel
            }
        } catch {
            print(error.localizedDescription)
            return FavoriteDomainModel.empty
        }
    }
    
    public func requestFavoritesDatas() async throws -> [FavoriteDomainModel] {
        let request = Favorites.fetchRequest()
        let context = persistentContainer.viewContext

        do {
            let data = try context.fetch(request)
            
            if data.count == 0 {
                print("코어데이터에 아무것도 없습니다")
                return []
            } else {
                return convertFavoritesToDomainModel(data)
            }
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    private func convertFavoritesToDomainModel(_ data: [Favorites]) -> [FavoriteDomainModel] {
        var dataArray: [FavoriteDomainModel] = []
        for i in data {
            let domainModel: FavoriteDomainModel = .init(url: i.url ?? "",
                                                         width: i.width ?? "",
                                                         height: i.height ?? "",
                                                         id: i.id ?? "")
            dataArray.append(domainModel)
        }
        
        return dataArray
    }
}
