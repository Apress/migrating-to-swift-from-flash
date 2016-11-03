//
//  ViewController.swift
//  DemoCoreMotion
//
//  Created by Hristo Lesev on 7/15/15.
//  Copyright (c) 2015 DiaDraw. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {

    @IBOutlet weak var accXAxisLabel: UILabel!
    
    @IBOutlet weak var accYAxisLabel: UILabel!
    
    @IBOutlet weak var accZAxisLabel: UILabel!
    
    @IBOutlet weak var gyroXAxisLabel: UILabel!
    
    @IBOutlet weak var gyroYAxisLabel: UILabel!
    
    @IBOutlet weak var gyroZAxisLabel: UILabel!
    
    let motionManager : CMMotionManager = CMMotionManager()
    
    override func viewDidLoad()
    {
        // This line was generated for us by Xcode:
        super.viewDidLoad()
        
        // Set data sampling rate for the two sensors:
        motionManager.accelerometerUpdateInterval = 0.1 //ten times per second
        motionManager.gyroUpdateInterval = 0.1; //ten times per second
        
        // Check if the device has an accelerometer:
        if motionManager.accelerometerAvailable {
            
            // An accelerometer is present, now start listening for updates:
            motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue()) {
                    // Data is captured inside this closure (callback).
                    data, error in
                    
                    //print acceleration (x, y, z) data:
                    self.accXAxisLabel.text = "\(data!.acceleration.x)"
                    self.accYAxisLabel.text = "\(data!.acceleration.y)"
                    self.accZAxisLabel.text = "\(data!.acceleration.z)"
                }
        }
        
        // Check if the device has a gyroscope:
        if motionManager.gyroAvailable {
            // A gyroscope is present, now start listening for updates:
            motionManager.startGyroUpdatesToQueue(NSOperationQueue.mainQueue()) {
                    // Data is captured inside this closure (callback).
                    data, error in
                    
                    //print rotationRate (x, y, z) data:
                    self.gyroXAxisLabel.text = "\(data!.rotationRate.x)"
                    self.gyroYAxisLabel.text = "\(data!.rotationRate.y)"
                    self.gyroZAxisLabel.text = "\(data!.rotationRate.z)"
                }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

