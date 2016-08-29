//
//  ReasonsManager.swift
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 27/08/2016.
//  Copyright © 2016 Tania Berezovski. All rights reserved.
//


import UIKit
import CoreData


class ReasonsManager{
    
    //var managedObjectContext : NSManagedObjectContext?
   let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    lazy var reason: Reasons? =
        {
            
            if let context = self.managedObjectContext
            {
            //    return NSEntityDescription.insertNewObjectForEntityForName("Reasons", inManagedObjectContext: context) as? Reasons
                
                let entityDescripition = NSEntityDescription.entityForName("Reasons", inManagedObjectContext: context)
                
                return  Reasons(entity: entityDescripition!, insertIntoManagedObjectContext:  context)
                
            }
            return .None
    }()
    
    func saveReason(newReason : String)
    {
        if(!reasonExist(newReason)){
            
            performSaveReason(newReason)
        }
        
    }

    
    
    func reasonExist( newReason : String )->Bool
    {
        
        //where condition
        let predicate = NSPredicate(format:"reason =[cd] %@", newReason)
        
        //    and then a fetch request
        let fetchRequest = NSFetchRequest(entityName: "Reasons")
        fetchRequest.propertiesToFetch = ["reason"]
        fetchRequest.resultType = .DictionaryResultType
        
        fetchRequest.predicate = predicate
        
        
        do {
            let result:NSArray = try self.managedObjectContext!.executeFetchRequest(fetchRequest) //as! [DictionaryResultType]
            
            
            if (result.count == 0) {
                
                
             return false
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return false
        }
        return true
        
    }

    func performSaveReason(newReason : String)
    {

        
        reason!.reason = newReason
       
        if let managedObjectContext = managedObjectContext {
            do {
                try  managedObjectContext.save()
            }
            catch let error as NSError {
                print("Error saving \(error)", terminator: "")
            }
        }
    }

    func coreDataReasonsEntityInit(){
        for reason: String in cause
        {
            saveReason(reason)
        }
    }
}