//
//  Pokemon.swift
//  IV Calculator
//
//  Created by Brandon Coll on 7/29/16.
//  Copyright © 2016 Brandon Coll. All rights reserved.
//

import UIKit

class Pokemon: NSObject{
    
    let name:String
    let baseAtk:Int
    let baseDef:Int
    let baseSta:Int
    let evolution:String
    
    init(name:String, baseAtk:Int, baseDef:Int, baseSta:Int, evolution:String) {
        self.name = name
        self.baseAtk = baseAtk
        self.baseDef = baseDef
        self.baseSta = baseSta
        self.evolution = evolution
    }
    
    

}
