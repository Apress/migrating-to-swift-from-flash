//
//  ResultsViewController.swift
//  SimpleVote
//
//  Created by Radoslava Leseva on 14/04/2016.
//  Copyright © 2016 diadraw. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet weak var resultsTextView: UITextView!
    
    // MARK: Data
    func displayVoteResults() {
        // Check if we have something to report and return if not:
        if tabManager.voteData.participants == 0 {
            resultsTextView.text = "No voting took place"
            return
        }
        
        // Create a string, which will accumulate a summary of the votes:
        var voteInformation = "Vote topic: \(tabManager.voteData.topic)\n"
        
        voteInformation += "\nParticipants: \(tabManager.voteData.participants)"
        voteInformation += "\nAbstained: \(tabManager.voteData.abstains)\n"
        
        // Iterate through the options array
        // to read the votes each option received:
        for choice in tabManager.voteData.choices {
            voteInformation += "\n - \(choice.title) received \(choice.votes) votes"
        }
        
        // Display the string in the text view:
        resultsTextView.text = voteInformation
    }
    
    func displayVoteResultsAsPercentages() {
        // Check if we have something to report and return if not:
        if tabManager.voteData.participants == 0 {
            resultsTextView.text = "No voting took place"
            return
        }
        
        // Create a string, which will accumulate a summary of the votes:
        var voteInformation = "Vote topic: \(tabManager.voteData.topic)\n"
        voteInformation += "\nTotal votes: \(tabManager.voteData.participants)"
        
        // Work out the percent of abstain votes:
        let abstainedPercent = 100 * Double(tabManager.voteData.abstains) / Double(tabManager.voteData.participants)
        
        // Convert the percent to a string with precision of two digits after the decimal point:
        let formatter = NSNumberFormatter()
        formatter.maximumFractionDigits = 2
        let abstainedPercentString = formatter.stringFromNumber(abstainedPercent)!
        voteInformation += "\nAbstained: \(abstainedPercentString)%\n"
        
        // Iterate through the choices array
        // to read the votes each choice received:
        for choice in tabManager.voteData.choices {
            let choiceVotePercent = 100 * Double(choice.votes) / Double(tabManager.voteData.participants)
            
            // Use the formatter to convert the percent information into a string:
            let choiceVotePercentString = formatter.stringFromNumber(choiceVotePercent)!
            voteInformation += "\n - \(choice.title) received \(choiceVotePercentString)% of the votes"
        }
        
        // Display the string in the text view:
        resultsTextView.text = voteInformation
    }
    
    // MARK: UIViewController
    weak var tabManager: VoteTabBarController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get a reference to the tab bar controller
        // and cast it to the class we created for it:
        tabManager = self.tabBarController as! VoteTabBarController
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Results will be refreshed every time the view appears on screen.
        // Get a reference to the defaults system
        let defaults = NSUserDefaults.standardUserDefaults()

        // Read the Boolean stored for the state of the switch.
        // If no value is found for the key,
        // boolForKey will return false by default.
        if defaults.boolForKey(tabManager.resultsAsPercentKey) {
            displayVoteResultsAsPercentages()
        } else {
            displayVoteResults()
        }
    }
}

