//
//  LocalStorageService.swift
//  KYCApp
//
//  Created by Георгий Фесенко on 22/07/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import Foundation
import CoreData

class LocalStorageService {
    
    lazy var container: NSPersistentContainer = NSPersistentContainer(name: "CoreDataModel")
    private lazy var mainContext = self.container.viewContext
    
    init() {
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Failed to load store: \(error)")
            }
        }
    }
    
    func getDataForTypes(types: [String]) -> [UserDataModel] {
        let request: NSFetchRequest<UserData> = UserData.fetchRequest()
        var result = [UserDataModel]()
        do {
            let fetchedData = try mainContext.fetch(request)
            for el in fetchedData {
                if types.contains(el.typeID!) {
                    result.append(
                        UserDataModel(typeID: el.typeID!, detail: el.detail!)
                    )
                }
            }
        } catch {
            print(error)
            return []
        }
        return result
    }
    
    func getAllData() -> [UserDataModel] {
        let request: NSFetchRequest<UserData> = UserData.fetchRequest()
        var result = [UserDataModel]()
        do {
            let fetchedData = try mainContext.fetch(request)
            for el in fetchedData {
                result.append(
                    UserDataModel(typeID: el.typeID!, detail: el.detail!)
                )
            }
            return result
        } catch {
            print(error)
            return result
        }
    }
    
    //Be aware of this function
    func save(data: [UserDataModel], completion: @escaping (Bool) -> Void) {
        let request: NSFetchRequest<UserData> = UserData.fetchRequest()
        container.performBackgroundTask { (context) in
            do {
                
                //Remove everything
                let fetchedData = try context.fetch(request)
                if fetchedData.count > 0 {
                    for el in fetchedData {
                        context.delete(el)
                    }
                    try context.save()
                }
                
                //Add new data
                for userData in data {
                    let newEntity = NSEntityDescription.insertNewObject(forEntityName: "UserData", into: context) as? UserData
                    newEntity?.typeID = userData.typeID
                    newEntity?.detail = userData.detail
                }
                try context.save()
                DispatchQueue.main.async {
                    completion(true)
                }
            } catch {
                print(error)
                completion(false)
            }
        }
    }
    
    func deleteProfile() {
        let request: NSFetchRequest<UserData> = UserData.fetchRequest()
        do {
            let res = try mainContext.fetch(request)
            for el in res {
                mainContext.delete(el)
            }
            try mainContext.save()
        } catch {
            print(error)
        }
    }
    
    func isThereAnyData() -> Bool {
        let request:NSFetchRequest<UserData> = UserData.fetchRequest()
        do {
            let res = try mainContext.count(for: request)
            return res == 0 ? false : true
        } catch {
            return false
        }
    }
}
