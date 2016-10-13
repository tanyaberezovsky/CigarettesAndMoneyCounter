//
//  TableLevels.swift
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 9/26/14.
//  Copyright (c) 2014 Tania Berezovski. All rights reserved.
//



import UIKit
import CoreData

class TableLavels: UITableViewController, NSFetchedResultsControllerDelegate {
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    
    lazy var reasons : NSFetchedResultsController<Reasons> = {
   
         let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Reasons")
        
        request.sortDescriptors = [NSSortDescriptor(key: "reason", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))]

        let reasons = NSFetchedResultsController<Reasons>(fetchRequest: request as! NSFetchRequest<Reasons>, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        reasons.delegate = self
            
        
        return reasons
      
    }()
    
    @IBOutlet weak var navigationHeader: UINavigationItem!
    
    var myDelegate:TableLevelsControllerDelegate? = nil
    
    
    var segueSourceName: String?
  
    
    @IBOutlet var tblLevels: UITableView!
    
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        do {
            try reasons.performFetch()
        } catch let error as NSError {
            print("Error fetching data \(error)")
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.estimatedRowHeight = 68.0
        tableView.rowHeight = UITableViewAutomaticDimension
 
    }
    
    func initView(){
    }
  
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var levelSelected = String()
        if let objects = reasons.fetchedObjects
        {
            
            levelSelected = ((objects[(indexPath as NSIndexPath).row] as Reasons).reason)!
        }

        
        if(myDelegate != nil){

            myDelegate!.myColumnDidSelected(self, text: levelSelected,segueName: segueSourceName!)
        
        }
        else{
            
            if presentingViewController is popOverViewController
            {
                let vc = self.presentingViewController
                     as? popOverViewController
                vc!.causeOfSmoking.setTitle(levelSelected, for: UIControlState())
                
            }
            self.dismiss(animated: false, completion: nil)

        }
        
    }
 
  
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       /* let objects = reasons.fetchedObjects
        return objects?.count ?? 0*/
        if let sections = reasons.sections {
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }
        
        return 0

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "reasonCellId", for: indexPath) as? ReasonsTableViewCell {
            if let objects = reasons.fetchedObjects
            {
                cell.reason = objects[(indexPath as NSIndexPath).row] as Reasons
            }
            return cell
        }
        return UITableViewCell()
    }
    
    
    //////////////////          UIAlertController   area
    var tField: UITextField!
    
    func configurationTextField(_ textField: UITextField!)
    {
        textField.placeholder = "Enter an item"
        tField = textField
    }
    
    func handleCancel(_ alertView: UIAlertAction!)
    {
    }
    
    @IBAction func addNewReasonBottonClick(_ sender: UIBarButtonItem) {
            let alert = UIAlertController(title: "Enter reason", message: "", preferredStyle: .alert)
            let reasonsManager = ReasonsManager()
        
            alert.addTextField(configurationHandler: configurationTextField)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:handleCancel))
            alert.addAction(UIAlertAction(title: "Add", style: .default, handler:{ (UIAlertAction) in
             print("Item : \(self.tField.text)")
                reasonsManager.saveReason(self.tField.text!)
                do {
                    try self.reasons.performFetch()
                } catch let error as NSError {
                    print("Error fetching data \(error)")
                }
                self.tableView.reloadData()

            }))
            self.present(alert, animated: true, completion: {
            print("completion block")
            })
    }

    //////////////////          end UIAlertController area
    @IBAction func BackButtonClick(_ sender: UIBarButtonItem) {
        if(myDelegate != nil){
            
            myDelegate!.myColumnDidSelected(self, text: "",segueName: segueSourceName!)
            
        }
        else{
            self.dismiss(animated: false, completion: nil)
        }
    }
    
}


protocol TableLevelsControllerDelegate{
    func myColumnDidSelected(_ controller:TableLavels,text:String, segueName:String)
}
