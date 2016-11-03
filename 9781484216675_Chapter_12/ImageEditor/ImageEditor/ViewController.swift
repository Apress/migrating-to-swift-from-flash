//
//  ViewController.swift
//  ImageEditor
//
//  Created by Hristo Lesev on 4/25/16.
//  Copyright © 2016 DiaDraw. All rights reserved.
//

import UIKit
import Photos
import CoreImage

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    //Create an instance of the image picking controller
    let imagePicker = UIImagePickerController()
    
    //The filter we will use to controll the brightness, contrast and saturation of the image
    let colorFilter = CIFilter(name: "CIColorControls")
    
    //The original full sized image
    var originalImage:UIImage?
    //A downscaled image for preview
    var previewImage:UIImage?
    
    //An allert controller with activity indicator
    //to show that the app is busy saving an image
    var savingImageVC:UIAlertController?
    
    //A context to render the filter on the GPU
    var filterContext:CIContext = CIContext(EAGLContext: EAGLContext(API: .OpenGLES2), options:[kCIContextWorkingColorSpace : NSNull()])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set the delegate, which will recieve the chosen image
        imagePicker.delegate = self
        //Hide any editing options from the default UI
        imagePicker.allowsEditing = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func brightnessValueChanged(sender: UISlider) {
        //Change the brightness in correspondence of the slider's value
        colorFilter!.setValue(sender.value, forKey:"inputBrightness")
        //Apply the filter and show the result
        applyFilter()
    }
    
    @IBAction func contrastValueChanged(sender: UISlider) {
        //Change the contrast in correspondence of the slider's value
        colorFilter!.setValue(sender.value, forKey:"inputContrast")
        //Apply the filter and show the result
        applyFilter()
    }
    
    @IBAction func saturationValueChanged(sender: UISlider) {
        //Change the saturation in correspondence of the slider's value
        colorFilter!.setValue(sender.value, forKey:"inputSaturation")
        //Apply the filter and show the result
        applyFilter()
    }
    
    func displaySavingImageActivity() -> UIAlertController {
        //Create an alert controller
        let alertController = UIAlertController(title: "Saving image", message: nil, preferredStyle: .Alert)
        
        //Create an activity indicator
        let indicator = UIActivityIndicatorView(frame: alertController.view.bounds)
        indicator.color = UIColor.blackColor()
        indicator.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        //Add the activity indicator as a subview of the alert controller's view
        alertController.view.addSubview(indicator)
        indicator.userInteractionEnabled = false
        indicator.startAnimating()
        
        //Show the alertController on the screen
        presentViewController(alertController, animated: true, completion: nil)
        
        return alertController
    }
    
    @IBAction func saveToGallery(sender: AnyObject) {
        
        //Check if there is an image to save
        guard let origImg = originalImage else {
            //If there is no image exit this function
            return
        }
        
        //Show the activity indicator
        savingImageVC = displaySavingImageActivity()
        
        //Set the original image as an input image to the filter
        colorFilter!.setValue(CIImage(image:origImg), forKey:kCIInputImageKey)
        
        applyFilter()
        
        //Save the filtered result to the gallery
        UIImageWriteToSavedPhotosAlbum(imageView.image!, self, #selector(ViewController.image(_:didFinishSavingWithError:contextInfo:)), nil)

    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        
        //Hide the activity indicator
        savingImageVC!.dismissViewControllerAnimated(true, completion: nil)
        
        //Set back the preview image as an input image to the filter
        colorFilter!.setValue(CIImage(image:previewImage!), forKey:kCIInputImageKey)
    }
    
    func applyFilter() {
        //Get the filtered (output) image
        if let ciiOutput = colorFilter?.valueForKey(kCIOutputImageKey) as? CIImage {
            //Create an CGImage using the provided context
            let cgiOutput = filterContext.createCGImage(ciiOutput, fromRect: ciiOutput.extent)
            
            //Create an UIImage from the CGImage
            let result = UIImage(CGImage: cgiOutput)
            
            //Show the output image in the image view
            imageView?.image = result
        }
    }
    
    @IBAction func showChooseImageOptions(sender: UIBarButtonItem) {
        //Create an action sheet with options
        let actionSheet = UIAlertController(title: "", message: "Get an image", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        //Configure a new action for taking a photo with the camera
        let cameraAction = UIAlertAction(title: "Use the camera", style: UIAlertActionStyle.Default,handler: openCameraVC)
        
        //Configure a new action for picking an image from the gallery
        let galleryAction = UIAlertAction(title: "From the gallery", style: UIAlertActionStyle.Default, handler: openGalleryVC)
        
        //Configure an empty action to close the action sheet
        let closeAction = UIAlertAction(title: "Done", style: UIAlertActionStyle.Cancel){ (action) -> Void in
        }
        
        //Check if the device has a camera
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            //Add the cameraAction to the action sheet
            actionSheet.addAction(cameraAction)
        }
        
        //Check if a gallery is available
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum) {
            //Add the galleryAction to the action sheet
            actionSheet.addAction(galleryAction)
        }
        
        //Add the close action to the sheet
        actionSheet.addAction(closeAction)

        //For devices with bigger screens set the pop over controller to be the bar button instance.
        //This is needed by iOS to calculate the screen position of the action sheet controler.
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.barButtonItem = sender
        }
        
        //Show the action sheet on the screen
        presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        //Dismiss the image picker view controller
        dismissViewControllerAnimated(true, completion: nil)
        
        //Calculate a scale factor for the preview image
        //scale the original image so that it fits inside the imageView frame
        let scaleFactor:CGFloat = CGFloat(imageView.frame.size.height / image.size.height)
        
        //Calculate the size of the preview image
        let size = CGSizeApplyAffineTransform(image.size, CGAffineTransformMakeScale(scaleFactor, scaleFactor))
        
        //Create a context to draw the image inside
        UIGraphicsBeginImageContextWithOptions(size, false, CGFloat(0.0))
        //Draw the image downsampled to the new size
        image.drawInRect(CGRect(origin: CGPointZero, size: size))
        //Get the downsampled image from the context
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        //Destroys the context
        UIGraphicsEndImageContext()
        
        //Store the original image from the gallery
        originalImage = image
        
        //Store the downsampled image and use it for preview
        previewImage = scaledImage
        
        //Set the preview image as an input image to the filter
        colorFilter!.setValue(CIImage(image:previewImage!), forKey:kCIInputImageKey)
        
        applyFilter()
    }
    
    func openCameraVC(action: UIAlertAction) ->Void {
        //Tell image picker that we want to take a picture with the camera
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        //Show imagePicker on the screen
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    

    func openGalleryVC(action: UIAlertAction) ->Void {
        //Tell image picker that we want to browse the photo gallery
        imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
        //Show imagePicker on the screen
        presentViewController(imagePicker, animated: true, completion: nil)
    }
}

