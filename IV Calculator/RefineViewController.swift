//
//  RefineViewController.swift
//  IV Calculator
//
//  Created by Brandon Coll on 7/27/16.
//  Copyright © 2016 Brandon Coll. All rights reserved.
//

import UIKit
import Darwin

class RefineViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var selectedCpTextField: UITextField!
    @IBOutlet weak var selectedHpTextField: UITextField!
    @IBOutlet weak var selectedStardustTextField: UITextField!
    @IBOutlet weak var refineButton: UIButton!
    @IBOutlet weak var IVTableView: UITableView!
    @IBOutlet weak var sdPickerView: UIPickerView!
    @IBOutlet weak var determinedLabel: UILabel!
    
    var selectedPokemon:Pokemon = NoPokemonSelected
    var selectedCP:Int = 0
    var selectedHP:Int = 0
    var selectedSD:Int = 0
    var isPowered:Bool = false
    var possibleIVs:[IV] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addDoneButtonOnKeyboard()
        IVTableView.delegate = self
        IVTableView.dataSource = self
        
        refineButton.enabled = false
        sdPickerView.hidden = true
        selectedStardustTextField.text = String(sdLevels[0])
        
        nameLabel.text = selectedPokemon.name
        possibleIVs = getIVs(selectedSD, hp: selectedHP, cp: selectedCP, powered: isPowered)
        if(possibleIVs.count == 1){
            determinedLabel.text = "IV Value Determined!"
        } else {
            determinedLabel.text = "Possible IV Stats:"
        }
    }
    
    //Trigggered by the refine button. Changes the value of possibleIVs to reflect refined data and updates the tableView.
    @IBAction func refine(sender: UIButton) {
        selectedCP = Int(selectedCpTextField.text!)!
        selectedHP = Int(selectedHpTextField.text!)!
        selectedSD = Int(selectedStardustTextField.text!)!
        
        var determinedIVs:[IV] = []
        var possibleNewIvs:[IV] = getIVs(selectedSD, hp: selectedHP, cp: selectedCP, powered: true)
        
        for i in 0...possibleNewIvs.count-1 {
            for j in 0...possibleIVs.count-1 {
                if(possibleNewIvs[i].atk == possibleIVs[j].atk && possibleNewIvs[i].def == possibleIVs[j].def && possibleNewIvs[i].sta == possibleIVs[j].sta){
                    determinedIVs.append(possibleNewIvs[i])
                }
            }
        }
        if(determinedIVs.isEmpty){
            //insert error throw
        } else {
            
            possibleIVs = determinedIVs
            IVTableView.reloadSections(NSMutableIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Fade)
            
            selectedHpTextField.text = ""
            selectedCpTextField.text = ""
            
            if(possibleIVs.count == 1){
                determinedLabel.text = "IV Value Determined!"
            } else {
                determinedLabel.text = "Possible IV Stats:"
            }
            checkRefineStatus()
        }
        
    }
    
    //Sets the number of tableView rows to the number of possible IV combinations.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return possibleIVs.count
    }
    
    
    //Displays the cell at each row according to the IV at that point in the array.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("IVCell", forIndexPath: indexPath) as! IVCellTableViewCell
        
        let iv = self.possibleIVs[indexPath.row]
        cell.iv = iv
        return cell
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
        selectedStardustTextField.text = String(sdLevels[row])
        sdPickerView.hidden = true
    }
    
    //Determines if the keyboard should appear to edit a text field when selected.
    //Displays the pickerview if the text field is sdTextField, keyboard otherwise.
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if(textField==selectedStardustTextField){
            sdPickerView.hidden = false
            return false
        }
        return true
    }
    
    //When a text field has finished editing calls checkRefineStatus
    func textFieldDidEndEditing(textField: UITextField) {
        checkRefineStatus()
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
        
        self.selectedCpTextField.inputAccessoryView = doneToolbar
        self.selectedHpTextField.inputAccessoryView = doneToolbar
    }
    
    //Closes the keyboard when done is pressed on either of the views.
    func doneButtonAction(){
        self.selectedCpTextField.resignFirstResponder()
        self.selectedHpTextField.resignFirstResponder()
    }
    
    //Takes in SD, HP, CP and powered values and returns a list of all possible IVs
    func getIVs(stardust:Int, hp:Int, cp:Int, powered:Bool) -> [IV] {
        //Finds the possible levels for each stardust value.
        var possibleLevels:[Double] = []
        var startingLevel:Double = 0
        var inc:Double = 1
        for l in 0...sdLevels.count-1{
            if(sdLevels[l]==stardust){
                startingLevel = lvlsBySd[l]
            }
        }
        
        if(powered){
            inc = 0.5
        }
        
        for(var m = startingLevel; m<startingLevel+2; m = m+inc){
            possibleLevels.append(m)
        }
        
        //Finds the possible levels for each stardust value.
        var possibleHPsAndLevels:[(Int,Double)] = []
        for i in 0...possibleLevels.count-1{
            for j in 0...15{
                if(Double(hp) == floor(Double((selectedPokemon.baseSta+j))*(cpByLevel[Int(2*(possibleLevels[i]-1))]))){
                    possibleHPsAndLevels.append((j,possibleLevels[i]))
                }
            }
        }
        
        if(possibleHPsAndLevels.isEmpty){
            //throw invalid HP error.
        }
        
        //Returns the list of possible IVs given the STA and HP tuples.
        var possibleIVs:[IV] = []
        var thisHP:Int
        var thisLVL:Double
        for n in 0...possibleHPsAndLevels.count-1{
            
            thisHP = possibleHPsAndLevels[n].0
            thisLVL = possibleHPsAndLevels[n].1
            
            for atkIV in 0...15{
                for defIV in 0...15{
                    if(Double(cp) == floor(Double((selectedPokemon.baseAtk + atkIV))*sqrt(Double((selectedPokemon.baseDef + defIV)))*sqrt(Double(selectedPokemon.baseSta + thisHP))*cpByLevel[Int(2*(thisLVL-1))]*cpByLevel[Int(2*(thisLVL-1))]/10)){
                        possibleIVs.append(IV(atk: Int8(atkIV), def: Int8(defIV), sta: thisHP))
                    }
                }
            }
        }
        return possibleIVs
    }
    
    //Checks if all text fields have been completed, if they have enables calculateButton.
    func checkRefineStatus(){
        if(selectedCpTextField.text != "" && selectedHpTextField.text != ""){
            refineButton.enabled = true
        } else {
            refineButton.enabled = false
        }
    }
}
