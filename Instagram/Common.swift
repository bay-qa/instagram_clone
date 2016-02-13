//
//  Common.swift
//  Instagram
//
//  Created by Igor Dorovskikh on 2/11/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class Common{

    static func displayAlert(title: String, message: String, sender: AnyObject?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
        })))
        sender!.presentViewController(alert, animated: true, completion: nil)
    }

}
