//
//  ViewController.swift
//  TableViewAndCamara
//
//  Created by KurtHo on 2016/8/5.
//  Copyright © 2016年 Kurt. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var imageList: [ImageFile] = [ImageFile]()
    
    
    var pictureLists: [PictureList] = [
    PictureList(pic: "sky", content: "123"),
    PictureList(pic: "sky", content: "234"),
    PictureList(pic: "sky", content: "333")
    
    ]
    
    
    

    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addButton(sender: AnyObject) {
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
     reloadData()
//        let book = NSEntityDescription.insertNewObjectForEntityForName("ImageFile", inManagedObjectContext: managedObjectContext) as! ImageFile
//        
//        book.myLabel = "001"
//
//        
//        appDelegate.saveContext()
//        
//        //↓下面是load資料
//        do {
//            let fetchRequest = NSFetchRequest(entityName: "ImageFile")
//            let bookArray: [ImageFile] = try managedObjectContext.executeFetchRequest(fetchRequest) as! [ImageFile]
//            
//            for book1 in bookArray {
//                print("book1.isbn \(book1.myLabel)")
//            }
//        } catch {
//            print(error)
//        }
        
    }

    override func viewWillAppear(animated: Bool) {
        
        if !imageList.isEmpty {
           print("index0: \(imageList[0])")
        }
        print("imageList.count~~~~~\(imageList.count)")
        
        reloadData()
//        print("image list . content~~~~\(imageList)")

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    // MARK: - table view
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return imageList.count
    }
    
    var photo = "sky"
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! TableViewCell
        cell.myImage.image = UIImage(data: imageList[indexPath.row].myImage!)
        cell.myLabel.text = imageList[indexPath.row].myLabel
        return cell
    }
    
    
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Share", handler: {
            (action, indexPath) -> Void in
            let defaultText = "Just checking in at " + self.pictureLists[indexPath.row].content
            if let imageToShare = UIImage(named: self.pictureLists[indexPath.row].pic) {
                let activityController = UIActivityViewController(activityItems: [defaultText, imageToShare], applicationActivities: nil)
                self.presentViewController(activityController, animated: true, completion: nil)
            }
            
        })
        //刪除按鈕
        let deleteAction = UITableViewRowAction(style:
            UITableViewRowActionStyle.Default, title: "Delete", handler: { (action, indexPath)  -> Void in
                //從data source刪除列
                    let obj = self.imageList[indexPath.row]
                    self.managedObjectContext.deleteObject(obj)
                    self.appDelegate.saveContext()
                    self.reloadData()

                
                
        })
        
        shareAction.backgroundColor = UIColor.blueColor()
        deleteAction.backgroundColor = UIColor(red: 202.0/255.0, green: 202.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        return [deleteAction, shareAction]
    }
    
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Edit" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destinationViewController as! ImageViewController
                destinationController.storage = pictureLists[indexPath.row]
//                destinationController.myTextField.text = imageList[indexPath.row].myLabel
            }
        }
    }
    

    
    
    
    // MARK: - camara function
    
    func imagePickerController(picker: UIImagePickerController,didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let image = info["UIImagePickerControllerOriginalImage"] as! UIImage
        
        
//        self.myImage.image = image
        
        let paths =
            NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths.first
        let interval = NSDate.timeIntervalSinceReferenceDate()
        let name = "\(interval).jpg"
        let path = (documentsDirectory as
            NSString?)?.stringByAppendingPathComponent(name)
        let data = UIImageJPEGRepresentation(image, 0.9)
        data?.writeToFile(path!, atomically: true)
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    
    func reloadData() {
        do {
            let fetchRequest = NSFetchRequest(entityName: "ImageFile")
            //搬資料↑↑
            let sortDescriptor = NSSortDescriptor(key: "myLabel", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]

            
            imageList = try managedObjectContext.executeFetchRequest(fetchRequest) as! [ImageFile]
            //搬東西出來，轉型，到[Book]陣列
            
            tableView.reloadData()
        } catch {
            print(error)
        }
    }
    
    
    
}


class PictureList {
    var pic: String
    var content: String
    init(pic: String, content: String){
        self.pic = pic
        self.content = content
    }
}



