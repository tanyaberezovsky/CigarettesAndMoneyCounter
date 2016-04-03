//
//  layoutSubviewsButtonArrow.swift
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 01/04/2016.
//  Copyright © 2016 Tania Berezovski. All rights reserved.
//

import UIKit

class layoutSubviewsButtonArrow: UIButton {
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        let imageFrame = self.imageView?.frame;
       
        let inset: CGFloat = 2
        
        if var imageFrame = imageFrame
        {
            
            imageFrame.origin.x =  self.frame.width - imageFrame.width - inset
            
            self.imageView?.frame = imageFrame
            
            
        }
    }

}
