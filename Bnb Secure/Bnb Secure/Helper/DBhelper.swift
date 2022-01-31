// Need to do more testing on all functions




//  DBhelper.swift
//  Bnb Secure
//
//  Created by Mohamed Soliman on 1/29/22.
//

import Foundation
import SQLite3

class DBhelper {
    var db : OpaquePointer?
    var path : String = "myDatabase.sqlite"
    init () {
        self.db = createDB()
        self.createtable()
        
    }
    
    func createDB() -> OpaquePointer? {
        let filepath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathExtension(path)
        
        var db: OpaquePointer? = nil
        
        if sqlite3_open(filepath.path, &db) != SQLITE_OK {
            print("Error creating database")
            return nil
        }else {
            print("Database is created \(path)")
            return db
        }
    }
    func createtable() {
        let query = "CREATE TABLE IF NOT EXISTS LogInTable(userid TEXT PRIMARY KEY,password INTEGER);"
        
        var statement : OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE{
                print("Table creation success")
            }else{
                print("Table creation fail")
            }
            
        }else {
            print("Preparation fail")
            
        }
    }
    
    func insert(userid : String, password : Int)
    {
        let query = "INSERT INTO LogInTable(userid,password) VALUES(?,?)"
        
        var statement : OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK
        {
            sqlite3_bind_text(statement, 1, (userid as NSString).utf8String, -1, nil)
            sqlite3_bind_int(statement, 2, (password as NSNumber).int32Value)
            
            if sqlite3_step(statement) == SQLITE_DONE
            {
                print("Data insertion success")
            }else{
                print("Data is not inserted")
            }
            
        }else{
            print("Insertion error")
        }
    }
    
    func read() -> "return depends on how the inputs are programed"{
        
        let query = "SELECT * FROM LogInTable;"
        var statement : OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK
        {
            while sqlite3_step(statement) == SQLITE_ROW
            {
                let userid = String(describing : sqlite3_column_text(statement, 0)
                let password = Int(sqlite3_column_count(1))
                                    
                print(userid)
                print(password)
            }
        }
        
    }
                                    
        func update (userid : String, password : Int) {
                    
            let query = "UPDATE LogInTable SET userid = '\(userid)', password = '\(password)';"
            var statement : OpaquePointer? = nil
             if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
               if sqlite3_step(statement) == SQLITE_DONE {
                   print("Data updated success")
               }else {
                   print("Data is not updated in table")
                }
             }
        }
  }
