//
//  ViewController.swift
//  TwitterClone
//
//  Created by Nav Saini on 2/15/16.
//  Copyright © 2016 Saini. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

    @IBAction func onLogin(sender: AnyObject) {
        let client = TwitterClient.sharedInstance
        
        client.login({ () -> () in
            print("logged in")
            self.performSegueWithIdentifier("loginSegue", sender: nil)
        
        }) { (error: NSError) -> () in
                print("error")
        }

    }

}

