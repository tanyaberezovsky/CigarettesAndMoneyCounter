//
//  RowManagerViewController.swift
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 1/2/15.
//  Copyright (c) 2015 Tania Berezovski. All rights reserved.
//

import UIKit
import CoreData


class RowManagerViewController: UITableViewController,NSFetchedResultsControllerDelegate {
    
    var segment = 0

    @IBOutlet weak var viewHeader: UIView!
    
   // @IBOutlet weak var segmentControl: UISegmentedControl!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var fetchedResultControllerDaily: NSFetchedResultsController = NSFetchedResultsController()
    
    var fetchedResultControllerMonthly: NSFetchedResultsController = NSFetchedResultsController()
    
    var sortedKeysResultsYearly: NSArray!
   
    var fetchDictResultsYearly: [String: NSNumber]!

    var sortedKeysResultsMonthly: NSArray!
    
    var fetchDictResultsMonthly: [String: NSNumber]!

    var averageCostOfOneCigarette: Double = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = true
        createControls()
        
    }
    
    func createControls()
    {
        let defaults = UserDefaultsDataController()
        let userDefaults = defaults.loadUserDefaults()
        averageCostOfOneCigarette = userDefaults.averageCostOfOnePack / Double( userDefaults.amountOfCigarettsInOnePack)
      
        fetchedResultControllerDaily = getFetchedResultControllerDaily()
        fetchedResultControllerDaily.delegate = self
        do {
            try fetchedResultControllerDaily.performFetch()
        } catch _ {
        }
        
        fetchDictResultsMonthly = Dictionary()
        fetchDictResultsYearly = Dictionary()
        let selection=0
        if let objCount = fetchedResultControllerDaily.sections?[selection].numberOfObjects{
            
            for var index=0; index < objCount - 1; index++
            {
                let ind = NSIndexPath(forRow: index, inSection: selection)
                let task = fetchedResultControllerDaily.objectAtIndexPath(ind) as! CigaretteRecord
                let yearMonth:String = task.yearMonth()
                
                if let cigsSum = fetchDictResultsMonthly[yearMonth]{
                    
                    var calculatedSum:NSNumber = NSNumber()
                    
                        calculatedSum = cigsSum.integerValue + task.cigarettes.integerValue  as NSNumber
                    
                    fetchDictResultsMonthly.updateValue(calculatedSum, forKey: yearMonth)
                    
                } else {
                    fetchDictResultsMonthly[yearMonth] = task.cigarettes
                }
                
                let year:String = task.year()
                
                if let cigsSum = fetchDictResultsYearly[year]{
                    
                    var calculatedSum:NSNumber = NSNumber()
                    
                    calculatedSum = cigsSum.integerValue + task.cigarettes.integerValue  as NSNumber
                    
                    fetchDictResultsYearly.updateValue(calculatedSum, forKey: year)
                    
                } else {
                    fetchDictResultsYearly[year] = task.cigarettes
                }
            }
        }
        sortedKeysResultsMonthly = Array(fetchDictResultsMonthly.keys)
        sortedKeysResultsYearly = Array(fetchDictResultsYearly.keys)
        
        creteSegmentOnHeader()
    
    }
    
    func creteSegmentOnHeader()
    {
        
        let screenSize:CGRect = UIScreen.mainScreen().bounds
        viewHeader.frame.size.height = screenSize.height * 0.30

        let mySegment = UISegmentedControl(items: ["Daily","Monthly", "Yearly"])
     
        viewHeader.addSubview(mySegment)
//        self.tableView.tableHeaderView = mySegment
        mySegment.selectedSegmentIndex = 0
        mySegment.addTarget(self, action: "segmentAction:", forControlEvents: .ValueChanged)
  
        let frame = UIScreen.mainScreen().bounds
        mySegment.frame = CGRectMake(viewHeader.frame.minX, viewHeader.frame.maxY - (viewHeader.frame.height*0.15) ,
            frame.width , viewHeader.frame.height*0.15)
       
        mySegment.layer.cornerRadius = 5.0  // Don't let background bleed
        
        
        mySegment.backgroundColor =  colorSegmentBackground
        mySegment.tintColor = colorSegmentTint
      

    }

    
    func getFetchedResultControllerDaily() -> NSFetchedResultsController {
        fetchedResultControllerDaily = NSFetchedResultsController(fetchRequest: taskFetchRequestDaily(), managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultControllerDaily
    }
    
    func taskFetchRequestDaily() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "CigaretteRecord")
        //fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
        let sortDescriptor = NSSortDescriptor(key: "cigarettes", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // #pragma mark - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        let numberOfSections = fetchedResultControllerDaily.sections?.count
        return numberOfSections!
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRowsInSection: Int!// = fetchedResultController.sections?[section].numberOfObjects
        
        switch segment {
        case 0:
             numberOfRowsInSection = fetchedResultControllerDaily.sections?[section].numberOfObjects
        case 1:
             numberOfRowsInSection = sortedKeysResultsMonthly.count
        case 2:
             numberOfRowsInSection = sortedKeysResultsYearly.count
        default:
            numberOfRowsInSection = 0
        }
        
        return numberOfRowsInSection
        
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell!
        var textLable:String=""
        
        switch segment {
            case 0:
                
                cell = tableView.dequeueReusableCellWithIdentifier("CellDaily", forIndexPath: indexPath) 
                
                let task = fetchedResultControllerDaily.objectAtIndexPath(indexPath) as! CigaretteRecord
                let s:String = task.yearMonth()
                print(s)
                cell.textLabel?.text = task.cigarettes.stringValue + "; " + task.levelAsNeeded.stringValue + "; CellDaily " + getStringDate(task.addDate) + " " + s
                
            case 1:
                
                cell = tableView.dequeueReusableCellWithIdentifier("CellMonthly", forIndexPath: indexPath) 
               
                let yearMonth:String = sortedKeysResultsMonthly[indexPath.row] as! String
                
                if let cigsSum: NSNumber! = fetchDictResultsMonthly[yearMonth]{
                    
                    
                    textLable = String(format:"%.1f", cigsSum!.doubleValue * averageCostOfOneCigarette)
                    
                    textLable = yearMonth + " sigs: " + cigsSum!.stringValue + " Cost: " + textLable

                }
                
                cell.textLabel!.text = textLable
            
            
            case 2:
                cell = tableView.dequeueReusableCellWithIdentifier("CellYearly", forIndexPath: indexPath) 
                
                let year:String = sortedKeysResultsYearly[indexPath.row] as! String
                
                if let cigsSum: NSNumber! = fetchDictResultsYearly[year]{
                    
                    
                    textLable = String(format:"%.1f", cigsSum!.doubleValue * averageCostOfOneCigarette)
                    
                    textLable = year + " sigs: " + cigsSum!.stringValue + " Cost: " + textLable

                }
                
                cell.textLabel!.text = textLable
            default:
                break
            }
            print(segment)
            
        
      //  }
        return cell
    }
    
    
    
    func getStringDate(dDate: NSDate)->String
    {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy HH:mm"
            return dateFormatter.stringFromDate(dDate)

    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let managedObject:NSManagedObject = fetchedResultControllerDaily.objectAtIndexPath(indexPath) as! NSManagedObject
        managedObjectContext?.deleteObject(managedObject)
        do {
            try managedObjectContext?.save()
            managedObjectContext?.reset()
        } catch _ {
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.reloadData()
    }
    
    func segmentAction(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            segment = 0
        case 1:
            segment = 1
        case 2:
            segment = 2
        default:
            break
        }
        print(segment)

        tableView.reloadData()
    }

}
