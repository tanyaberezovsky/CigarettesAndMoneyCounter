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
    
   let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext

    
    func saveReason(_ newReason : String)
    {
        if(!reasonExist(newReason)){
            
            performSaveReason(newReason)
        }
        
    }

    
    
    func reasonExist( _ newReason : String )->Bool
    {
        if((newReason ).isEmpty){
            return false
        }
        
        //where condition
        let predicate = NSPredicate(format:"reason =[cd] %@", newReason)
        
        //    and then a fetch request
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Reasons")
        fetchRequest.propertiesToFetch = ["reason"]
        fetchRequest.resultType = .dictionaryResultType
        
        fetchRequest.predicate = predicate
        
        
        do {
            let result:NSArray = try self.managedObjectContext!.fetch(fetchRequest) as NSArray 
            
            
            if (result.count == 0) {
                
                
             return false
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return false
        }
        return true
        
    }

    func performSaveReason(_ newReason : String)
    {
        
        let entityDescripition = NSEntityDescription.entity(forEntityName: "Reasons", in: managedObjectContext!)
        
        let reason1 = Reasons(entity: entityDescripition!, insertInto:  managedObjectContext)
        
        
        reason1.reason = newReason
        
        do {
            try managedObjectContext?.save()
            managedObjectContext?.reset()
        } catch _ {
        }

    }

    func coreDataReasonsEntityInit(){
        cause.forEach{ saveReason($0) }
    }
}
