//
//  Double+Extention.swift
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 04/02/2019.
//  Copyright © 2019 Tania Berezovski. All rights reserved.
//

import Foundation
extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
