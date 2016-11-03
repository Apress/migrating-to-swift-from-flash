//
//  CreateViewController.swift
//  VotePro
//
//  Created by Radoslava Leseva on 17/04/2016.
//  Copyright © 2016 diadraw. All rights reserved.
//

import UIKit

class CreateViewController : UIViewController, UITextFieldDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var voteTopic: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var choicesView: UIStackView!

    // MARK: Actions
    @IBAction func addButtonTapped(sender: AnyObject) {
        createNewChoice()
    }

    @IBAction func removeButtonTapped(sender: AnyObject) {
        removeLastChoice()
    }
    
    // MARK: Dynamic UI
    // This array keeps references
    // to text fields we create at runtime:
    var choiceTextFields = [UITextField]()
    
    func createNewChoice() {
        // Create and set up a new text field:
        let textField = UITextField()
        textField.placeholder = "Choice title"
        textField.delegate = self
        
        // Add it to the array of dynamic text fields:
        choiceTextFields.append(textField)
        
        // Add it to the vertical stack view:
        choicesView.addArrangedSubview(textField)
        
        // See if the addButton and the removeButton
        // need to be enabled/disabled:
        updateButtonState()
    }
    
    func removeLastChoice() {
        // Take out the last text field
        // we added to the array:
        var textField = choiceTextFields.popLast()
        
        // Remove it from the screen:
        choicesView.removeArrangedSubview(textField!)
        
        // Flag it for deallocating:
        textField = nil
        
        // See if the addButton and the removeButton
        // need to be enabled/disabled:
        updateButtonState()
    }
    
    func updateButtonState() {
        // Check the user settings
        // for the maximum number of choices allowed:
        let defaults = NSUserDefaults.standardUserDefaults()
        var maxChoices = defaults.integerForKey(tabManager.maxChoicesKey)
        if maxChoices == 0 {
            // If no value was found,
            // take the data constraint from tabManager:
            maxChoices = tabManager.maxChoices
        }
        
        // Only enable the addButton if we are below the maximum:
        addButton.enabled = choiceTextFields.count < maxChoices
        
        // Only enable the removeButton
        // if we have more than the minimum choices allowed:
        removeButton.enabled = choiceTextFields.count > tabManager.minChoices
    }
    
    // MARK: UIViewController
    weak var tabManager: VoteTabBarController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get a reference to the tab bar controller:
        tabManager = self.tabBarController as! VoteTabBarController
        
        // Create text fields for the minimum number of choices
        // that make a valid vote topic:
        for _ in 1 ... tabManager.minChoices {
            createNewChoice()
        }
        
        // Set CreateViewController as the delegate of the text field,
        // so it can help it let go of the keyboard:
        voteTopic.delegate = self
    }
    
    override func viewWillDisappear(animated: Bool) {
        if newVoteWasComposed() {
            updateDataModel()

            // Notify observers that data has changed:
            let notificationCenter = NSNotificationCenter.defaultCenter()
            notificationCenter.postNotificationName(tabManager.dataChangedNotificationName, object: nil)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Update the add and remove buttons,
        // in case the user changed preferences
        // on the Settings screen:
        updateButtonState()
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // This will make the keyboard disappear
        // when the Return button is tapped in a text field:
        textField.resignFirstResponder()
        return true;
    }

    // MARK: Helper functions
    func newVoteWasComposed() -> Bool
    {
        // Check if we have a valid topic and choices for voting.
        // If any text field has been left empty,
        // we assume the composing of the new topic was not finished.
        
        if voteTopic.text!.isEmpty {
            return false
        }
        
        for textField in choiceTextFields {
            if textField.text!.isEmpty {
                return false
            }
        }
        
        return true
    }
    
    
    func updateDataModel() {
        // Update the data in tabManager:
        tabManager.voteData.topic = voteTopic.text!
        
        tabManager.voteData.choices.removeAll(keepCapacity: true)
        
        for textField in choiceTextFields {
            tabManager.voteData.choices.append(Choice(title: textField.text!))
        }
    }
    
}

