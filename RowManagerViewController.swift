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
        averageCostOfOneCigarette = userDefaults.averageCostOfOnePack / 20
      
        fetchedResultControllerDaily = getFetchedResultControllerDaily()
        fetchedResultControllerDaily.delegate = self
        fetchedResultControllerDaily.performFetch(nil)
        
        fetchDictResultsMonthly = Dictionary()
        fetchDictResultsYearly = Dictionary()
        var selection=0
        if let objCount = fetchedResultControllerDaily.sections?[selection].numberOfObjects{
            
            for var index=0; index < objCount - 1; index++
            {
                var ind = NSIndexPath(forRow: index, inSection: selection)
                let task = fetchedResultControllerDaily.objectAtIndexPath(ind) as! CigaretteRecord
                var yearMonth:String = task.yearMonth()
                
                if let cigsSum = fetchDictResultsMonthly[yearMonth]{
                    
                    var calculatedSum:NSNumber = NSNumber()
                    
                        calculatedSum = cigsSum.integerValue + task.cigarettes.integerValue  as NSNumber
                    
                    fetchDictResultsMonthly.updateValue(calculatedSum, forKey: yearMonth)
                    
                } else {
                    fetchDictResultsMonthly[yearMonth] = task.cigarettes
                }
                
                var year:String = task.year()
                
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

        var mySegment = UISegmentedControl(items: ["Daily","Monthly", "Yearly"])
     
        viewHeader.addSubview(mySegment)
//        self.tableView.tableHeaderView = mySegment
        mySegment.selectedSegmentIndex = 0
        mySegment.addTarget(self, action: "segmentAction:", forControlEvents: .ValueChanged)

        
        let items = ["Purple", "Green", "Blue"]
        let customSC = UISegmentedControl(items: items)
        customSC.selectedSegmentIndex = 0
        
        // Set up Frame and SegmentedControl
        let frame = UIScreen.mainScreen().bounds
        customSC.frame = CGRectMake(viewHeader.frame.minX, viewHeader.frame.maxY - (viewHeader.frame.height*0.15) ,
            frame.width , viewHeader.frame.height*0.15)
        
        // Style the Segmented Control
        customSC.layer.cornerRadius = 5.0  // Don't let background bleed
        customSC.backgroundColor = UIColor.blackColor()
        customSC.tintColor = UIColor.whiteColor()
        
        // Add target action method
        customSC.addTarget(self, action: "changeColor:", forControlEvents: .ValueChanged)
        
        // Add this custom Segmented Control to our view
        viewHeader.addSubview(customSC)

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
                
                cell = tableView.dequeueReusableCellWithIdentifier("CellDaily", forIndexPath: indexPath) as! UITableViewCell
                
                let task = fetchedResultControllerDaily.objectAtIndexPath(indexPath) as! CigaretteRecord
                var s:String = task.yearMonth()
                println(s)
                cell.textLabel?.text = task.cigarettes.stringValue + "; " + task.levelAsNeeded.stringValue + "; CellDaily " + getStringDate(task.addDate) + " " + s
                
            case 1:
                
                cell = tableView.dequeueReusableCellWithIdentifier("CellMonthly", forIndexPath: indexPath) as! UITableViewCell
               
                var yearMonth:String = sortedKeysResultsMonthly[indexPath.row] as! String
                
                if let cigsSum: NSNumber! = fetchDictResultsMonthly[yearMonth]{
                    
                    
                    textLable = String(format:"%.1f", cigsSum!.doubleValue * averageCostOfOneCigarette)
                    
                    textLable = yearMonth + " sigs: " + cigsSum!.stringValue + " Cost: " + textLable

                }
                
                cell.textLabel!.text = textLable
            
            
            case 2:
                cell = tableView.dequeueReusableCellWithIdentifier("CellYearly", forIndexPath: indexPath) as! UITableViewCell
                
                var year:String = sortedKeysResultsYearly[indexPath.row] as! String
                
                if let cigsSum: NSNumber! = fetchDictResultsYearly[year]{
                    
                    
                    textLable = String(format:"%.1f", cigsSum!.doubleValue * averageCostOfOneCigarette)
                    
                    textLable = year + " sigs: " + cigsSum!.stringValue + " Cost: " + textLable

                }
                
                cell.textLabel!.text = textLable
            default:
                break
            }
            println(segment)
            
        
      //  }
        return cell
    }
    
    
    
    func getStringDate(dDate: NSDate)->String
    {
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm"
        return dateFormatter.stringFromDate(dDate)
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let managedObject:NSManagedObject = fetchedResultControllerDaily.objectAtIndexPath(indexPath) as! NSManagedObject
        managedObjectContext?.deleteObject(managedObject)
        managedObjectContext?.save(nil)
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
        println(segment)

        tableView.reloadData()
    }

}

   /* let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    
    var fetchedResultController: NSFetchedResultsController = NSFetchedResultsController()

    func getFetchedResultController() -> NSFetchedResultsController {
        fetchedResultController = NSFetchedResultsController(fetchRequest: taskFetchRequest(), managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultController
    }

    func taskFetchRequest() -> NSFetchRequest {
        var fReq: NSFetchRequest = NSFetchRequest(entityName: "CigaretteRecord")
        
        let fetchRequest = NSFetchRequest(entityName: "CigaretteRecord")
        let sortDescriptor = NSSortDescriptor(key: "addDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchedResultController = getFetchedResultController()
        fetchedResultController.delegate = self
        fetchedResultController.performFetch(nil)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 0
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        let numberOfSections = fetchedResultController.sections?.count
        return numberOfSections!
    }
    
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1//fetchedResultController.sections.count
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {  return fetchedResultController.sections[
}

override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
    return fetchedResultController.sections[section].numberOfObjects
}

override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell? {
    var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
    let task = fetchedResultController.objectAtIndexPath(indexPath) as Tasks
    cell.textLabel.text = task.desc
    return cell
}

func controllerDidChangeContent(controller: NSFetchedResultsController!) {
    tableView.reloadData()
}

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}*/
