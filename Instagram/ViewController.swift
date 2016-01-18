/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class ViewController: UIViewController {
    
    var signupActive = true

    @IBOutlet var username: UITextField!
    
    @IBOutlet var password: UITextField!
    
    @IBOutlet var button: UIButton!
    
    @IBOutlet var registeredText: UILabel!
    
    @IBOutlet var loginButton: UIButton!
    
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    func displayAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func signUp(sender: AnyObject) {
        if username.text == "" || password.text == "" {
            displayAlert("Error in form", message: "Please enter a username and password!")
        } else {
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0,50,50))
            activityIndicator.center = self.view.center
            activityIndicator.accessibilityIdentifier = "spinner"
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            var errorMessage = "Please try again!"
            
            if signupActive == true{
                
                let user = PFUser()
                user.username = username.text
                user.password = password.text
                
                
                user.signUpInBackgroundWithBlock({ (success, error) -> Void in
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    if error == nil {
                        
                        self.performSegueWithIdentifier("login", sender: self)
                        
                    }else{
                        if let errorString = error!.userInfo["error"] as? String {
                            errorMessage = errorString
                        }
                        self.displayAlert("Failed Signup", message: errorMessage)
                    }
                })
            }else{
                PFUser.logInWithUsernameInBackground(username.text!, password: password.text!, block: { (user, error) -> Void in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    if user != nil {
                        
                        self.performSegueWithIdentifier("login", sender: self)
                        
                    }else{
                        if let errorString = error!.userInfo["error"] as? String {
                            errorMessage = errorString
                        }
                        self.displayAlert("Filed Login", message: errorMessage)
                    }
                })
            }
            
        }
    }
    
    @IBAction func logIn(sender: AnyObject) {
        if signupActive == true{
            button.setTitle("Log In", forState: UIControlState.Normal)
            button.accessibilityIdentifier = "login_btn"
            registeredText.text = "Not registered?"
            loginButton.setTitle("Sign Up", forState: UIControlState.Normal)
            loginButton.accessibilityIdentifier = "sign_up_btn"
            signupActive = false
        }else{
            button.setTitle("Sign Up", forState: UIControlState.Normal)
            button.accessibilityIdentifier = "sign_up_btn"
            registeredText.text = "Already registered?"
            loginButton.setTitle("Login", forState: UIControlState.Normal)
            loginButton.accessibilityIdentifier = "login_btn"
            signupActive = true

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        username.accessibilityIdentifier = "user_name"
        password.accessibilityIdentifier = "password"
        button.accessibilityIdentifier = "sign_up_btn"
        loginButton.accessibilityIdentifier = "login_btn"
        
    }

    override func viewDidAppear(animated: Bool) {
//        if PFUser.currentUser() != nil {
//            self.performSegueWithIdentifier("login", sender: self)
//        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
