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
        // TODO: Display a vote summary in resultsTextView
    }
    
    // MARK: UIViewController
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Results will be refreshed every time the view appears on screen:
        displayVoteResults()
    }
}

