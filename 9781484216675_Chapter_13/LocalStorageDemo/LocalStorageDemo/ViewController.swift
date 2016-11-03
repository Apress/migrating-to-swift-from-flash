//
//  ViewController.swift
//  LocalStorageDemo
//
//  Created by Hristo Lesev on 2/9/16.
//  Copyright © 2016 DiaDraw. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // Outlet for accessing the label and the date picker in Main.storyboard:
    @IBOutlet weak var textView: UITextView!
    
    //Obtain a reference of NSFileManager
    let fileManager : NSFileManager = NSFileManager.defaultManager()

    //A property to store the path to the file on the file system
    var localFilePath : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //Get a URL path to the Application's tmp directory
        let tmpDirPath = NSURL(fileURLWithPath: NSTemporaryDirectory())

        //Append file name to the path
        let fileURL = tmpDirPath.URLByAppendingPathComponent("test.txt")

        //Get file path as string
        localFilePath = fileURL.path
        
        //Output resulting path to the console
        print( localFilePath )
        
        //Create an instance of UserSettings class
        let userSettings = UserSettings(userName: "Julius Marx",
                                        lovesPizza: true,
                                        age: 32,
                                        nickNames: ["Groucho"])
        
        //A file path and name where the userSettings state will be stored
        let archivePath = (tmpDirPath.URLByAppendingPathComponent("userSettings.xml")).path
        
        //Archive userSettings to a file
        NSKeyedArchiver.archiveRootObject(userSettings, toFile: archivePath!)
        
        //Unarchive the user settings from file
        let unarchivedSettings : UserSettings = NSKeyedUnarchiver.unarchiveObjectWithFile(archivePath!) as! UserSettings
        
        print(unarchivedSettings)
        
        /*
        //Listing 13-11.
        //Uncomment this code if you want to write userSettings to the app's local settings database
         
        //Serialize userSettings to NSData constant
        let settingsData = NSKeyedArchiver.archivedDataWithRootObject(userSettings)
        
        //Put data in the User Defaults database under the key "my_userSettings"
        NSUserDefaults.standardUserDefaults().setObject(settingsData, forKey: "my_userSettings")
        
        //Retrieve data from User Defaults database
        //associated with "my_userSettings" key
        if let unarchivedData = NSUserDefaults.standardUserDefaults().objectForKey("my_userSettings") as? NSData {
            let unarchivedSettings = NSKeyedUnarchiver.unarchiveObjectWithData(unarchivedData)
            print(unarchivedSettings)
        }
        */
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func openTextFile(sender: AnyObject) {
        //Clear the text view content for convenience
        textView.text = ""
        
        //Check if the file exists
        if fileManager.fileExistsAtPath(localFilePath!) {
            //Read the contents of the file as NSData
            let dataBuffer = fileManager.contentsAtPath(localFilePath!)
            
            //Decode from UTF8 NSData back to NSString
            let dataString = NSString(data: dataBuffer!, encoding: NSUTF8StringEncoding)
            
            //Put the decoded string in the text view
            textView.text = dataString as! String
        }
        else {
            showMessage( message: "File does not exist!" )
        }
    }

    @IBAction func saveTextFile(sender: AnyObject) {
        //Get the text from the text view and encode it as NSData with UTF8 encoding
        let fileData : NSData! = (textView.text as String).dataUsingEncoding(NSUTF8StringEncoding)
        
        //Try to create test.txt and add to it the contents of fileData
        let isOk = fileManager.createFileAtPath(localFilePath!, contents: fileData, attributes: nil)
        
        //Test if file creation was successful and show alert
        if isOk {
            showMessage( message: "File creation successful!" )
        }
        else {
            showMessage( message: "File creation unsuccessful!" )
        }
        
        //Print to console for convenience
        print( isOk )
    }

    
    func showMessage(message message: String) {
        //Instantiate an allert controller
        let alertController = UIAlertController(title: "Local Storage Demo", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        //Add "Dismiss" button to the alert
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        //Show alert on the screen
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

