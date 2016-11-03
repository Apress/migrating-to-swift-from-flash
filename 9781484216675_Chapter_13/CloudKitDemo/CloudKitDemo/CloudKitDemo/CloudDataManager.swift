//
//  CloudDataManager.swift
//  CloudKitDemo
//
//  Created by Hristo Lesev on 2/19/16.
//  Copyright © 2016 DiaDraw. All rights reserved.
//

import Foundation
import CloudKit

class CloudDataManager {
    //Shopping list items array
    var dataItems : [CKRecord]
    
    //Record Type of the items
    let recordType = "ShoppingItem"
    
    //Default initializer
    init() {
        //Create an empty array of shopping items
        dataItems = []
    }
    
    //Get item's name at a given index in the items' array
    func getItemName( atIndex index : Int ) -> String {
        return dataItems[index]["name"] as! String
    }
    
    //Get the number of shopping items
    func getItemsCount() -> Int {
        return dataItems.count
    }
    
    //Get all ShoppingItem records from the server and load then into the list
    func fetchCloudItems( callback callback: (NSError?) -> Void ) {
        //Get a reference of the user's iCloud database
        let privateDatabase = CKContainer.defaultContainer().privateCloudDatabase
        
        //Construct a query to get all the records of type "ShoppingItem"
        let fetchQuery  = CKQuery(recordType: self.recordType, predicate: NSPredicate(format: "TRUEPREDICATE"))
        
        //Sort fetched records by their name in ascending order
        fetchQuery.sortDescriptors = [ NSSortDescriptor(key: "name", ascending: true) ]
        
        //Send the query to iCloud
        privateDatabase.performQuery(fetchQuery, inZoneWithID: nil) { (records, error) -> Void in
            //Move the result records into the dataItems
            if records!.count > 0 {
                for record in records! {
                    self.dataItems.append( record )
                }
            }
            
            //Tell the UI to update itself
            callback(error)
        }
    }
    
    //Add new shopping item to the list and sync with iCloud
    func addItem( itemName item : String, callback: (NSError?) -> Void ) {
        //Get a reference of the user's iCloud database
        let privateDatabase = CKContainer.defaultContainer().privateCloudDatabase
        
        //Create a record of of type "ShoppingItem" and set its name
        let localRecord = CKRecord(recordType: self.recordType)
        localRecord["name"] = item
        
        //Ask iCloud to store the record
        privateDatabase.saveRecord(localRecord) { (record, error) -> Void in
            //If the response is ok add this record to the local list
            if let record = record {
                self.dataItems.append( record )
            }
            
            //Tell the UI to update itself
            callback( error )
        }
    }
    
    //Remove existing shopping item from the list and sync with iCloud
    func removeItem( atIndex index : Int, callback: (NSError?) -> Void) {
        //Get a reference of the user's iCloud database
        let privateDatabase = CKContainer.defaultContainer().privateCloudDatabase
        
        //Get a record by its index in the local list
        let record = dataItems[ index ]
        
        privateDatabase.deleteRecordWithID(record.recordID) { (recordID, error) -> Void in
            //Get the local index of the record that should be removed
            let recordIndex = self.dataItems.indexOf(record)
            //Remove the underlying record
            self.dataItems.removeAtIndex(recordIndex!)
            
            //Tell the UI to update itself
            callback( error )
        }
    }
    
}