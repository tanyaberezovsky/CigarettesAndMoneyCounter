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
        request.sortDescriptors = [NSSortDescriptor(key: "reason", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))]

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
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var levelSelected = String()
        //= dataList.textValue(indexPath.row)  //+ " " + dataList.detailText(indexPath.row)//levels[indexPath.row].nameNum
        if let objects = reasons.fetchedObjects
        {
            levelSelected = ((objects[indexPath.row] as? Reasons)?.reason)!
        }

        
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
    
    
    //////////////////          UIAlertController   area
    var tField: UITextField!
    
    func configurationTextField(textField: UITextField!)
    {
        //print("generating the TextField")
        textField.placeholder = "Enter an item"
        tField = textField
    }
    
    func handleCancel(alertView: UIAlertAction!)
    {
        //print("Cancelled !!")
    }
    
    @IBAction func addNewReasonBottonClick(sender: UIBarButtonItem) {
            let alert = UIAlertController(title: "Enter reason", message: "", preferredStyle: .Alert)
            let reasonsManager = ReasonsManager()
        
            alert.addTextFieldWithConfigurationHandler(configurationTextField)
            alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler:handleCancel))
            alert.addAction(UIAlertAction(title: "Add", style: .Default, handler:{ (UIAlertAction) in
            //print("Done !!")
            print("Item : \(self.tField.text)")
                reasonsManager.saveReason(self.tField.text!)
                do {
                    try self.reasons.performFetch()
                } catch let error as NSError {
                    print("Error fetching data \(error)")
                }
//                // tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
//                
//                self.tblLevels.performSelectorOnMainThread(#selector(UITableView.reloadData), withObject: nil, waitUntilDone: true)
//                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                    self.tableView.reloadData()
//                })
//                
                self.tableView.reloadData()

            }))
            self.presentViewController(alert, animated: true, completion: {
            print("completion block")
            })
    }

    //////////////////          end UIAlertController area
    @IBAction func BackButtonClick(sender: UIBarButtonItem) {
        if(myDelegate != nil){
            
            myDelegate!.myColumnDidSelected(self, text: "",segueName: segueSourceName!)
            
        }
        else{
            self.dismissViewControllerAnimated(false, completion: nil)
        }
    }
    
}


protocol TableLevelsControllerDelegate{
    func myColumnDidSelected(controller:TableLavels,text:String, segueName:String)
}
