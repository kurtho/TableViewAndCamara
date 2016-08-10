//
//  ImageFile+CoreDataProperties.swift
//  TableViewAndCamara
//
//  Created by KurtHo on 2016/8/9.
//  Copyright © 2016年 Kurt. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension ImageFile {

    @NSManaged var myLabel: String?
    @NSManaged var myImage: NSData?

}
