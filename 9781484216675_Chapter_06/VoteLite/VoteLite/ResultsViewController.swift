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
var voteData = VoteData() // This will receive a copy of the data

func displayVoteResults() {
    // Check if we have something to report and return if not:
    if voteData.participants == 0 {
        resultsTextView.text = "No voting took place"
        return
    }
    
    // Create a string, which will accumulate a summary of the votes:
    var voteInformation = "Vote topic: \(voteData.topic)\n"
    
    voteInformation += "\nParticipants: \(voteData.participants)"
    voteInformation += "\nAbstained: \(voteData.abstains)\n"
    
    // Iterate through the options array
    // to read the votes each option received:
    for choice in voteData.choices {
        voteInformation += "\n - \(choice.title) received \(choice.votes) votes"
    }
    
    // Display the string in the text view:
    resultsTextView.text = voteInformation
}

    
    // MARK: UIViewController
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Results will be refreshed every time the view appears on screen:
        displayVoteResults()
    }
}

