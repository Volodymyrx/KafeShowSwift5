//
//  StorageManager.swift
//  KafeShowSwift5
//
//  Created by v on 06.04.2020.
//  Copyright © 2020 volodiax. All rights reserved.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static func saveObject(_ place: Place){
        try! realm.write {
            realm.add(place)
        }
        
    }

    
    
}





