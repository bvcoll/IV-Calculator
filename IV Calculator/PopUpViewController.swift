//
//  PopUpViewController.swift
//  IV Calculator
//
//  Created by Brandon Coll on 8/16/16.
//  Copyright © 2016 Brandon Coll. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var informationTextView: UITextView!
    
    var popUpTitle:String = ""
    var popUpInformation:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
        
        titleLabel.text = popUpTitle
        informationTextView.text = popUpInformation
        
        self.showAnimate()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func closePopUp(sender: AnyObject) {
        self.removeAnimate()
    }
    
    func showAnimate(){
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
        self.view.alpha = 0.0
        UIView.animateWithDuration(0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
        })
    }
    
    func removeAnimate(){
        UIView.animateWithDuration(0.25, animations: {
            self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
            self.view.alpha = 0.0
            }, completion: {(finished: Bool) in
                if (finished){
                    self.view.removeFromSuperview()
                }
        })
    }

}
