//
//  ForecastItemModel.swift
//  WeatherApp
//
//  Created by Hristo Lesev on 4/11/16.
//  Copyright © 2016 DiaDraw. All rights reserved.
//

import Foundation
import UIKit

public class ForecastItem {
    //Forecast temperature stored as String
    public var temparature : String
    //Forecast date and time entry
    public var dayAndTime : String
    //Weather icon name
    public var imageID : String
    //Cached weather image
    public var uiImageCache : UIImage?
    
    init( temperature: String, dayAndTime : String, imageID : String) {
        self.temparature = temperature
        self.dayAndTime = dayAndTime
        self.imageID = imageID
        self.uiImageCache = nil
    }
    
    //Load image from data and cache it
    public func addImageCache( fromData data : NSData ) {
        //Create UIImage from NSData
        uiImageCache = UIImage(data: data)
    }
}

public class ForecastModel {
    
    //An array of forecast items
    private var forecastData : [ForecastItem]
    
    init() {
        forecastData = []
    }
    
    //Remove all forecast items
    func removeAll() -> Void {
        forecastData.removeAll()
    }
    
    //Get forecast item at a given index in the forecastData array
    func getItem( atIndex index : Int ) -> ForecastItem {
        return forecastData[index]
    }
    
    //Add а new forecast item to the list
    func appendItem( newItem newItem : ForecastItem ) {
        forecastData.append(newItem)
    }
    
    //Get the number of forecast items
    func getItemCount() -> Int {
        return forecastData.count
    }
}