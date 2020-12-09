//
//  UserImage+CoreDataProperties.swift
//  CreditCrunch
//
//  Created by Taylor Kelly on 11/28/20.
//  Copyright © 2020 Taylor Kelly. All rights reserved.
//
//

import Foundation
import CoreData


extension UserImage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserImage> {
        return NSFetchRequest<UserImage>(entityName: "UserImage")
    }

    @NSManaged public var img: Data?

}
