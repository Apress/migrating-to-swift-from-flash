//
//  ViewController.swift
//  MessageComposer
//
//  Created by Hristo Lesev on 3/22/16.
//  Copyright © 2016 DiaDraw. All rights reserved.
//

import UIKit
import MessageUI
import ContactsUI

class ViewController: UIViewController, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate,CNContactPickerDelegate {

    @IBOutlet weak var recipientEmail: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var messageSubject: UITextField!
    @IBOutlet weak var messageBody: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sendEmail(sender: AnyObject) {
        //Check if the device is configure to send e-mails
        if MFMailComposeViewController.canSendMail() {
            let emailController = MFMailComposeViewController()
            //Set a delegate responsible for the dismissal of the view controller
            emailController.mailComposeDelegate = self
            
            //Extract recipients in an array of String items 
            //dividing the recipientEmail.text using comma separator
            let recipientList = recipientEmail.text!.componentsSeparatedByString(",")
            //Set the resulted array in e-mail's To field
            emailController.setToRecipients(recipientList)
            //Get a message subject from the messageSubject text field
            emailController.setSubject(messageSubject.text!)
            //Get a message body from the messageBody text view
            emailController.setMessageBody(messageBody.text, isHTML: false)
            
            //Show emailController on the screen
            presentViewController(emailController, animated: true, completion: nil)
        }
        else {
            print("Can not send e-mail.")
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        
        //Print the result of the user's action
        switch (result) {
        case MFMailComposeResultCancelled:
            print("Cancelled.")
        case MFMailComposeResultSaved:
            print("Saved as a Draft.")
        case MFMailComposeResultSent:
            print("Sent.")
        case MFMailComposeResultFailed:
            print("Failed \(error?.localizedDescription)")
        default:
            print("Result code: \(result.rawValue)")
        }
        
        //Dissmiss the view controller off the screen
        controller.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func sendSMS(sender: AnyObject) {
        //Check if the device can send SMS
        if MFMessageComposeViewController.canSendText() {
            let smsController = MFMessageComposeViewController()
            //Set a delegate responsible for the dismissal of the view controller
            smsController.messageComposeDelegate = self
            //Extract recipients in an array of String items
            //by dividing phoneNumber using comma separator
            let recipientList = phoneNumber.text!.componentsSeparatedByString(",")
            //Use the resulting array to set the To field
            smsController.recipients = recipientList
            //Get a message body from the messageBody text view
            smsController.body = messageBody.text
            
            //Show smsController on the screen
            presentViewController(smsController, animated: true, completion: nil)
        }
        else {
            print("Can not send sms.")
        }
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        
        //Print the result of the user's action
        switch (result) {
        case MessageComposeResultCancelled:
            print("Cancelled.")
        case MessageComposeResultSent:
            print("Sent.")
        case MessageComposeResultFailed:
            print("Failed.")
        default:
            print("Result code: \(result.rawValue)")
        }
        
        //Dissmiss the view controller off the screen
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func makeCall(sender: AnyObject) {
        
        if let phoneCallURL = NSURL(string: "tel://\(phoneNumber.text!)") {
            let application = UIApplication.sharedApplication()
            
            if application.canOpenURL(phoneCallURL) {
                application.openURL(phoneCallURL)
            }
        }
    }
    
    @IBAction func selectContact(sender: AnyObject) {
        let contactPicker = CNContactPickerViewController()
        //Tell contactPicker that we want to use e-mail and phone number
        contactPicker.displayedPropertyKeys = [CNContactEmailAddressesKey, CNContactPhoneNumbersKey]
        //Set a delegate which will recieve the selected person's info
        contactPicker.delegate = self
        
        //Show contactPicker on the screen
        presentViewController(contactPicker, animated: true, completion: nil)
    }
    
    func contactPicker(picker: CNContactPickerViewController, didSelectContact contact: CNContact)
    {
        //Check if there are any e-mails for this contact
        if contact.emailAddresses.count > 0 {
            //Get the first e-mail entry
            let email = contact.emailAddresses.first?.value as! String
            //Show the e-mail address in the UI
            recipientEmail.text = email
        }
        
        //Check if there are any phone numbers for this contact
        if contact.phoneNumbers.count > 0 {
            //Get the first phone number entry
            let phone = contact.phoneNumbers.first?.value as! CNPhoneNumber
            //Extract a string from the phone number and show it in the UI
            phoneNumber.text = phone.stringValue
        }
    }
}

