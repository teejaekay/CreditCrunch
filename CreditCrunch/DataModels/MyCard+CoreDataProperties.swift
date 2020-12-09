//
//  MyCard+CoreDataProperties.swift
//  CreditCrunch
//
//  Created by Taylor Kelly on 11/28/20.
//  Copyright © 2020 Taylor Kelly. All rights reserved.
//
//

import Foundation
import CoreData


extension MyCard {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyCard> {
        return NSFetchRequest<MyCard>(entityName: "MyCard")
    }

    @NSManaged public var name: String?

}
