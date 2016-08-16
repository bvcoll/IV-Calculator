//
//  IVCellTableViewCell.swift
//  IV Calculator
//
//  Created by Brandon Coll on 8/2/16.
//  Copyright © 2016 Brandon Coll. All rights reserved.
//

import UIKit

class IVCellTableViewCell: UITableViewCell {

    @IBOutlet weak var atkLabel: UILabel!
    @IBOutlet weak var defLabel: UILabel!
    @IBOutlet weak var staLabel: UILabel!
    @IBOutlet weak var percLabel: UILabel!

    var iv: IV! {
        didSet {
            atkLabel.text = "Atk: "+String(iv.atk)
            defLabel.text = "Def: "+String(iv.def)
            staLabel.text = "Sta: "+String(iv.sta)
            percLabel.text = String(round(Double((iv.atk + iv.def + iv.sta))/45*100*100)/100)+"%"
        }
    }

}
