//
//  NavViewController.swift
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 7/4/15.
//  Copyright (c) 2015 Tania Berezovski. All rights reserved.
//

import UIKit

class NavViewController: UINavigationController {

    override func viewDidLoad() {
        
        let red = 24 / 255
        let green = 25 / 255
        let blue = 35 / 255
        let alpha: Double = 1.0
        var color: UIColor = UIColor( red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha:CGFloat(alpha) )
        
        UINavigationBar.appearance().barTintColor = color
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
