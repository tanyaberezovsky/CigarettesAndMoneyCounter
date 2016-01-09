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
    
    @IBOutlet weak var navigationHeader: UINavigationItem!
    
    var myDelegate:TableLevelsControllerDelegate? = nil
    
    
    var segueSourceName: String?
  
    var dataList: selectionList!
    
    @IBOutlet var tblLevels: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.estimatedRowHeight = 68.0
        tableView.rowHeight = UITableViewAutomaticDimension
        initView()
        navigationHeader.title = dataList?.title
        //tableView.scrollEnabled = true

    }
    
    func initView(){
     /*   switch  segueSourceName!{
        case segueNames.segueLvlOfNeeded:
            dataList = neededList()
        case segueNames.segueLvlOfEnjoy:
            dataList = enjoyedList()
        default:
            dataList = causeList()
        }*/
         dataList = causeList()
    }
    
/*  init()
    { eshlej medison
        dataList = selectionList()
    }*/

  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func  tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList!.rowCount()
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyTestCell")
        
        //we know that cell is not empty now so we use ! to force unwrapping
       
        cell.textLabel!.text = dataList.text(indexPath.row)
        cell.detailTextLabel!.text = dataList.detailText(indexPath.row);

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let levelSelected = dataList.textValue(indexPath.row)  //+ " " + dataList.detailText(indexPath.row)//levels[indexPath.row].nameNum
        
      //  println("You selected level is #\(levelSelected)!")
//var details =        dataList.detailText(indexPath.row)
        
        if(myDelegate != nil){
            myDelegate!.myColumnDidSelected(self, text: levelSelected,segueName: segueSourceName!)
        }
        
    }
    
}


protocol TableLevelsControllerDelegate{
    func myColumnDidSelected(controller:TableLavels,text:String, segueName:String)
}
