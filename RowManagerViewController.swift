//
//  RowManagerViewController.swift
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 1/2/15.
//  Copyright (c) 2015 Tania Berezovski. All rights reserved.
//

import UIKit
import CoreData

//not in use now
class RowManagerViewController: UITableViewController,NSFetchedResultsControllerDelegate {
    
    var segment = 0

    @IBOutlet weak var viewHeader: UIView!
    
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    
    
    
    var fetchedResultControllerDaily: NSFetchedResultsController<CigaretteRecord> = NSFetchedResultsController<CigaretteRecord>()
    
    var fetchedResultControllerMonthly:  NSFetchedResultsController<CigaretteRecord> = NSFetchedResultsController<CigaretteRecord>()
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
            
            for index in 0..<objCount - 1
            {
                    let ind = IndexPath(row: index, section: selection)
                let task = fetchedResultControllerDaily.object(at: ind) 
                let yearMonth:String = task.yearMonth()
                
                if let cigsSum = fetchDictResultsMonthly[yearMonth]{
                    
                    var calculatedSum:NSNumber = NSNumber()
                    
                        calculatedSum = cigsSum.intValue + task.cigarettes.intValue  as NSNumber
                    
                    fetchDictResultsMonthly.updateValue(calculatedSum, forKey: yearMonth)
                    
                } else {
                    fetchDictResultsMonthly[yearMonth] = task.cigarettes
                }
                
                let year:String = task.year()
                
                if let cigsSum = fetchDictResultsYearly[year]{
                    
                    var calculatedSum:NSNumber = NSNumber()
                    
                    calculatedSum = cigsSum.intValue + task.cigarettes.intValue  as NSNumber
                    
                    fetchDictResultsYearly.updateValue(calculatedSum, forKey: year)
                    
                } else {
                    fetchDictResultsYearly[year] = task.cigarettes
                }
            }
        }
        sortedKeysResultsMonthly = Array(fetchDictResultsMonthly.keys) as NSArray!
        sortedKeysResultsYearly = Array(fetchDictResultsYearly.keys) as NSArray!
        
        creteSegmentOnHeader()
    
    }
    
    func creteSegmentOnHeader()
    {
        
        let screenSize:CGRect = UIScreen.main.bounds
        viewHeader.frame.size.height = screenSize.height * 0.30

        let mySegment = UISegmentedControl(items: ["Daily","Monthly", "Yearly"])
     
        viewHeader.addSubview(mySegment)
        mySegment.selectedSegmentIndex = 0

         mySegment.addTarget(self, action: #selector(RowManagerViewController.segmentAction(_:)), for: .valueChanged)

        let frame = UIScreen.main.bounds
        mySegment.frame = CGRect(x: viewHeader.frame.minX, y: viewHeader.frame.maxY - (viewHeader.frame.height*0.15) ,
            width: frame.width , height: viewHeader.frame.height*0.15)
       
        mySegment.layer.cornerRadius = 5.0
        
        mySegment.backgroundColor =  colorSegmentBackground
        mySegment.tintColor = colorSegmentTint
      

    }

  
    func getFetchedResultControllerDaily() -> NSFetchedResultsController<CigaretteRecord> {
        fetchedResultControllerDaily = NSFetchedResultsController<CigaretteRecord>(fetchRequest: taskFetchRequestDaily()  , managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultControllerDaily
    }
    
    func taskFetchRequestDaily() -> NSFetchRequest<CigaretteRecord> {
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CigaretteRecord")
        let sortDescriptor = NSSortDescriptor(key: "cigarettes", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest as! NSFetchRequest<CigaretteRecord>
    }
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // #pragma mark - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        let numberOfSections = fetchedResultControllerDaily.sections?.count
        return numberOfSections!
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRowsInSection: Int!
        
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
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell!
        var textLable:String=""
        
        switch segment {
            case 0:
                
                cell = tableView.dequeueReusableCell(withIdentifier: "CellDaily", for: indexPath) 
                
                let task = fetchedResultControllerDaily.object(at: indexPath)
                let s:String = task.yearMonth()
                //print(s)
                cell.textLabel?.text = task.cigarettes.stringValue + "; " + task.levelAsNeeded.stringValue + "; CellDaily " + getStringDate(task.addDate) + " " + s
                
            case 1:
                
                cell = tableView.dequeueReusableCell(withIdentifier: "CellMonthly", for: indexPath) 
               
                let yearMonth:String = sortedKeysResultsMonthly[(indexPath as NSIndexPath).row] as! String
                
                if let cigsSum: NSNumber = fetchDictResultsMonthly[yearMonth]{
                    
                    
                    textLable = String(format:"%.1f", cigsSum.doubleValue * averageCostOfOneCigarette)
                    
                    textLable = yearMonth + " sigs: " + cigsSum.stringValue + " Cost: " + textLable

                }
                
                cell.textLabel!.text = textLable
            
            
            case 2:
                cell = tableView.dequeueReusableCell(withIdentifier: "CellYearly", for: indexPath) 
                
                let year:String = sortedKeysResultsYearly[(indexPath as NSIndexPath).row] as! String
                
                if let cigsSum: NSNumber = fetchDictResultsYearly[year]{
                    
                    
                    textLable = String(format:"%.1f", cigsSum.doubleValue * averageCostOfOneCigarette)
                    
                    textLable = year + " sigs: " + cigsSum.stringValue + " Cost: " + textLable

                }
                
                cell.textLabel!.text = textLable
            default:
                break
            }
        
        return cell
    }
    
    
    
    func getStringDate(_ dDate: Date)->String
    {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy HH:mm"
            return dateFormatter.string(from: dDate)

    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let managedObject:NSManagedObject = fetchedResultControllerDaily.object(at: indexPath) as NSManagedObject
        managedObjectContext?.delete(managedObject)
        do {
            try managedObjectContext?.save()
            managedObjectContext?.reset()
        } catch _ {
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
    
    func segmentAction(_ sender: UISegmentedControl) {
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

        tableView.reloadData()
    }

}
