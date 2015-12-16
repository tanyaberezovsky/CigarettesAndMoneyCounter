//
//  LightMainSceneViewController.swift
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 9/13/15.
//  Copyright (c) 2015 Tania Berezovski. All rights reserved.
//

import UIKit
import CoreData


class LightMainSceneViewController: UIViewController {

    @IBOutlet weak var txtLastCig: UILabel!
    
    
    
    @IBOutlet weak var dailySmokedCigs: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let swipeGestureRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "showSecondViewController")
        swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirection.Up
        self.view.addGestureRecognizer(swipeGestureRecognizer)
        //LoadDefaultValues()
    }
    
    @IBAction func addCigarettes(sender: AnyObject) {
        
        let cigRecord = CigaretteRecordManager()
        cigRecord.saveCigaretteRecordEntityFromDefaultsValues()
        
        // loadInitiatedValues()
        LoadDefaultValues()
    }
    
    override func  viewDidAppear(animated: Bool) {
        LoadDefaultValues()
    }
    
    
    //++++++++++++++++++++++++++++++++++++
    //  Load Default Values from controller
    //++++++++++++++++++++++++++++++++++++
    func LoadDefaultValues(){
        let defaults = UserDefaultsDataController()
        var userDefaults = UserDefaults()
        userDefaults = defaults.loadUserDefaults()
        
        var todaySmoked = 0

        if let lastCig = userDefaults.dateLastCig{
            let calcRet = calculateLastCigaretTime(lastCig)
            txtLastCig.text = calcRet.txtLastCig
            if calcRet.bLastCigWasToday == true{
                todaySmoked = userDefaults.todaySmoked
            }
 
        }
        else{
            txtLastCig.text = "How long has it been since last cigarette"//"Free of smoking time"
        }
        dailySmokedCigs.text = String(Int(todaySmoked))

    }

    
    
        override func viewWillAppear(animated: Bool) {
            if self.childViewControllers.count > 0 {

            let secondVC: AnyObject = childViewControllers[0]
                 let navCtr  = self.navigationController as UINavigationController!
            //
            //
                navCtr.pushViewController(secondVC as! UIViewController, animated: false)
            }
        }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showSecondViewController() {
        self.performSegueWithIdentifier("idFirstSegue", sender: self)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func returnFromSegueActions(sender: UIStoryboardSegue){
//        if sender.identifier == "idFirstSegueUnwind" {
//            let originalColor = self.view.backgroundColor
//            self.view.backgroundColor = UIColor.redColor()
//            
//            UIView.animateWithDuration(1.0, animations: { () -> Void in
//                self.view.backgroundColor = originalColor
//            })
//        }
    }
    
   /* override func segueForUnwindingToViewController(toViewController: UIViewController, fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue {
        if let id = identifier{
            if id == "idFirstSegueUnwind" {
                let unwindSegue = FirstCustomSegueUnwind(identifier: id, source: fromViewController, destination: toViewController, performHandler: { () -> Void in
                    
                })
                return unwindSegue
            }
        }
        
        return super.segueForUnwindingToViewController(toViewController, fromViewController: fromViewController, identifier: identifier)
    }
    */
}
