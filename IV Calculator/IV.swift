//
//  IV.swift
//  IV Calculator
//
//  Created by Brandon Coll on 8/2/16.
//  Copyright © 2016 Brandon Coll. All rights reserved.
//

import UIKit

class IV: NSObject {
    
    var atk:Int8
    var def:Int8
    var sta:Int
    
    init(atk:Int8, def:Int8, sta:Int) {
        self.atk = atk
        self.def = def
        self.sta = sta
    }

}
