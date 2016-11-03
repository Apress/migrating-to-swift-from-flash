//
//  ViewController.swift
//  HelloXcode
//
//  Created by Radoslava Leseva on 05/02/2016.
//  Copyright © 2016 diadraw. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    // Outlets for accessing the label and the date picker in Main.storyboard:
    @IBOutlet weak var dayOfTheWeek: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        // Update the label when the view is first loaded:
        updateDayOfWeek()
    }
    
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    
    
    
    
    
    
    // Handler for the Value Changed event in the date picker:
    @IBAction func dateChanged(sender: AnyObject) {
        updateDayOfWeek()
    }
    
    
    func updateDayOfWeek() {
        // Change the label's text to show what day of the week the date in the picker is:
        dayOfTheWeek.text = getDayOfWeek(date: datePicker.date)
        
        // Convert the date from the date picker to a String:
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        let dateString = dateFormatter.stringFromDate(datePicker.date)
        
        // Print out the date and what day of the week it is:
        print("\(dateString) is a \(dayOfTheWeek.text!)")
    }
    
    
    func getDayOfWeek(date date: NSDate) -> String {
        // The NSCalendar instance can give us access to the date components, which have the weekday information:
        let gregorianCalendar =
            NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        
        // Weekday in an integer between 1 and 7:
        let weekDay =
            gregorianCalendar.components(NSCalendarUnit.Weekday, fromDate: date).weekday
        
        // Now turn the integer into a day's name.
        // Keep in mind that the weekdays in our chosen calendar start at Sunday.
        switch weekDay {
        case 1: return "Sunday"
        case 2: return "Monday"
        case 3: return "Tuesday"
        case 4: return "Wednesday"
        case 5: return "Thursday"
        case 6: return "Friday"
        case 7: return "Saturday"
            
        // This will print out an error message in Xcode's console:
        default: print("weekDay must be between 1 and 7")
        }
        
        // We haven't been able to work the day of week
        // for some reason:
        return "Unknown"
    }
}

