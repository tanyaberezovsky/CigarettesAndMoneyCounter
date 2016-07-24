//
//  Levels.swift
//  CigarettesAndMoneyCounter
//
//  Created by Tania on 9/26/14.
//  Copyright (c) 2014 Tania Berezovski. All rights reserved.
//

import Foundation


struct segueNames {
  //  static let segueLvlOfNeeded = "segueLvlOfNeeded"
  //  static let segueLvlOfEnjoy = "segueLvlOfEnjoy"
    static let segueCauseOfSmoking = "segueCauseOfSmoking"
    static let userDefaults = "userDefaults"
}

struct Levels {
    let nameLvl : String
    let nameNum : String
}



let descriptionNeeded = ["Not need at all",
    "Could avoid","Desired","Must have", "Absolutely necessary"]

//None, Just a littel, Very much
public let descriptionEnjoyed = ["Nothing",
    "Unremarkable","Some fun","Good", "Magnificent"]

let defaultReason = "Social smoking"
//cause of smoking
let cause = ["Boredom", "Thinking", "Working", "Learning", "Gaming", "After sleeping", "After coffee", "After eating", "Toilet", "Social smoking", "With friends", "With alcohol", "Go out", "Break", "Relax", "Vacation"
,"Self-expression",
    "After Something", "Before Something", "Fear Feeling"
,"Fun"
,"First cigaret"
,"Last cigarette"
,"In car"
,"Reward after"
    ,"Emptiness",
    "Insecure Feeling",
    "Hunger",
    "Stress",
    "Discomfort",
    "Panic",
    "Nerves"
    ,"Pleasure illusion",
     "Satisfaction illusion",
     "Concentration illusion",
    "Enjoy illusion",
    "Smell enjoy illusion",
    "Taste enjoy illusion",
    "Relax illusion",
    "State of peace illusion",
    "Courage illusion", "Other"].sort { $0 < $1 }


var levels : [Levels] = [Levels(nameLvl:"Level 0", nameNum: "0"),Levels(nameLvl:"Level 1", nameNum: "1"),Levels(nameLvl:"Level 2", nameNum: "2"),Levels(nameLvl:"Level 3", nameNum: "3")]


protocol selectionList: class {
    var title: String { get }

    func rowCount()->Int
    
    func text(indexArr: Int)->String
    
    func textValue(indexArr: Int)->String
  
    func detailText(indexArr: Int)->String
}

class enjoyedList:selectionList {
    
    var title: String = "Levels of enjoyment";
    
    func rowCount()->Int{
        return levels.count;
    }
    func text(indexArr: Int)->String{
        levels[indexArr].nameNum
        return levels[indexArr].nameLvl;
    }
    func textValue(indexArr: Int) -> String {
        return levels[indexArr].nameNum
    }
    func detailText(indexArr: Int)->String{
        return descriptionEnjoyed[indexArr];
    }
}




class neededList:selectionList {
    
    var title: String = "Levels of needed";
    
    func rowCount()->Int{
        return levels.count;
    }
    func text(indexArr: Int)->String{
        return levels[indexArr].nameLvl;
    }
    func textValue(indexArr: Int) -> String {
        return levels[indexArr].nameNum
    }
    func detailText(indexArr: Int)->String{
        return descriptionNeeded[indexArr];
    }
}


class causeList:selectionList {
    
    var title: String = "Reasons of smoking";
    
    func rowCount()->Int{
        return cause.count
    }
    func text(indexArr: Int)->String{
        return cause[indexArr]
    }
    func textValue(indexArr: Int) -> String {
        return text(indexArr)
    }
    func detailText(indexArr: Int)->String{
        return ""
    }
}




