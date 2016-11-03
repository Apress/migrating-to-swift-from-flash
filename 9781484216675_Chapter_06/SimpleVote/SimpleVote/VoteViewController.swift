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
    @IBAction func abstain(sender: AnyObject) {
        // User has voted.
        // TODO: Increment the votes for the selected option.
        // TODO: Increment the number of participants.
        // Clear the selected choice to prepare the screen for the next participant:
        clearSelection()
    }
    
    @IBAction func vote(sender: AnyObject) {
        // User has decided not to vote.
        // TODO: Increment the number of participants.
        // Clear the selected choice to prepare the screen for the next participant:
        clearSelection()
    }
    
    // MARK: UIViewController
    override func viewWillAppear(animated: Bool) {
        // Call the base class method first
        // to make sure we won't miss out on any preparation done by it:
        super.viewWillAppear(animated)
        
        // Then clear the selection
        clearSelection()
        
        // TODO: reset the vote results
    }
    
    override func viewDidLoad() {
        // Call the base class method first
        // to make sure we won't miss out on any preparation done by it:
        super.viewDidLoad()
        
        // This will cause the methods required
        // by the UITableViewDataSource to be called:
        choicesTable.dataSource = self
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
    var choiceCount: Int {
        get{
            // Query the data model for the number of choices for voting.
            // TODO: Replace this row with a query to the data model:
            return 1
        }
    }

    func setUpCell(cell cell: UITableViewCell, atRow row: Int) {
        // TODO: Populate the cell with data
    }


    // MARK: Helper methods
    func clearSelection() {
        if let selectedIndexPath = choicesTable.indexPathForSelectedRow {
            choicesTable.deselectRowAtIndexPath(selectedIndexPath, animated: true)
        }
    }

}



























