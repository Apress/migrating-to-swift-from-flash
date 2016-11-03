//
//  SettingsViewController.swift
//  VotePro
//
//  Created by Radoslava Leseva on 17/04/2016.
//  Copyright © 2016 diadraw. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var resultsAsPercentSwitch: UISwitch!
    @IBOutlet weak var maxChoicesLabel: UILabel!
    @IBOutlet weak var maxChoicesStepper: UIStepper!
    
    // MARK: Actions
    @IBAction func resultsAsPercentToggled(sender: AnyObject) {
        // Get a reference to the defaults system
        let defaults = NSUserDefaults.standardUserDefaults()
        
        // ... and use it to save the state of the switch:
        defaults.setBool(resultsAsPercentSwitch.on, forKey: tabManager.resultsAsPercentKey)
    }
    
    @IBAction func maxChoicesChanged(sender: AnyObject) {
        // Get a reference to the defaults system
        let defaults = NSUserDefaults.standardUserDefaults()
        
        // The stepper value is of type Double,
        // but we want to store an Int, so create an Int:
        let maxChoices = Int(maxChoicesStepper.value)
        
        // Store the maximum preferred choices as an integer:
        defaults.setInteger(maxChoices, forKey: tabManager.maxChoicesKey)
        
        // Finally, update the label
        // to show the user the value they set:
        updateMaxChoicesLabel()
    }
    
    // MARK: UIViewController
    weak var tabManager: VoteTabBarController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get a reference to the tab bar controller
        // and cast it to the class we created for it:
        tabManager = self.tabBarController as! VoteTabBarController
        
        // Query the system defaults for user preferences:
        loadSettings()
    }
    
    // MARK: Helper methods
    func updateMaxChoicesLabel(){
        maxChoicesLabel.text = "Maximum options: \(Int(maxChoicesStepper.value))"
    }

    func loadSettings()
    {
        // Get a reference to the defaults system
        let defaults = NSUserDefaults.standardUserDefaults()
        
        // Read the Boolean stored for the state of the switch.
        // If no value is found for the key,
        // boolForKey will return false by default.
        resultsAsPercentSwitch.on = defaults.boolForKey(tabManager.resultsAsPercentKey)
        
        // Read the value stored for the steper.
        // If no value is found, integerForKey will return 0.
        // When this is the case, 
        // set the stepper to the maximum choices allowed.
        let maxOptions = defaults.integerForKey(tabManager.maxChoicesKey)
        maxChoicesStepper.value =
            0 == maxOptions ? Double(tabManager.maxChoices) :
            Double(maxOptions)
        
        // Update the label to show the value we set the switch to:
        updateMaxChoicesLabel()
    }
}

