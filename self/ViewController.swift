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
    @IBOutlet var down: UISwipeGestureRecognizer!
    @IBOutlet var up: UISwipeGestureRecognizer!
    
    var selectImage = true
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        selfieView.contentMode = .ScaleAspectFill
        selfieView.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        selectImage = true
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func swipeUp(sender: AnyObject) {
        
        UIGraphicsBeginImageContextWithOptions(selfieView.bounds.size, false, UIScreen.mainScreen().scale)
        selfieView.drawViewHierarchyInRect(selfieView.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        showPicker()
    }
    
    @IBAction func swipeDown(sender: AnyObject) {
        self.showPicker()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        test.hidden = true
        self.selfieView.userInteractionEnabled = true
        self.selfieView.addGestureRecognizer(down)
        self.selfieView.addGestureRecognizer(up)
        self.selfieView.addSubview(test)
        // Do any additional setup after loading the view, typically from a nib.
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
            showPicker()
            selectImage = false
        } else {
            test.hidden = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

