//
//  DetailViewController.swift
//  TwitterClone
//
//  Created by Nav Saini on 2/26/16.
//  Copyright © 2016 Saini. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var profPicImageView: UIImageView!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favCountLabel: UILabel!
    
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("awesome view loaded")
        // Do any additional setup after loading the view.
        usernameLabel.text = tweet?.username.name as? String
        tweetTextLabel.text = tweet?.text
        profPicImageView.setImageWithURL(self.tweet!.username.profileURL!)
        retweetCountLabel.text = String(tweet!.retweetCount) 
        favCountLabel.text = String(tweet!.favCount)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func retweetButtonPressed(sender: AnyObject) {
        print("rt pressed")
        TwitterClient.sharedInstance.retweetWithID(self.tweet!.id!) { (tweet, error) -> () in
            if(tweet != nil){
                self.tweet = tweet!
                print("retweet")
            }
            else {
                print("nothing was retweeted")
            }
            
        }
        view.setNeedsDisplay()
    }
    
    @IBAction func favButtonPressed(sender: AnyObject) {
        print("fav pressed")
        TwitterClient.sharedInstance.favWithID(self.tweet!.id!) { (tweet, error) -> () in
            if(tweet != nil){
                self.tweet = tweet!
                
                print("faved")
            }
            else {
                print("nothing was faved")
            }
            self.view.setNeedsDisplay()
        }

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
