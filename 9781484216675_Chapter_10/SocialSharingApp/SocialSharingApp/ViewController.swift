//
//  ViewController.swift
//  SocialSharingApp
//
//  Created by Hristo Lesev on 4/21/16.
//  Copyright © 2016 DiaDraw. All rights reserved.
//

import UIKit
import Social

class ViewController: UIViewController {

    @IBOutlet weak var postBody: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func postToFacebook(sender: AnyObject) {
        //Check if a Facebook account has been set up
        if false == SLComposeViewController.isAvailableForServiceType( SLServiceTypeFacebook ) {
            print("Facebook service is not available.")
            return
        }
        
        //Create an instance of the view controller, 
        //which will show the post compoer on the screen
        let facebookVC = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        
        //Set post's message body
        facebookVC.setInitialText( postBody.text )
        //Add an image to the post
        facebookVC.addImage( UIImage(named: "bear") )
        
        //Add a url to the post
        let url = NSURL(string: "http://diadraw.com")
        facebookVC.addURL( url )
        
        //Handle post completion
        facebookVC.completionHandler = {
            result in
            
            switch result {
            case .Cancelled:
                print("Message cancelled.")
            case .Done:
                print("Message sent.")
            }
        }
        
        //Show facebookVC on the screen
        presentViewController(facebookVC, animated: false, completion: nil)
    }

    @IBAction func postToTwitter(sender: AnyObject) {
        //Check if a Twitter account has been set up
        if false == SLComposeViewController.isAvailableForServiceType( SLServiceTypeTwitter ) {
            print("Twitter service is not available.")
            return
        }
        
        //Create a composer view controller
        let twitterVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        
        //Set post's message body
        twitterVC.setInitialText( postBody.text )
        //Add an image to the post
        twitterVC.addImage( UIImage(named: "bear") )
        
        //Add a url to the post
        let url = NSURL(string: "http://diadraw.com")
        twitterVC.addURL( url )
        
        //Handle post completion
        twitterVC.completionHandler = {
            result in
            
            switch result {
            case .Cancelled:
                print("Message cancelled.")
            case .Done:
                print("Message sent.")
            }
        }
        
        //Show twitterVC on the screen
        presentViewController(twitterVC, animated: false, completion: nil)
    }
}

