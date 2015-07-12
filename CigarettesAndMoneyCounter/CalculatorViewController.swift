//
//  CalculatorViewController.swift
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 7/12/15.
//  Copyright (c) 2015 Tania Berezovski. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {

    @IBOutlet weak var ciggarets: UITextField!
    @IBOutlet weak var packCost: UITextField!
    
    @IBAction func segmentChanged(sender: UISegmentedControl) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadDefaultValues()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //++++++++++++++++++++++++++++++++++++
    //  Load Default Values from controller
    //++++++++++++++++++++++++++++++++++++
    func LoadDefaultValues(){
        var defaults = UserDefaultsDataController()
        var userDefaults = UserDefaults()
        userDefaults = defaults.loadUserDefaults()
        
       ciggarets.text = String(userDefaults.dailyGoal)
        
       packCost.text = String(stringInterpolationSegment: userDefaults.averageCostOfOnePack)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
