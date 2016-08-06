//
//  ImageViewController.swift
//  TableViewAndCamara
//
//  Created by KurtHo on 2016/8/5.
//  Copyright © 2016年 Kurt. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var myTextField: UITextField!
    @IBOutlet weak var scroll: UIScrollView!
    
    var storage: PictureList!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scroll.minimumZoomScale = 1
        self.scroll.maximumZoomScale = 4
        
        imageView.image = UIImage(named: storage.pic)
        myTextField.text = storage.content
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
