//
//  DataService.swift
//  Chevaun
//
//  Created by Nishant Punia on 24/12/16.
//  Copyright © 2016 MLBNP. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = FIRDatabase.database().reference()
let STORAGE_BASE = FIRStorage.storage().reference()
let USER_ID = FIRAuth.auth()?.currentUser?.uid

class DataService {
    
    private static let _instance = DataService()
    
    static var instance: DataService {
        return _instance
    }
    
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_ACTIVITIES = DB_BASE.child("activities")
    private var _REF_FRIENDS = DB_BASE.child("friends")
    private var _REF_EXPERIENCES = DB_BASE.child("experiences")
    private var _REF_ACTIVITYIMAGES = STORAGE_BASE.child("activity-pics")
    private var _REF_FRIENDIMAGES = STORAGE_BASE.child("friend-pics")

    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
    var REF_ACTIVITIES: FIRDatabaseReference {
        return _REF_ACTIVITIES
    }
    
    var REF_FRIENDS: FIRDatabaseReference {
        return _REF_FRIENDS
    }
    
    var REF_EXPERIENCES: FIRDatabaseReference {
        return _REF_EXPERIENCES
    }
    
    var REF_ACTIVITYIMAGES: FIRStorageReference {
        return _REF_ACTIVITYIMAGES
    }
    
    var REF_FRIENDIMAGES: FIRStorageReference {
        return _REF_FRIENDIMAGES
    }
    
    
    func saveUser(uid: String, userData: Dictionary<String,String>) {
        REF_USERS.child(uid).updateChildValues(userData)
        
    }
    
    
}

//Best Practice - save "users" and other stuff like that as constants.
