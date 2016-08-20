//
//  ViewController.swift
//  MemeMe
//
//  Created by Mopel on 16/8/18.
//  Copyright © 2016年 Mopel. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {
    @IBOutlet weak var bottomBar: UIToolbar!
    @IBOutlet weak var phoneImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : Float(-4)
    ]
    
    var currentMeme: Meme!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.bringSubviewToFront(topText)
        self.view.bringSubviewToFront(bottomText)
        
        /**Font Style**/
        topText.defaultTextAttributes = memeTextAttributes
        bottomText.defaultTextAttributes = memeTextAttributes
        /**TextField Align**/
        initTextField(topText)
        initTextField(bottomText)
        /**Init View**/
        resetView()
        
        /**Hide TextField Border**/
        topText.borderStyle = UITextBorderStyle.None
        bottomText.borderStyle = UITextBorderStyle.None
        
        /**textfield delegate**/
        topText.delegate = self
        bottomText.delegate = self
    }
    
    func initTextField(item: UITextField)  {
        item.defaultTextAttributes = memeTextAttributes
        item.delegate = self
        item.textAlignment = .Center
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.subscribeToKeyboardNotification()
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
    }
    
    override func viewWillDisappear(animated: Bool) {
        unsubscribeToKeyboardNotification()
        super.viewWillDisappear(animated)
    }
    
    @IBAction func pickImageView(sender: UIBarButtonItem) {
        let controller = UIImagePickerController()
        controller.delegate = self
        if sender.tag == 1 {
            controller.sourceType = .PhotoLibrary
        }else {
            controller.sourceType = .Camera
        }
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func resetView() {
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        phoneImageView.image = nil
        shareButton.enabled = false
    }
    
    @IBAction func shareMemeView()  {
        let controller = UIActivityViewController(activityItems: [currentMeme.memedImage], applicationActivities: nil)
        presentViewController(controller, animated: true, completion: nil)
        controller.completionWithItemsHandler = { (activity, success, items, error) in
            if(success){
                self.saveMeme()
            }
            controller.dismissViewControllerAnimated(true, completion: nil)
        }
      
    }
    
    //MARK: textfieldDelegate
    func textFieldDidBeginEditing(textField: UITextField) {
        if (textField.text == "BOTTOM" || textField.text == "TOP"){
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    //MARk: Imagepicker Delegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            phoneImageView.image = image
            shareButton.enabled = true
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: KeyboardNotification
    func subscribeToKeyboardNotification()  {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: "UIKeyboardWillShowNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillDismiss), name: "UIKeyboardWillHideNotification", object: nil)
    }
    func unsubscribeToKeyboardNotification()  {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    //MARK: Lift && Resume View Position
    func keyboardWillShow(notification:NSNotification)  {
        self.view.frame.origin.y = getKeyboardHeight(notification) * -1
    }
    
    func keyboardWillDismiss(notification:NSNotification)  {
        self.view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    //MARK: Meme save & share
    func generateMemedImage() -> UIImage {
        bottomBar.hidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage :UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        bottomBar.hidden = false
        return memedImage
    }
    
    func saveMeme() {
        let memedImage = generateMemedImage()
        
        currentMeme = Meme(topText: topText.text!, bottomText: bottomText.text!, rawImg: phoneImageView.image!, memeImage: memedImage )
        
       
    }
    
}

struct Meme {
    var topText:String
    var bottomText:String
    var image:UIImage
    var memedImage :UIImage
    
    init(topText:String = "TOP",bottomText:String = "BOTTOM",rawImg:UIImage,memeImage:UIImage){
        self.bottomText = bottomText
        self.topText = topText
        self.image = rawImg
        self.memedImage = memeImage
    }
}


