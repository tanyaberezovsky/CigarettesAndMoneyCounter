//
//  ReasonsTableViewCell.swift
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 29/08/2016.
//  Copyright © 2016 Tania Berezovski. All rights reserved.
//


import UIKit


class ReasonsTableViewCell: UITableViewCell
{
    var reason : Reasons?
        {
        didSet
        {
            updateNoteInfo()
        }
    }
    
    @IBOutlet weak var reasonTitle: UILabel!
    
    func updateNoteInfo()
    {
        if let reason = reason
        {
            reasonTitle.text = reason.reason
        }
    }
    
}

