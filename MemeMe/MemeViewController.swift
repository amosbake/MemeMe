//
//
//  MemeMeViewController.swift
//
//  Created by Mopel on 16/8/18.
//  Copyright © 2016年 Mopel. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {
    @IBOutlet weak var bottomBar: UIToolbar!
    @IBOutlet weak var topToolBar: UIToolbar!
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
        
        self.view.bringSubviewToFront(topText)
        self.view.bringSubviewToFront(bottomText)
        
        /**TextField Init**/
        initTextField(topText)
        initTextField(bottomText)
        
        /**Init Other View**/
        resetView()
        
    }
    
    func initTextField(item: UITextField)  {
        item.defaultTextAttributes = memeTextAttributes
        item.delegate = self
        item.textAlignment = .Center
        item.borderStyle = UITextBorderStyle.None
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
    
    override func prefersStatusBarHidden() -> Bool {
        return true
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
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func shareMemeView()  {
        let memeImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        presentViewController(controller, animated: true, completion: nil)
        controller.completionWithItemsHandler = { (activity, success, items, error) in
            if(success){
                self.saveMeme(memeImage)
                self.dismissViewControllerAnimated(true, completion: nil)
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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeViewController.keyboardWillShow), name: "UIKeyboardWillShowNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeViewController.keyboardWillDismiss), name: "UIKeyboardWillHideNotification", object: nil)
    }
    func unsubscribeToKeyboardNotification()  {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    //MARK: Lift && Resume View Position
    func keyboardWillShow(notification:NSNotification)  {
        if bottomText.isFirstResponder() {
            self.view.frame.origin.y = getKeyboardHeight(notification) * -1
        }
    }
    
    func keyboardWillDismiss(notification:NSNotification)  {
        if bottomText.isFirstResponder() {
            self.view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    //MARK: Meme save & share
    func generateMemedImage() -> UIImage {
        bottomBar.hidden = true
        topToolBar.hidden = true
        
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage :UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        bottomBar.hidden = false
        topToolBar.hidden = false
        return memedImage
    }
    
    func saveMeme(memeImage :UIImage) {
        currentMeme = Meme(topText: topText.text!, bottomText: bottomText.text!, image: phoneImageView.image!, memedImage: memeImage )
        (UIApplication.sharedApplication().delegate as! AppDelegate).meme.append(currentMeme)
    }
    
}



