//
//  PostImageViewController.swift
//  Instagram
//
//  Created by Igor Dorovskikh on 1/17/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class PostImageViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    func displayAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet var imageToPost: UIImageView!
    
    @IBAction func chooseImage(sender: AnyObject) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        
        self.presentViewController(image, animated: true, completion: nil)
    }
    
    
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
//        self.dismissViewControllerAnimated(true, completion: nil)
//        imageToPost.image = image
//    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.dismissViewControllerAnimated(true, completion: nil)
        imageToPost.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\(info[UIImagePickerControllerReferenceURL])")
        
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBOutlet var message: UITextField!
    
    @IBAction func postImage(sender: AnyObject) {
            activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
            activityIndicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            
            let post = PFObject(className: "Post")
            
            post["message"] = message.text
            post["userId"] = PFUser.currentUser()!.objectId!
            
            let imageData = UIImageJPEGRepresentation(imageToPost.image!, 0.5)
            let imageFile = PFFile(name: "image.png", data: imageData!)
            post["imageFile"] = imageFile
            
            var errorMessage = "Please try again later!"
            post.saveInBackgroundWithBlock { (success, error) -> Void in
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                if error == nil
                {
                    self.displayAlert("Imgage Posted", message: "Your image has been posted successfully!")
                    self.imageToPost.image = UIImage(named: "place_holder_image.png")
                    self.message.text = ""
                }else
                {
                    if let errorString = error!.userInfo["error"] as? String {
                        errorMessage = errorString
                    }
                    self.displayAlert("Could not post Image", message: errorMessage)
                }
            
        
        
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.message.accessibilityIdentifier = "message_field"
        self.imageToPost.accessibilityIdentifier = "image"
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
