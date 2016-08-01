//
//  ViewController.swift
//  IV Calculator
//
//  Created by Brandon Coll on 7/25/16.
//  Copyright © 2016 Brandon Coll. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var speciesSearchBar: UISearchBar!
    @IBOutlet weak var cpTextField: UITextField!
    @IBOutlet weak var hpTextField: UITextField!
    @IBOutlet weak var sdTextField: UITextField!
    @IBOutlet weak var poweredSegmentedControl: UISegmentedControl!
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var sdPickerView: UIPickerView! = UIPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        sdPickerView.hidden = true
        sdTextField.text = String(sdLevels[0])
        self.hideKeyboardWhenTappedAround()
        self.addDoneButtonOnKeyboard()
    }

    //Retuns the number of columns in sdPickerView.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //Returns the number of rows in sdPickerView.
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sdLevels.count
    }
    
    //Returns the title for each row in sdPickerview.
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(sdLevels[row])
    }
    
    //Hides sdPickerView after displaying the picked item in sdTextField.
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        sdTextField.text = String(sdLevels[row])
        sdPickerView.hidden = true
    }
    
    //Determines if the keyboard should appear to edit a text field when selected.
    //Displays the pickerview if the text field is sdTextField, keyboard otherwise.
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if(textField==sdTextField){
            sdPickerView.hidden = false
            return false
        }
        return true
    }
    
    //Adds a done button above the keyboard for numberpad keyboards.
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
        doneToolbar.barStyle = UIBarStyle.Default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: #selector(CalculatorViewController.doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.cpTextField.inputAccessoryView = doneToolbar
        self.hpTextField.inputAccessoryView = doneToolbar
    }
    
    //Closes the keyboard when done is pressed on either of the views.
    func doneButtonAction(){
        self.cpTextField.resignFirstResponder()
        self.hpTextField.resignFirstResponder()
    }

    @IBAction func cancelToCalculatorViewController(segue:UIStoryboardSegue) {
    }
}

//Closes the keyboard if anywhere but the textfield is tapped.
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}