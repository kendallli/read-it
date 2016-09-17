//
//  Read_ItRSSInfo+CoreDataProperties.swift
//  Read It
//
//  Created by Rui Li on 9/17/16.
//  Copyright © 2016 Smart Pollen. All rights reserved.
//

import Foundation
import CoreData


extension Read_ItRSSInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Read_ItRSSInfo> {
        return NSFetchRequest<Read_ItRSSInfo>(entityName: "RSSInfo");
    }

    @NSManaged public var title: String?
    @NSManaged public var summary: String?
    @NSManaged public var imageURL: String?
    @NSManaged public var identifier: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var link: String?

}
