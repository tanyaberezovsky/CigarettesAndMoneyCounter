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
        self.view.backgroundColor = UIColor.clearColor()
        let gradient : CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        
        
        let colors:ColorTemplates = ColorTemplates();
        gradient.colors = colors.purpleGray()
        
        view.layer.insertSublayer(gradient, atIndex: 0)
    }
    
    /*
    override func viewWillLayoutSubviews() {
      /*  for family: String in UIFont.familyNames()
        {
            print("\(family)")
            for names: String in UIFont.fontNamesForFamilyName(family)
            {
                print("== \(names)")
            }
        }
*/
        
        for view in self.view.subviews  {
            
          /*  if let txt = view as? UITextField {
                txt.font.style
                UIFont.sys
                txt.font = UIFont(name: systemFont, size: txt.font?.pointSize)!
            }
            if let lbl = view as? UILabel {
                lbl.font?.pointSize
            }
            if view.isKindOfClass(UITextField) {
                UITextField txt = view as UITextField
                
                UITextField.appearance().font =  UIFont(name: "Copperplate", size: view.app)
            }
             
             if view.isKindOfClass(UILabel) {
             UILabel.appearance().font =  UIFont(name: "Copperplate", size: 20)
             }
 */
            if let lbl = view as? UILabel {
                print("== \( lbl.font?.fontName)")

            }
        }
    }*/

}
