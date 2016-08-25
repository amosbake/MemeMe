//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Mopel on 16/8/25.
//  Copyright © 2016年 Mopel. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    @IBOutlet weak var memeImage: UIImageView!
    var meme: Meme!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memeImage.image = meme.memedImage
    }
}
