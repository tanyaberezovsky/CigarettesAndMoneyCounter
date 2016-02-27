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
        let gradient : CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        
        
        let colors:ColorTemplates = ColorTemplates();
        gradient.colors = colors.purpleGray()
        
        view.layer.insertSublayer(gradient, atIndex: 0)
    }
    
}
