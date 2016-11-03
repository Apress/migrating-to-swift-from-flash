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
            assert(selectedIndexPath.row < tabManager.voteData.choices.count)
            tabManager.voteData.choices[selectedIndexPath.row].votes += 1
            
            // Increment the number of participants:
            tabManager.voteData.participants += 1
        } else {
            // The user tapped Vote, but didn't select an option to vote for.
            showAbsentVoteAlert()
        }
        
        // Clear the selected choice to prepare the screen for the next participant:
        clearSelection()
    }

    @IBAction func abstain(sender: AnyObject) {
        // User has decided not to vote.
        // Increment the number of participants.
        tabManager.voteData.participants += 1
        
        // Clear the selected choice to prepare the screen for the next participant:
        clearSelection()
    }
    
    // MARK: UIViewController
    weak var tabManager: VoteTabBarController!
    
    override func viewWillAppear(animated: Bool) {
        // Call the base class method first
        // to make sure we won't miss out on any preparation done by it:
        super.viewWillAppear(animated)
        
        // Access the vote data in tabManager
        // to initialize the topic label:
        topicLabel.text = tabManager.voteData.topic
        
        // Clear the selection:
        clearSelection()
        
        // Reset the vote results:
        tabManager.voteData.resetVotes()
    }
    
    override func viewDidLoad() {
        // Call the base class method first
        // to make sure we won't miss out on any preparation done by it:
        super.viewDidLoad()
        
        // Get a reference to the tab bar controller
        // and cast it to the class we created for it:
        tabManager = self.tabBarController as! VoteTabBarController

        
        // This will cause the methods required
        // by the UITableViewDataSource to be called:
        choicesTable.dataSource = self
        
        // Subscribe for notifications about changes in the data model:
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: #selector(self.dataChanged),
                       name: tabManager.dataChangedNotificationName, object: nil)
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
    func setUpCell(cell cell: UITableViewCell, atRow row: Int) {
        // Populate the cell with data:
        if row >= 0 && row < tabManager.voteData.choices.count {
            let choice = tabManager.voteData.choices[row]
            cell.textLabel?.text = choice.title
        }
    }

    var choiceCount: Int {
        get{
            // Query the data model for the number of choices 
            // to present for voting:
            return tabManager.voteData.choices.count
        }
    }

    // MARK: Helper methods
    func clearSelection() {
        if let selectedIndexPath = choicesTable.indexPathForSelectedRow {
            choicesTable.deselectRowAtIndexPath(selectedIndexPath, animated: true)
        }
    }
    
    func showAbsentVoteAlert()
    {
        // Create an alert to ask if they want to abstain:
        let alert = UIAlertController(title: "You didn't cast a vote",
            message: "Do you want to abstain?",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        // Add a cancel action and a default action to the alert:
        // these will appear as buttons.
        let cancelAction = UIAlertAction(title: "No",
            style: .Cancel, handler: nil)
        alert.addAction(cancelAction)
        
        // The default action will be trigerred when the uer wants to abstain.
        // Add a handler for that, so we can count this
        // towards the total number of participants:
        let defaultAction = UIAlertAction(title: "Yes",
            style: .Default, handler: {
                // Increment the total number of participants:
                action in self.tabManager.voteData.participants += 1 } )
        alert.addAction(defaultAction)
        
        // Show the alert on screen:
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
func dataChanged()
{
    // This will get the table view 
    // to request new data for its cells:
    choicesTable.reloadData()
    
    // Access the vote data in tabManager
    // to initialize the topic label:
    topicLabel.text = tabManager.voteData.topic
}
}



























