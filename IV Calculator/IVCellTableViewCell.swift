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

    var iv: IV! {
        didSet {
            atkLabel.text = String(iv.atk)
            defLabel.text = String(iv.def)
            staLabel.text = String(iv.sta)
        }
    }

}
