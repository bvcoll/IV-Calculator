//
//  ViewController.swift
//  IV Calculator
//
//  Created by Brandon Coll on 7/25/16.
//  Copyright © 2016 Brandon Coll. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var filteredPokemon:[Pokemon] = []
    var searchActive:Bool = false
    var selectedPokemon:Pokemon = NoPokemonSelected
    
    @IBOutlet weak var speciesSearchBar: UISearchBar!
    @IBOutlet weak var searchedTableView: UITableView!
    @IBOutlet weak var cpTextField: UITextField!
    @IBOutlet weak var hpTextField: UITextField!
    @IBOutlet weak var sdTextField: UITextField!
    @IBOutlet weak var poweredSegmentedControl: UISegmentedControl!
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var sdPickerView: UIPickerView! = UIPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        speciesSearchBar.delegate = self
        searchedTableView.delegate = self
        searchedTableView.dataSource = self
        sdPickerView.hidden = true
        calculateButton.enabled = false
        searchedTableView.hidden = true
        sdTextField.text = String(sdLevels[0])
        self.addDoneButtonOnKeyboard()
    }
    
    //Controlls searchActive boolean depending on searchbar status.//
    /////////////////////////////////////////////////////////////////
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
        searchedTableView.hidden = false
    }
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
        searchedTableView.hidden = true
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
        searchedTableView.hidden = true
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
        searchedTableView.hidden = true
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    /////////////////////////////////////////////////////////////////
    
    //When text in the searchbar changes updates the filteredPokemon list.
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filteredPokemon = allPokemon.filter{ pokemon in
            return pokemon.name.lowercaseString.containsString(searchText.lowercaseString)
        }
        if(filteredPokemon.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.searchedTableView.reloadData()
    }
    
    //Returns the number of rows in the tableview. If the view is being
    //searched filteredPokemon is counted, allPokemon otherwise.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filteredPokemon.count
        }
        return allPokemon.count
    }
    
    //Displays the cell at each row.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchedCell", forIndexPath: indexPath)
        let pokemon:Pokemon
        if(searchActive && speciesSearchBar.text != ""){
            pokemon = self.filteredPokemon[indexPath.row]
        } else {
            pokemon = allPokemon[indexPath.row]
        }
        cell.textLabel?.text = pokemon.name
        return cell
    }
    
    //Sets the selectedPokemon to what is selected in the tableView.
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(searchActive && speciesSearchBar.text != ""){
            selectedPokemon = self.filteredPokemon[indexPath.row]
        } else {
            selectedPokemon = allPokemon[indexPath.row]
        }
        speciesSearchBar.text = selectedPokemon.name
        dismissKeyboard()
        checkCalcStatus()
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
    
    //When a text field has finished editing calls checkCalcStatus
    func textFieldDidEndEditing(textField: UITextField) {
        checkCalcStatus()
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
    
    //Checks if all text fields have been completed, if they have enables calculateButton.
    func checkCalcStatus(){
        if(selectedPokemon != NoPokemonSelected && cpTextField.text != "" && hpTextField.text != ""){
            calculateButton.enabled = true
        } else {
            calculateButton.enabled = false
        }
    }
    
    //Returns a boolean depending on the segmentedControl status.
    func isPowered() -> Bool{
        let segTitle:String = poweredSegmentedControl.titleForSegmentAtIndex(poweredSegmentedControl.selectedSegmentIndex)!
        
        if(segTitle == "Yes"){
            return true
        } else {
            return false
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let navViewController:UINavigationController = segue.destinationViewController as! UINavigationController
        let DestViewController = navViewController.topViewController as! RefineViewController
        
        DestViewController.selectedCP = Int(cpTextField.text!)!
        DestViewController.selectedHP = Int(hpTextField.text!)!
        DestViewController.selectedSD = Int(sdTextField.text!)!
        DestViewController.isPowered = isPowered()
        DestViewController.selectedPokemon = self.selectedPokemon
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