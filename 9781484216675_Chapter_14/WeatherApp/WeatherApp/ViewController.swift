//
//  ViewController.swift
//  WeatherApp
//
//  Created by Hristo Lesev on 4/6/16.
//  Copyright © 2016 DiaDraw. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var cityTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    let weatherService = WeatherForecastService()
    let forecastModel = ForecastModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func searchForCity(sender: AnyObject) {
        weatherService.getForecast( forecastModel:forecastModel, forCity: cityTextField.text!){ ( error : NSError? ) -> Void in
            if let error = error {
                //If there is an error message print it
                print(error)
            }
            else {
                dispatch_async(dispatch_get_main_queue() , {[weak self] in
                    //Refresh data in the table view
                    self!.tableView.reloadData();
                    })
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Return forecast items number
        return self.forecastModel.getItemCount()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //Create new table cell for the row
        let cell = UITableViewCell()
        
        //Get a forecast item corresponding to the row number
        let forecastItem = self.forecastModel.getItem( atIndex: indexPath.row )
        
        //Set cell's text label to forecast item’s temperature, date and time
        cell.textLabel?.text = "\(forecastItem.temparature)° C | \(forecastItem.dayAndTime)"
        
        if forecastItem.uiImageCache == nil {
            weatherService.downloadForecastImage( forecastItem: forecastItem ) { (error)  in
                
                dispatch_async(dispatch_get_main_queue(), {[weak self] in
                    if let error = error {
                        //If there is an error message print it
                        print(error)
                    }
                    else {
                        //Assign the cached image to the cell's image view
                        cell.imageView?.image = forecastItem.uiImageCache
                        
                        //Refresh data in the row
                        self!.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
                    }
                })
            }
        }
        else {
            //Assign the cached image to the cell's image view
            cell.imageView?.image = forecastItem.uiImageCache
        }
        
        return cell
    }


}

