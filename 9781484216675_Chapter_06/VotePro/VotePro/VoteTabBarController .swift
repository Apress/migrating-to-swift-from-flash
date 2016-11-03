//
//  VoteTabBarController .swift
//  VotePro
//
//  Created by Radoslava Leseva on 16/04/2016.
//  Copyright © 2016 diadraw. All rights reserved.
//

import UIKit

class VoteTabBarController: UITabBarController {
    // MARK: Settings keys
    let resultsAsPercentKey = "ResultsAsPercent"
    let maxChoicesKey = "MaximumChoices"
    
    // MARK: Notifications
    let dataChangedNotificationName = "Vote data changed"

    // MARK: Data constraints
    let minChoices = 2
    let maxChoices = 5
    
    // MARK: Data
    var voteData = VoteData()
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        voteData.topic = "Who would you have lunch with?"
        voteData.choices = [Choice(title: "Batman"), Choice(title: "Wonder Woman"), Choice(title: "Superman")]
    }
}

