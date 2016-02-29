//
//  ProfileViewController.swift
//  TwitterClone
//
//  Created by Nav Saini on 2/27/16.
//  Copyright © 2016 Saini. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profPicImageView: UIImageView!
    @IBOutlet weak var numTweets: UILabel!
    @IBOutlet weak var numFollowing: UILabel!
    @IBOutlet weak var numFollowers: UILabel!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = (user?.name as! String)
        self.numTweets.text = String(user!.tweetCount!)
        self.numFollowing.text = String(user!.followingCount!)
        self.numFollowers.text = String(user!.followersCount!)
        self.profPicImageView.setImageWithURL((user?.profileURL)!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
