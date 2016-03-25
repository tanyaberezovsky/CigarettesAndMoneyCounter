//
//  layoutSubviewsButton.swift
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 25/03/2016.
//  Copyright © 2016 Tania Berezovski. All rights reserved.
//

import UIKit

class layoutSubviewsButton: UIButton {
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        let imageFrame = self.imageView?.frame;
        
//        let inset: CGFloat = 13
        
        if var imageFrame = imageFrame
        {
                imageFrame.origin.x = self.frame.origin.x + self.frame.width - imageFrame.width - (imageFrame.width/2) // - inset
                
                self.imageView?.frame = imageFrame
                
            
        }
    }
}
