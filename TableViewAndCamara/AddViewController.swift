//
//  AddViewController.swift
//  TableViewAndCamara
//
//  Created by KurtHo on 2016/8/8.
//  Copyright © 2016年 Kurt. All rights reserved.
//

import UIKit
import CoreData

class AddViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var myTextField: UITextField!
    
    var imageFile: ImageFile?
    
    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    @IBAction func save(sender: AnyObject) {
        
        imageFile = NSEntityDescription.insertNewObjectForEntityForName("ImageFile", inManagedObjectContext: managedObjectContext)  as? ImageFile
        
        imageFile!.myLabel = myTextField.text
        
        appDelegate.saveContext()
        
        //在nav結束後，會直接出現↓↓↓
        self.navigationController?.popViewControllerAnimated(true)
        print("my image file ~~~\(imageFile?.myLabel)")

    }
    
    @IBAction func addPhoto(sender: AnyObject) {
        // Check if it support camera
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            // Load camera interface
            
            let picker : UIImagePickerController = UIImagePickerController()
            picker.sourceType = .Camera
            picker.delegate = self
            self.presentViewController(picker, animated: true, completion: nil)
            
        } else {
            // No camera available
            let alert = UIAlertController(title: "Error", message: "There is no camera available", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .Default, handler: { (alertAction) in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        if let source = imageFile {
            myTextField.text = source.myLabel
        }
        print("my image file ~~~\(imageFile?.myLabel)")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info["UIImagePickerControllerOriginalImage"] as! UIImage
        self.myImage.image = image
        UIImageWriteToSavedPhotosAlbum(self.myImage.image!, nil, nil, nil)
        //
        self.dismissViewControllerAnimated(true, completion: nil)
        
        imageFile = NSEntityDescription.insertNewObjectForEntityForName("ImageFile", inManagedObjectContext: managedObjectContext)  as? ImageFile
        imageFile?.myImage = UIImagePNGRepresentation(myImage.image!)
        
    }
    

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
}
