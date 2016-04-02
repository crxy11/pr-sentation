//
//  ViewController.swift
//  self
//
//  Created by Jan Lagarden on 01.04.16.
//  Copyright © 2016 Jan Lagarden. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var test: UIImageView!
    @IBOutlet weak var selfieView: UIImageView!
    @IBOutlet var pan: UIPanGestureRecognizer!
    @IBOutlet weak var saveIcon: UIButton!
    @IBOutlet weak var deletIcon: UIButton!
    
    var image : UIImage? = nil
    var selectImage = true
    var centery = CGFloat(0)
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        selfieView.contentMode = .ScaleAspectFill
        selfieView.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        selectImage = true
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func pan(sender: AnyObject) {
        let translation = sender.translationInView(self.view)
        sender.view!.center = CGPoint(x: sender.view!.center.x, y: sender.view!.center.y + translation.y)
        sender.setTranslation(CGPointZero, inView: self.view)
        if(sender.view!.center.y < centery - (UIScreen.mainScreen().bounds.height/2)) {
            swipeUp(sender)
        }
        
        if(sender.view!.center.y > centery + (UIScreen.mainScreen().bounds.height/2)) {
            swipeDown(sender)
        }
        
        if(sender.state == .Ended) {
            if (self.selfieView.center.y != self.centery) {
                self.selfieView.center.y = self.centery
            }
        }
    }
    
    func swipeUp(sender: AnyObject) {
        if(self.image != nil) {
            UIImageWriteToSavedPhotosAlbum(self.image!, nil, nil, nil)
        }
        showPicker()
    }
    
    func screenShot() {
        UIGraphicsBeginImageContextWithOptions(selfieView.bounds.size, false, UIScreen.mainScreen().scale)
        selfieView.drawViewHierarchyInRect(selfieView.bounds, afterScreenUpdates: true)
        self.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    func swipeDown(sender: AnyObject) {
       self.showPicker()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        test.hidden = true
        self.selfieView.userInteractionEnabled = true
        self.selfieView.addGestureRecognizer(pan)
        self.selfieView.addSubview(test)
        self.centery = self.selfieView.center.y;
        
    }
    
    
    func showPicker() {
        selectImage = false
        let picker = UIImagePickerController()
        let screenBounds: CGSize = UIScreen.mainScreen().bounds.size
        let scale = screenBounds.height / screenBounds.width
        
        picker.delegate = self
        picker.sourceType = UIImagePickerControllerSourceType.Camera
        picker.allowsEditing = false
        picker.cameraViewTransform = CGAffineTransformScale(picker.cameraViewTransform, scale, scale)
        
        self.presentViewController(picker, animated: false, completion: nil)
        

    }
    
    override func viewDidAppear(animated: Bool) {
        if(selectImage) {
            test.hidden = true
            saveIcon.hidden = true
            deletIcon.hidden = true
            showPicker()
            selectImage = false
        } else {
            test.hidden = false
            screenShot()
            saveIcon.hidden = false
            deletIcon.hidden = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

