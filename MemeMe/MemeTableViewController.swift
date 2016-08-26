//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Mopel on 16/8/21.
//  Copyright © 2016年 Mopel. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    var memes :[Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).meme
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    
    //MARK: delete row
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            print("row \(indexPath.row)")
            (UIApplication.sharedApplication().delegate as! AppDelegate).deleteMemeAtIndex(indexPath.row)
            tableView.reloadData()
        }
    }
    
    
    //MARK: rearrange tableview
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        if sourceIndexPath != destinationIndexPath {
            let meme = memes[sourceIndexPath.row]
            (UIApplication.sharedApplication().delegate as! AppDelegate).deleteMemeAtIndex(sourceIndexPath.row)
            (UIApplication.sharedApplication().delegate as! AppDelegate).insertMemeAtIndex(meme, index: destinationIndexPath.row)
        }
    }
    
}
