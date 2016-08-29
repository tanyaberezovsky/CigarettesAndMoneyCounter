//
//  TableLevels.swift
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 9/26/14.
//  Copyright (c) 2014 Tania Berezovski. All rights reserved.
//

//import Foundation


import UIKit
import CoreData
//UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate

class TableLavels: UITableViewController, NSFetchedResultsControllerDelegate {
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    lazy var reasons : NSFetchedResultsController = {
        let request = NSFetchRequest(entityName: "Reasons")
        request.sortDescriptors = [NSSortDescriptor(key: "reason", ascending: false)]
        
        let reasons = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        reasons.delegate = self
            
        
        return reasons
      
    }()
    
    @IBOutlet weak var navigationHeader: UINavigationItem!
    
    var myDelegate:TableLevelsControllerDelegate? = nil
    
    
    var segueSourceName: String?
  
//    var dataList: selectionList!
    
    @IBOutlet var tblLevels: UITableView!
    
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        do {
            try reasons.performFetch()
        } catch let error as NSError {
            print("Error fetching data \(error)")
        }
      //+  tableView.reloadData()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.estimatedRowHeight = 68.0
        tableView.rowHeight = UITableViewAutomaticDimension
       //+ initView()
     //+   navigationHeader.title = dataList?.title
        //tableView.scrollEnabled = true

    }
    
    func initView(){
      //+   dataList = causeList()
    }
    
/*  init()
    { eshlej medison
        dataList = selectionList()
    }*/

  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let levelSelected = dataList.textValue(indexPath.row)  //+ " " + dataList.detailText(indexPath.row)//levels[indexPath.row].nameNum
        
        
        if(myDelegate != nil){

            myDelegate!.myColumnDidSelected(self, text: levelSelected,segueName: segueSourceName!)
        
        }
        else{
            
            if presentingViewController is popOverViewController
            {
                let vc = self.presentingViewController
                     as? popOverViewController
                vc!.causeOfSmoking.setTitle(levelSelected, forState: UIControlState.Normal)
                
            }
            self.dismissViewControllerAnimated(false, completion: nil)

        }
        
    }
 */
    
    //+    override func  tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        return dataList!.rowCount()
    //    }
    //    

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       /* let objects = reasons.fetchedObjects
        return objects?.count ?? 0*/
        if let sections = reasons.sections {
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }
        
        return 0

    }
    
    
    //+    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    //
    //        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyTestCell")
    //
    //        //we know that cell is not empty now so we use ! to force unwrapping
    //
    //        cell.textLabel!.text = dataList.text(indexPath.row)
    //        cell.detailTextLabel!.text = dataList.detailText(indexPath.row);
    //
    //        return cell
    //    }
    

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("reasonCellId", forIndexPath: indexPath) as? ReasonsTableViewCell {
            if let objects = reasons.fetchedObjects
            {
               /* if let rsn = objects[indexPath.row] as? Reasons
                {
                    cell.reason = rsn
                }*/
                cell.reason = objects[indexPath.row] as? Reasons
            }
            return cell
        }
        return UITableViewCell()
    }
    
}


protocol TableLevelsControllerDelegate{
    func myColumnDidSelected(controller:TableLavels,text:String, segueName:String)
}
