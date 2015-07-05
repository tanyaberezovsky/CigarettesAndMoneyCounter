//
//  TableLevels.swift
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 9/26/14.
//  Copyright (c) 2014 Tania Berezovski. All rights reserved.
//

//import Foundation


import UIKit

class TableLavels: UITableViewController{
    
    var myDelegate:TableLevelsControllerDelegate? = nil
    
    var levels = [Levels]()
    
    var segueSourceName: String?
    
    @IBOutlet var tblLevels: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        levels = [Levels(nameLvl:"level 0", nameNum: "0"),Levels(nameLvl:"level 1", nameNum: "1"),Levels(nameLvl:"level 2", nameNum: "2"),Levels(nameLvl:"level 3", nameNum: "3"),Levels(nameLvl:"level 4", nameNum: "4")]
        tableView.estimatedRowHeight = 68.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func  tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.levels.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
        var lvl: Levels
        
        lvl = levels[indexPath.row]
        
        cell.textLabel?.text = lvl.nameLvl
        
        return cell
    }
    

    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var levelSelected = levels[indexPath.row].nameNum
        
      //  println("You selected level is #\(levelSelected)!")
        
        if(myDelegate != nil){
            myDelegate!.myColumnDidSelected(self, text: levelSelected,segueName: segueSourceName!)
        }
        
    }
    
}


protocol TableLevelsControllerDelegate{
    func myColumnDidSelected(controller:TableLavels,text:String, segueName:String)
}
