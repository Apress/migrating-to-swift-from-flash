//
//  ViewController.swift
//  iOSProject
//
//  Created by Hristo Lesev on 3/11/16.
//  Copyright © 2016 DiaDraw. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    let panda : Panda = Panda( pandaName: "Cute" )
    
    @IBAction func nameHasChanged(sender: AnyObject) {
        
        //Edit the model when text field view changes
        panda.name = textField.text!
        
        //Display the new name of the panda
        label.text = "My name is \(panda.name)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Display panda's name when the view is loaded
        label.text = "My name is \(panda.name)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

