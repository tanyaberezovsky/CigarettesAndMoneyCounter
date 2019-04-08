//
//  MyMenuTableViewController.swift
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 01/11/2016.
//  Copyright © 2016 Tania Berezovski. All rights reserved.
//


import UIKit

class MyMenuTableViewController: UITableViewController {
    var selectedMenuItem : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customize apperance of table view
        tableView.contentInset = UIEdgeInsets(top: 64.0, left: 0, bottom: 0, right: 0) //
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        tableView.scrollsToTop = false
        
        // Preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
       // let index:IndexPath = IndexPath(row: selectedMenuItem, section: 0)
       // tableView.selectRow(at: index, animated: false, scrollPosition: .middle)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
   override func numberOfSections(in tableView: UITableView) -> Int {
         // Return the number of sections.
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "CELL")
        
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "CELL")
            cell!.backgroundColor = UIColor.clear
            cell!.textLabel?.textColor = UIColor.white
            let menuFrame = CGRect(
                x: 0,
                y: 0,
                width:  cell!.frame.size.width,
                height: cell!.frame.size.height
            )
            let selectedBackgroundView = UIView(frame:   menuFrame)
           
            selectedBackgroundView.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
            cell!.selectedBackgroundView = selectedBackgroundView
        }
        
        cell!.textLabel?.text = "   " + menuTitle(ind: indexPath.row)
        
        return cell!
    }
    
    
    func menuTitle(ind: Int) -> String{
        var title = String()
        switch ind {
        case 0:
            title = "Calculator"
        case 1:
            title = "Settings"
        default:
            title = "About"
        }
        return title
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        print("did select row: \(indexPath.row)")
        
        if (indexPath.row == selectedMenuItem) {
      //      return
        }
        
        selectedMenuItem = indexPath.row
        
        //Present new view controller
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        var destViewController : UIViewController
        switch (indexPath.row) {
        case 0:
            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "CalculatorViewController") as! CalculatorViewController
            break
        case 1:
            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "UserDefaultsController") as! UserDefaultsController
            break
        default:
            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "AboutViewController")
            break
        }
       // destViewController.navigationItem.hidesBackButton = false
       // let backItem = UIBarButtonItem()
        //backItem.title = "Something Else"
        //self.parent!.navigationItem.backBarButtonItem = backItem
        sideMenuController()?.setContentViewController(destViewController)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
}
