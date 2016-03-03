//
//  TweetsViewController.swift
//  TwitterClone
//
//  Created by Nav Saini on 2/19/16.
//  Copyright © 2016 Saini. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tweets: [Tweet]!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tweetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        
        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            }) { (error: NSError) -> () in
                print("error loading tweets")
        }
        // Do any additional setup after loading the view
        tweetButton.tag = 1
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tweets != nil {
            print("this branch taken")
            return self.tweets.count
        } else {
            print("this branch not taken")
            return 0
        }
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        let tweet = tweets[indexPath.row]
        
        let imageView = cell.profImageView
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
        imageView.userInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
        cell.tweetLabel.text = tweet.text
        cell.userLabel.text = tweet.username.name as? String
        cell.profImageView.setImageWithURL(tweet.username.profileURL!)
        cell.retweetCountLabel.text = String(tweet.retweetCount)
        cell.favCountLabel.text = String(tweet.favCount)
        return cell
    }
    
    func imageTapped(img: UIGestureRecognizer)
    {
        // Your action
        print("image was clicked")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let profileViewController = storyboard.instantiateViewControllerWithIdentifier("profileViewController") as! ProfileViewController
        
        
        let cell = img.view!.superview?.superview as! UITableViewCell
        let ip = self.tableView.indexPathForCell(cell)! as NSIndexPath
        let tweet = self.tweets![ip.row] as Tweet
        profileViewController.user = User(dictionary: tweet.user)
        
        self.navigationController?.pushViewController(profileViewController, animated: true)
        
        
    }

    @IBAction func retweetPressed(sender: AnyObject) {
        
        let button = sender as! UIButton
        let cell = button.superview?.superview as! UITableViewCell
        let ip = self.tableView.indexPathForCell(cell)! as NSIndexPath
        
        let tweet = self.tweets![ip.row] as Tweet
        TwitterClient.sharedInstance.retweetWithID(tweet.id!) { (tweet, error) -> () in
            if(tweet != nil) {
                self.tweets![ip.row] = tweet!
            }
            self.tableView.reloadData()
        }
        
        
    }
    
    @IBAction func favPressed(sender: AnyObject) {
        
        let button = sender as! UIButton
        let cell = button.superview?.superview as! UITableViewCell
        let ip = self.tableView.indexPathForCell(cell)! as NSIndexPath
        
        let tweet = self.tweets![ip.row] as Tweet
        TwitterClient.sharedInstance.favWithID(tweet.id!) { (tweet, error) -> () in
            if(tweet != nil) {
                self.tweets![ip.row] = tweet!
            }
            self.tableView.reloadData()
        }

    }
    @IBAction func onLogoutButton(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if sender!.tag == 0 {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let tweet = tweets![indexPath!.row]
        
            let detailViewController = segue.destinationViewController as! DetailViewController
            detailViewController.tweet = tweet
            tableView.deselectRowAtIndexPath(indexPath!, animated: true)
        }
    
        
    }
    
    


}
