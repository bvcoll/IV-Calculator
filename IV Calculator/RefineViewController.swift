//
//  RefineViewController.swift
//  IV Calculator
//
//  Created by Brandon Coll on 7/27/16.
//  Copyright © 2016 Brandon Coll. All rights reserved.
//

import UIKit
import Darwin

class RefineViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var selectedCpTextField: UITextField!
    @IBOutlet weak var selectedHpTextField: UITextField!
    @IBOutlet weak var selectedStardustTextField: UITextField!
    @IBOutlet weak var refineButton: UIButton!
    @IBOutlet weak var IVTableView: UITableView!
    
    var selectedPokemon:Pokemon = NoPokemonSelected
    var selectedCP:Int = 0
    var selectedHP:Int = 0
    var selectedSD:Int = 0
    var isPowered:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = selectedPokemon.name
        let possLvls:[Double] = getLevelsByStardust(selectedSD)
        getAtkAndDef(getPossibleHPsWithLevels(possLvls))
    }
    
    //Finds the possible levels for each stardust value.
    func getLevelsByStardust(stardust:Int) -> [Double] {
        var possibleLevels:[Double] = []
        var startingLevel:Double = 0
        var inc:Double = 0
        for i in 0...sdLevels.count-1{
            if(sdLevels[i]==stardust){
                startingLevel = lvlsBySd[i]
            }
        }
        if(isPowered){
            inc = 0.5
        } else {
            inc = 1
        }
        for(var i = startingLevel; i<startingLevel+2; i = i+inc){
            possibleLevels.append(i)
        }
        return possibleLevels
    }
    
    //Returns a list of dictionarys with [IVHP:Level] for reference.
    func getPossibleHPsWithLevels(possibleLevels:[Double]) -> [(Int,Double)] {
        var possibleHPsAndLevels:[(Int,Double)] = []
        for i in 0...possibleLevels.count-1{
            for j in 0...15{
                if(Double(selectedHP) == floor(Double((selectedPokemon.baseSta+j))*(cpByLevel[Int(2*(possibleLevels[i]-1))]))){
                    possibleHPsAndLevels.append((j,possibleLevels[i]))
                }
            }
        }
        return possibleHPsAndLevels
    }
    
    //Returns the list of possible IVs given the STA and HP tuples.
    func getAtkAndDef(possibleHPsAndLevels:[(Int,Double)]) -> [IV]{
        var possibleIVs:[IV] = []
        var thisHP:Int
        var thisLVL:Double
        for i in 0...possibleHPsAndLevels.count-1{
            
            thisHP = possibleHPsAndLevels[i].0
            thisLVL = possibleHPsAndLevels[i].1
            
            for atkIV in 0...15{
                for defIV in 0...15{
                    if(Double(selectedCP) == floor(Double((selectedPokemon.baseAtk + atkIV))*sqrt(Double((selectedPokemon.baseDef + defIV)))*sqrt(Double(selectedPokemon.baseSta + thisHP))*cpByLevel[Int(2*(thisLVL-1))]*cpByLevel[Int(2*(thisLVL-1))]/10)){
                        possibleIVs.append(IV(atk: Int8(atkIV), def: Int8(defIV), sta: thisHP))
                    }
                }
            }
        }
        print(possibleIVs)
        return possibleIVs
    }
    
}
