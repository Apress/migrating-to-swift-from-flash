//
//  ViewController.swift
//  CloudKitDemo
//
//  Created by Hristo Lesev on 2/19/16.
//  Copyright © 2016 DiaDraw. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //Reference to the table view
    @IBOutlet weak var tableView: UITableView!
    
    //A reference to the data manager class
    let cloudDataManager = CloudDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set table view datasource and delegate
        tableView.delegate = self
        tableView.dataSource = self
        
        //Get all shopping list items from the server
        cloudDataManager.fetchCloudItems( callback: dataChanged )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Return shopping items number
        return cloudDataManager.getItemsCount()
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //Create new table cell for the row
        let cell = tableView.dequeueReusableCellWithIdentifier("ShoppingItemCell", forIndexPath: indexPath)
        
        //Set cell's label to be the name of the corresponding shopping item
        cell.textLabel?.text = cloudDataManager.getItemName( atIndex: indexPath.row)
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        //We can edit all the rows
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if UITableViewCellEditingStyle.Delete == editingStyle {
            //Ask data manager to delete the coresponding shopping item
            cloudDataManager.removeItem( atIndex: indexPath.row, callback: dataChanged)
        }
    }
    
    //Updates data in the UI
    func dataChanged( error : NSError? ) {
        if let error = error {
            //If there is an error message print it
            print(error)
        }
        else {
            //When there is a response do the logic in the main thread
            dispatch_async(dispatch_get_main_queue(), { [weak self] () -> Void in
                //Refresh data in the table view
                self!.tableView.reloadData();
            })
        }
    }
    
    
    @IBAction func didTapEdit(sender: UIBarButtonItem) {
        //Toggle table view edit mode
        tableView.editing = !tableView.editing
    }

    @IBAction func didTapAdd(sender: UIBarButtonItem) {
        //Create an allert controller dialog for adding new item
        let alertController = UIAlertController(title: "New Item", message: "Tap in new item", preferredStyle: UIAlertControllerStyle.Alert)
        
        //Add a text field component to the dialog
        alertController.addTextFieldWithConfigurationHandler { (UITextField) -> Void in }
        
        //Add Cancel button to dismiss the dialog
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: { (action : UIAlertAction) -> Void in
        }))
        
        //Add an Add button to add new item
        alertController.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler: { (action : UIAlertAction) -> Void in
            
            //Get item's name from dialog's text field
            let itemName = (alertController.textFields![0] as UITextField).text
            
            //Ask data manager to create new shopping item with the given name
            self.cloudDataManager.addItem( itemName: itemName!, callback: self.dataChanged)
        }))
        
        //Show this dialog on the screen
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

