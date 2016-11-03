//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Hristo Lesev on 4/6/16.
//  Copyright © 2016 DiaDraw. All rights reserved.
//

import Foundation

public class WeatherForecastService {
    
    //Path to the API entry point
    private let apiBasePath : String = "http://api.openweathermap.org/data/2.5/"
    //Unique key to access the OpenWeatherMap service
    private let apiKey : String = "739c23f0ecc3b86bf0545471b8838387"
    
    //An aray of data tasks
    var dataTasks = [NSURLSessionTask]()
    
    //Unique error domain of the app
    let errorDomain = "com.diadraw.WeatherApp.WeatherForecastService"

    //Enum of possible error conditions
    enum ErrorCode {
        case noForecastData(Int)
        case urlFormatError(Int)
        case serverError(Int, String)
        case jsonParsingError(Int, String)
    }
    
    //Transforms ErrorCode to NSError
    func getNSError( fromCode errorCode:ErrorCode ) -> NSError {
        switch errorCode {
        case .noForecastData(let code):
            return NSError(domain:errorDomain, code:code, userInfo: [NSLocalizedDescriptionKey:"There is no forecast data."])
        case .urlFormatError(let code):
            return NSError(domain:errorDomain, code:code, userInfo: [NSLocalizedDescriptionKey:"URL format error."])
        case .serverError(let code, let message):
            return NSError(domain:errorDomain, code:code, userInfo: [NSLocalizedDescriptionKey:"Server error: \(message)"])
        case .jsonParsingError(let code, let message):
            return NSError(domain:errorDomain, code:code, userInfo: [NSLocalizedDescriptionKey:"JSON parsing error: \(message)"])
        }
    }
    
    //Get a forecast from OpenWeatherMap service 
    //and populate the forecast model
    public func getForecast( forecastModel forecastModel : ForecastModel, forCity city: String, completionHandler: (NSError?) -> Void) {
        
        //Clean all previeously entered items from the model
        forecastModel.removeAll()
        
        //Set the forecast API entry point
        let urlString = "\(apiBasePath)forecast?q=\(city)&units=metric&APPID=\(apiKey)"
        //Encrypt the URL string to use percent characters instead of blank spaces
        let encodedUrlString = urlString.stringByAddingPercentEncodingWithAllowedCharacters( NSCharacterSet.URLQueryAllowedCharacterSet())
        
        //Try to create a NSURL instance from the encoded URL string
        guard let url = NSURL( string:encodedUrlString! ) else {
            completionHandler( self.getNSError( fromCode: ErrorCode.urlFormatError(50) ) )
            return
        }
        
        //Connect to the web service and get data as dictionary
        requestToServer(apiEndpoint: url) {(json:NSDictionary?, error:NSError?) -> Void in

            guard error==nil else {
                //Signal that the operation has finished with an error
                completionHandler(error)
                return
            }
            
            //Check if there is a list of forecast data
            guard let forecastList = json!["list"] as? NSArray else {
                
                //Check if the server responded with a valid JSON but with error code inside
                if let errorCode = json!["cod"] as? String {
                    
                    //Get the server's error message
                    let errorMesage : String? = json!["message"] as? String
                    
                    //Construct en error message
                    let serverError = self.getNSError( fromCode: ErrorCode.serverError(Int(errorCode) ?? 50, errorMesage ?? "unknown error") )
                    
                    //Signal with server error
                    completionHandler(serverError)
                    return
                }
                else {
                    //Signal with error: there is no valid forecast data
                    completionHandler( self.getNSError( fromCode: ErrorCode.noForecastData(50) ))
                    return
                }
            }
            
            for entry in forecastList
            {
                //Check if all needed forecast properties
                //are present in the dictionary
                guard let forecastTempDegrees = entry["main"]!!["temp"] as? Double,
                    rawDateTime = entry["dt_txt"] as? String,
                    forecastIcon = entry["weather"]!![0]!["icon"] as? String
                    
                    else {
                        //Signal with error that there is no forecast data
                        completionHandler( self.getNSError( fromCode: ErrorCode.noForecastData(50) ) )
                        return
                }
                
                //Hydrate the forecast model with data
                forecastModel.appendItem(
                    newItem: ForecastItem(temperature: "\(forecastTempDegrees)",
                        dayAndTime: "\(rawDateTime)",
                        imageID: forecastIcon)
                )
            }
            //Signal that the operation has finished
            completionHandler(nil)
        }
    }
    
    

    //Request data from the server and decode it into an NSDictionary
    private func requestToServer( apiEndpoint url : NSURL, completionHandler: (NSDictionary?, NSError?) -> Void ) {
        
        //Get a shared session instance and define a task
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            
            guard error==nil else {
                //There was an error returned from the server
                completionHandler(nil, error)
                return
            }
            
            // Check for JSON serialization errors
            guard let unwrappedData = data else {
                completionHandler(nil, self.getNSError( fromCode: ErrorCode.jsonParsingError(50, "Unexpected data format.")))
                return
            }
            
            var jsonObject : AnyObject? = nil
            
            do {
                //Deserialize JSON data to a dictionary
                jsonObject = try NSJSONSerialization.JSONObjectWithData(unwrappedData, options: .AllowFragments)
                
                //Check if the resulting object from the serialization is a dictionary
                guard let deserializedDictionary = jsonObject as? NSDictionary else {
                    
                    //We expected dictionary, but some other object was returned. Return error.
                    completionHandler(nil, self.getNSError( fromCode: ErrorCode.jsonParsingError(50, "Unexpected format.")))
                    
                    return
                }
                
                completionHandler(deserializedDictionary, nil)
            }
            //There was an error with JSON deserialization
            catch {
                completionHandler(nil, self.getNSError( fromCode: ErrorCode.jsonParsingError(50, "There was an error with JSON deserialization.")))
            }
        }
        
        // Add the task to the tasks list
        dataTasks.append(task)
        
        //Start the task
        task.resume()
    }

    //Download a forecast PNG icon and cache it in the forecastItem
    public func downloadForecastImage( forecastItem forecastItem : ForecastItem , completionHandler: (NSError?) -> Void ) {
        //Get a URL to the weather image from the imageID string
        let url = NSURL(string: "http://openweathermap.org/img/w/\(forecastItem.imageID).png")
        
        //Get a shared session instance and start a task to download the image data from the url
        let downloadImageTask = NSURLSession.sharedSession().dataTaskWithURL(url!) {
            (data, response, error) in
            
            if error == nil {
                print("Download Finished")
                
                //Get a UIImage from the returned data and cache it
                forecastItem.addImageCache(fromData: data!)
            }
            
            //The task is complete, call the completion handler
            completionHandler(error)
        }
        
        // Add the task to the tasks list
        dataTasks.append(downloadImageTask)
        
        //Start the download task
        downloadImageTask.resume()
    }
    
    deinit {
        // Cancel any data tasks that are still running
        for task in dataTasks {
            if task.state == NSURLSessionTaskState.Running {
                task.cancel()
            }
        }
    }
}
