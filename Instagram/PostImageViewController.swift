//
//  PostImageViewController.swift
//  Instagram
//
//  Created by Igor Dorovskikh on 1/17/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class PostImageViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    var canPostImage : Bool = false;
    
    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet var imageToPost: UIImageView!
    
    @IBAction func chooseImage(sender: AnyObject) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        
        self.presentViewController(image, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.dismissViewControllerAnimated(true, completion: nil)
        imageToPost.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        print(info[UIImagePickerControllerReferenceURL] as! NSURL)
        self.canPostImage = true;
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBOutlet var message: UITextField!
    @IBOutlet var postImageButton: UIButton!
    
    @IBAction func postImage(sender: AnyObject) {
        
        if (self.canWePostImage()){
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
                    Common.displayAlert("Imgage Posted", message: "Your image has been posted successfully!", sender: self)
                    self.imageToPost.image = UIImage(named: "place_holder_image.png")
                    self.message.text = ""
                }else
                {
                    if let errorString = error!.userInfo["error"] as? String {
                        errorMessage = errorString
                    }
                    Common.displayAlert("Could not post Image", message: errorMessage, sender: self)
                }
        }
        self.canPostImage = false;
        }else{
            Common.displayAlert("Error", message: "Please choose an image before posting!", sender: self)
        }
    }
    
    func canWePostImage() -> Bool
    {
        return self.canPostImage;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.accessibilityIdentifier = "post_image_view"
        self.message.accessibilityIdentifier = "message_field"
        self.imageToPost.accessibilityIdentifier = "image_to_post"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    }
