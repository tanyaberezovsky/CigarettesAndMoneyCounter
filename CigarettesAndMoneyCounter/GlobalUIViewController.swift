//
//  GlobalUIViewController.swift
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 27/02/2016.
//  Copyright © 2016 Tania Berezovski. All rights reserved.
//

import UIKit

class GlobalUIViewController: UIViewController {
 
  

    //gradient bar
    override func viewDidLoad() {
        super.viewDidLoad()
        gradientBackgroundRegular()
        
    }
    
    func gradientBackgroundRegular() {
        self.view.backgroundColor = UIColor.clear
        let gradient : CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        
        
        gradient.colors = ColorTemplates.purpleGrayCGColor()
        
        view.layer.insertSublayer(gradient, at: 0)
    }
    
}
