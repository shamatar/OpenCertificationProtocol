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
        let uintTypes = types.compactMap { (el) -> UInt16? in
            return el.hexToUInt()
        }
        let request: NSFetchRequest<UserData> = UserData.fetchRequest()
        var result = [UserDataModel]()
        let sort = NSSortDescriptor(key: #keyPath(UserData.index), ascending: true)
        request.sortDescriptors = [sort]
        do {
            let fetchedData = try mainContext.fetch(request)
            for el in fetchedData {
                let tID: UInt16 = el.typeID!.hexToUInt()!
                if uintTypes.contains(tID) {
                    
                    result.append(
                        UserDataModel(typeID: tID, value: el.value!, name: el.name!, type: el.type!)
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
        let sort = NSSortDescriptor(key: #keyPath(UserData.index), ascending: true)
        request.sortDescriptors = [sort]
        var result = [UserDataModel]()
        do {
            let fetchedData = try mainContext.fetch(request)
            for el in fetchedData {
                let tID: UInt16 = el.typeID!.hexToUInt()!
                result.append(
                    UserDataModel(typeID: tID, value: el.value!, name: el.name!, type: el.type!)
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
                    let typeId = "0x" + String(userData.typeID, radix: 16)
                    newEntity?.typeID = "0x" + String(userData.typeID, radix: 16)
                    newEntity?.name = userData.name
                    newEntity?.value = userData.value
                    newEntity?.type = userData.type
                    newEntity?.index = typeId.hexToUInt()!
                }
                try context.save()
                DispatchQueue.main.async {
                    completion(true)
                }
            } catch {
                print(error)
                DispatchQueue.main.async {
                    completion(false)
                }
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
