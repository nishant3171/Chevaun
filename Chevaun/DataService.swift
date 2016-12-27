//
//  DataService.swift
//  Chevaun
//
//  Created by Nishant Punia on 24/12/16.
//  Copyright © 2016 MLBNP. All rights reserved.
//

import Foundation
import FirebaseDatabase

let DB_BASE = FIRDatabase.database().reference()

class DataService {
    
    private static let _instance = DataService()
    
    static var instance: DataService {
        return _instance
    }
    
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
    func saveUser(uid: String, userData: Dictionary<String,String>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
}

//Best Practice - save "users" and other stuff like that as constants.
