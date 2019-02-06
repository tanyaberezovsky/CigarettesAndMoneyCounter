//
//  LightMainSceneViewController.swift
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 9/13/15.
//  Copyright (c) 2015 Tania Berezovski. All rights reserved.
//

import UIKit
import CoreData
import ENSwiftSideMenu

@IBDesignable
class LightMainSceneViewController: GlobalUIViewController, UIPopoverPresentationControllerDelegate, popOverControllerDelegate, question1ViewControllerDelegate, TableLevelsControllerDelegate, ENSideMenuDelegate {

    
    @IBOutlet weak var txtLastCig: UILabel!
    
    @IBOutlet weak var circularLoader: CircularLoaderView!
    
    @IBOutlet weak var addSmoke: UIButton!
    
    @IBOutlet weak var dailySmokedCigs: UILabel!
    
    fileprivate let defaults:UserDefaultsDataController = UserDefaultsDataController.sharedInstance
    
    
    override func viewDidLoad() {
        showQuestion1(defaults.loadUserDefaults())
            
        super.viewDidLoad()
        
         let swipeGestureRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(LightMainSceneViewController.showSecondViewController))
 
        swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirection.up
        self.view.addGestureRecognizer(swipeGestureRecognizer)
        
        self.sideMenuController()?.sideMenu?.delegate = self

    }
    
    @IBAction func addCigarettes(_ sender: AnyObject) {
   
       
    }
    
    //MARK: menu pizza clik
    @IBAction func MenuClick(_ sender: UIBarButtonItem) {
        toggleSideMenuView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       // menu!.hideSideMenu()
        hideSideMenuView()
    }
    
    
    /*
    delegated function from dataReloadAfterSave
    called while pressinf save button in defautls settings screen    */
    func dataReloadAfterSave(){
        LoadDefaultValues()
    }
  
    override func  viewDidAppear(_ animated: Bool) {
        roundButtonConers()
        LoadDefaultValues()

    }
    
    
    //++++++++++++++++++++++++++++++++++++
    //  Load Default Values from controller
    //++++++++++++++++++++++++++++++++++++
    func LoadDefaultValues(){
       // let defaults:UserDefaultsDataController = UserDefaultsDataController.sharedInstance
        let userDefaults:UserDefaults = defaults.loadUserDefaults()
        
        var todaySmoked = 0

        if let lastCig = userDefaults.dateLastCig{
            let calcRet = calculateLastCigaretTime(lastCig)
            txtLastCig.text = calcRet.txtLastCig
            if calcRet.bLastCigWasToday == true{
                todaySmoked = userDefaults.todaySmoked
            }
 
        }
        else{
            txtLastCig.text = "TIME SINCE LAST CIGARETTE"// "How long has it been since last cigarette"//"Do not smoke at all"  "Free of smoking time"
        }
            dailySmokedCigs.attributedText = dailySmokedToText(Int(todaySmoked), limit: userDefaults.dailyGoal)
            
        roundButtonConers()
      
        if let lastCig = userDefaults.dateLastCig{
            if(Calendar.current.isDateInToday(lastCig as Date)){
                loadCircularLoader(userDefaults.todaySmoked, dailyLimit: userDefaults.dailyGoal)
            }
        }
        
         circularLoader.setNeedsDisplay()
    }

    
    func dailySmokedToText(_ totalSigs: Int, limit: Int) -> NSMutableAttributedString{
        var myMutableString = NSMutableAttributedString()
        
        let remainder: Int = limit - totalSigs > 0 ? limit - totalSigs: 0

        
        
        myMutableString = NSMutableAttributedString(string: String(format: "    %d/ %d", totalSigs, remainder))
        
        
        
        myMutableString.addAttribute(NSFontAttributeName,
                                     value: UIFont.systemFont(ofSize: 13.0),
                                     range: NSRange(location: 0, length: 4))
        
        myMutableString.addAttribute(NSFontAttributeName,
                                     value: UIFont.systemFont(ofSize: 13.0),
                                     range: NSRange(location:String(totalSigs).characters.count+4, length: String(remainder).characters.count+2))
        return myMutableString;
    }
    
    
    func loadCircularLoader(_ todaySmoked: Int, dailyLimit: Int)
    {
        if(todaySmoked>0){
        let circileAngle: Double = Double(todaySmoked) / Double(dailyLimit) * 100;
        
        circularLoader.toValue = CGFloat( circileAngle);
        }

    
    }
    
    
    func roundButtonConers(){
       // addSmoke.backgroundColor = UIColor.clearColor()
        addSmoke.layer.cornerRadius = addSmoke.layer.bounds.height / 2
        addSmoke.layer.borderWidth = 1
        addSmoke.layer.borderColor = addSmoke.backgroundColor?.cgColor
    }
    
        override func viewWillAppear(_ animated: Bool) {
            if self.childViewControllers.count > 0 {

            let secondVC: AnyObject = childViewControllers[0]
                 let navCtr  = self.navigationController as UINavigationController!
            //
            //
                navCtr?.pushViewController(secondVC as! UIViewController, animated: false)
            }
           // LoadDefaultValues()
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showSecondViewController() {
        self.performSegue(withIdentifier: "idFirstSegue", sender: self)
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        hideSideMenuView()
        
        if segue.identifier == "showMenu" {
            let popOverVC = segue.destination
            popOverVC.modalPresentationStyle = UIModalPresentationStyle.popover
            popOverVC.popoverPresentationController!.delegate = self
        }
        
        
        
        if segue.identifier == "showPopForm"{
            
            let popOverVC = segue.destination as! popOverViewController
            popOverVC.myDelegate = self
            
            popOverVC.modalPresentationStyle = UIModalPresentationStyle.popover
            
            popOverVC.view.isOpaque = false;
            popOverVC.view.alpha = 0.9;
            
            
            
            popOverVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
            
            if let pop = popOverVC.popoverPresentationController {
                
                var passthroughViews: [UIView]?
                passthroughViews = [self.view]
                
                
                pop.permittedArrowDirections = .any
                //    pop.sourceView = myButton
                pop.passthroughViews = passthroughViews
                
                pop.delegate = self
                
                
                pop.sourceRect = CGRect(
                    x: 0,
                    y: 0 + addSmoke.layer.bounds.height + 15,
                    width: view.frame.width,
                    height: 250)
                
                popOverVC.preferredContentSize = CGSize(width: view.frame.width, height: 250)
            
            }
           
        }
    
    }


      
     func showQuestion1(_ userDefaults:UserDefaults) {
        
        if userDefaults.showQuestion1 == true {
            
                
                let popOverVC = storyboard!.instantiateViewController(withIdentifier: "question1ViewController") as! question1ViewController
        
                popOverVC.myDelegateQ1 = self
                
                popOverVC.view.isOpaque = false;
                popOverVC.view.alpha = 1//0.9;
            
        
                popOverVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        
                present(popOverVC, animated: true, completion: nil)
                
                userDefaults.showQuestion1 = false
                defaults.saveUserDefaults(userDefaults)
                
          }
        
        return
     
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
 
    
    @IBAction func returnFromSegueActions(_ sender: UIStoryboardSegue){
        circularLoader.setNeedsDisplay()
    }
    
 
    
    /*
    delegated function from TableLavels.swift
    received selected row value from TableLevels and set it to apropriate field
    */
    func myColumnDidSelected(_ controller: TableLavels, text: String, segueName: String) {
        
        self.performSegue(withIdentifier: "showPopForm", sender: self)
        
        _ = controller.navigationController?.popViewController(animated: true)
     }

}
