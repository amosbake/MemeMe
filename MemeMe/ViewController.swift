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
        NSForegroundColorAttributeName : UIColor.blackColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : Float(5)
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
        topText.contentVerticalAlignment = .Center
        topText.textAlignment = .Center
        bottomText.contentVerticalAlignment = .Center
        bottomText.textAlignment = .Center
        /**Init View**/
        resetView()
        
        /**Hide TextField Border**/
        topText.borderStyle = UITextBorderStyle.None
        bottomText.borderStyle = UITextBorderStyle.None
        
        /**textfield delegate**/
        topText.delegate = self
        bottomText.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.subscribeToKeyboardNotification()
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        phoneImageView.contentMode = .ScaleToFill
    }
    
    override func viewWillDisappear(animated: Bool) {
        unsubscribeToKeyboardNotification()
        super.viewWillDisappear(animated)
    }
    
    @IBAction func pickImageViewFromAlbum(sender: UIBarButtonItem) {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .PhotoLibrary
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func pickImageViewFromCamera(sender: UIBarButtonItem) {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .Camera
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func resetView() {
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        phoneImageView.image = nil
        shareButton.enabled = false
    }
    
    @IBAction func shareMemeView()  {
        saveMeme()
        let controller = UIActivityViewController(activityItems: [currentMeme.memedImage], applicationActivities: nil)
        
        presentViewController(controller, animated: true, completion: nil)
    }
    
    //MARK: textfieldDelegate
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
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
        self.view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    func keyboardWillDismiss(notification:NSNotification)  {
        self.view.frame.origin.y += getKeyboardHeight(notification)
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


