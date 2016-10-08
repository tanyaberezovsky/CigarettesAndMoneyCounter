//
//  layoutSubviewsButton.swift
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 25/03/2016.
//  Copyright © 2016 Tania Berezovski. All rights reserved.
//

import UIKit

class layoutSubviewsButton: UIButton {
  //  override func wi
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        let imageFrame = self.imageView?.frame;
        
       let inset: CGFloat = 13
        
        if var imageFrame = imageFrame
        {
             //   imageFrame.origin.x = self.frame.origin.x + self.frame.width - imageFrame.width - (imageFrame.width/2) // - inset
            
            imageFrame.origin.x =  self.frame.width - imageFrame.width - inset//- (imageFrame.width/2)
            imageFrame.origin.y  = (self.titleLabel?.frame.origin.y)!
            
            self.imageView?.frame = CGRect(x: imageFrame.origin.x  , y: imageFrame.origin.y, width: 35, height: 35)
            

            //self.imageView?.frame = imageFrame
                
            
        }
    }
   /* override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    //    layoutSubviews()
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
//layoutSubviews()
    }*/
}
