//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Mopel on 16/8/21.
//  Copyright © 2016年 Mopel. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let applcationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        memes = applcationDelegate.meme
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("table count:\(memes.count)")
        return memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let meme = memes[indexPath.row]
        let view = tableView.dequeueReusableCellWithIdentifier("memeitem") as! MemeTableViewCell
        view.memeImage.image = meme.memedImage
        view.memeMsg.text = meme.topText + meme.bottomText
        return view
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("detailViewController") as! MemeDetailViewController
        controller.meme = memes[indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}
