//
//  ToDo+CoreDataProperties.swift
//  TpDo App
//
//  Created by dev on 2019-05-13.
//  Copyright © 2019 dev. All rights reserved.
//
//

import Foundation
import CoreData


extension ToDo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDo> {
        return NSFetchRequest<ToDo>(entityName: "ToDo")
    }

    @NSManaged public var task: String?

}
