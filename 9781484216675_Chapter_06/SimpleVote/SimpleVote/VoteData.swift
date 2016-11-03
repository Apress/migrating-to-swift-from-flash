//
//  VoteData.swift
//  SimpleVote
//
//  Created by Radoslava Leseva on 10/04/2016.
//  Copyright © 2016 diadraw. All rights reserved.
//

import Foundation

struct VoteData
{
    // Set a default topic for voting:
    var topic = "Which one would you choose?"
    
    // An array of choices for voting:
    var choices: [Choice] = []
    
    // The number of participants, who voted or abstained:
    var participants = 0
    
    var votes: Int{
        get{
            var numVotes = 0
            
            // Each choice keeps track of the number of votes
            // it receives, so just sum them all up:
            for choice in choices {
                numVotes += choice.votes
            }
            
            return numVotes
        }
    }
    
    var abstains: Int{
        get{
            // Work out how many participants abstained:
            return participants - votes
        }
    }
    
    mutating func resetVotes() {
        // Clear the vote information for a new session:
        participants = 0
        
        for i in 0 ..< choices.count {
            choices[i].votes = 0
        }
    }
}