//
//  PersistenceManager.swift
//  Digin
//
//  Created by 김예은 on 2021/05/19.
//

import CoreData

class PersistenceManager {

    static var shared: PersistenceManager = PersistenceManager()

    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CompanyModel")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    var context: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }

    func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T] {
        do {
            let fetchResult = try self.context.fetch(request)
            return fetchResult
        } catch {
            print(error.localizedDescription)
            return []
        }
    }

    @discardableResult
    func insertCompany(name: String) -> Bool {
        let entity = NSEntityDescription.entity(forEntityName: "RecentCompany", in: self.context)

        if let entity = entity {
            let managedObject = NSManagedObject(entity: entity, insertInto: self.context)
            managedObject.setValue(name, forKey: "name")

            do {
                try self.context.save()
                return true
            } catch {
                print(error.localizedDescription)
                return false
            }
        } else {
            return false
        }
    }

    @discardableResult
    func delete(object: NSManagedObject) -> Bool {
        self.context.delete(object)
        do {
            try self.context.save()
            return true
        } catch {
            return false
        }
    }

    func count<T: NSManagedObject>(request: NSFetchRequest<T>) -> Int? {
        do {
            let count = try self.context.count(for: request)
            return count
        } catch {
            return nil
        }
    }

    //TODO: request 코드 수정
    @discardableResult
    func deleteAll<T: NSManagedObject>(request: NSFetchRequest<T>) -> Bool {
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "RecentCompany")
        let delete = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try self.context.execute(delete)
            try self.context.save()
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
}
