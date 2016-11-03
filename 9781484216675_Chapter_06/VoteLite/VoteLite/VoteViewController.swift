//
//  VoteViewController.swift
//  SimpleVote
//
//  Created by Radoslava Leseva on 10/04/2016.
//  Copyright © 2016 diadraw. All rights reserved.
//

import UIKit

class VoteViewController: UIViewController, UITableViewDataSource {
    // MARK: Outlets
    // The label shows the topic of the vote.
    @IBOutlet weak var topicLabel: UILabel!
    
    // The table lists the choices for voting
    // and lets the user select one.
    @IBOutlet weak var choicesTable: UITableView!
    
    // MARK: Actions
    @IBAction func vote(sender: AnyObject) {
        // User has voted.
        // Increment the votes for the selected choice:
        if let selectedIndexPath = choicesTable.indexPathForSelectedRow {
            assert(selectedIndexPath.row < voteData.choices.count)
            voteData.choices[selectedIndexPath.row].votes += 1
        }

        // Increment the number of participants:
        voteData.participants += 1
        
        // Clear the selected choice to prepare the screen for the next participant:
        clearSelection()
    }

    @IBAction func abstain(sender: AnyObject) {
        // User has decided not to vote.
        // Increment the number of participants.
        voteData.participants += 1
        
        // Clear the selected choice to prepare the screen for the next participant:
        clearSelection()
    }
    
    // MARK: Segues
    func unwindToVoting(unwindSegue: UIStoryboardSegue) {
    }
    
    // MARK: UIViewController
    override func viewWillAppear(animated: Bool) {
        // Call the base class method first
        // to make sure we won't miss out on any preparation done by it:
        super.viewWillAppear(animated)
        
        // Then clear the selection
        clearSelection()
        
        // Reset the vote results
        voteData.resetVotes()
    }
        
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Check if we are preparing for the "ShowResults" segue:
        if segue.identifier == "ShowResults" {
            // Check if our destination is the ResultsViewController:
            if let resultsController = segue.destinationViewController as? ResultsViewController {
                // Copy data over to the results controller:
                resultsController.voteData = voteData
            }
        }
    }
    
    override func viewDidLoad() {
        // Call the base class method first
        // to make sure we won't miss out on any preparation done by it:
        super.viewDidLoad()
        
        // This will cause the methods required
        // by the UITableViewDataSource to be called:
        choicesTable.dataSource = self
        
        // Populate the model with data:
        createVoteData()
        
        // Get the label to display the vote topic
        // that was set in the data model:
        topicLabel.text = voteData.topic
    }
    
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        // Query the data model for the number of choices to present for voting:
        return choiceCount
    }

    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Ask the table view for a cell that looks like
        // the one we prototyped ("ChoiceCell"):
        let cell = tableView.dequeueReusableCellWithIdentifier("ChoiceCell", forIndexPath: indexPath)
        
        // Fill in the cell with data from the data model:
        setUpCell(cell: cell, atRow: indexPath.row)
        
        return cell
    }

    // MARK: Data
    var voteData = VoteData()
    
    func createVoteData(){
        voteData.topic = "Gandalf or Dumbledore?"
        voteData.choices = [Choice(title: "Gandalf"), Choice(title: "Dumbledore")]
    }

    var choiceCount: Int {
        get{
            // Query the data model for the number of choices for voting.
            // Replace this row with a query to the data model:
            return voteData.choices.count
        }
    }

    func setUpCell(cell cell: UITableViewCell, atRow row: Int) {
        // Populate the cell with data
        if row >= 0 && row < voteData.choices.count {
            let choice = voteData.choices[row]

            // textLabel is a property of the Basic table view cell:
            cell.textLabel?.text = choice.title
        }
    }

    // MARK: Helper methods
    func clearSelection() {
        if let selectedIndexPath = choicesTable.indexPathForSelectedRow {
            choicesTable.deselectRowAtIndexPath(selectedIndexPath, animated: true)
        }
    }

}



























