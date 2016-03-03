//
//  NewPostViewController.swift
//  TwitterClone
//
//  Created by Nav Saini on 3/2/16.
//  Copyright © 2016 Saini. All rights reserved.
//

import UIKit

class NewPostViewController: UIViewController {

    @IBOutlet weak var postTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hello it's me")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPost(sender: AnyObject) {
        let params = ["status" : postTextView.text!]
        TwitterClient.sharedInstance.postTweet(params, success: { (user: User) -> () in
            print("it worked")
            }) { (error: NSError) -> () in
                print("there was an error")
        }
        postTextView.text = "Tweet goes here"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
