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
}
