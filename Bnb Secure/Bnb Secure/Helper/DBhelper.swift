//
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
        let query = "CREATE TABLE IF NOT EXISTS LogInTable(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,dateofbirth TEXT,phone TEXT,email TEXT,userid TEXT,password TEXT);"
        
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
    
    func insert(name : String, dateofbirth : String, phone : String, email : String, userid : String, password : String)
    {
        let query = "INSERT INTO LogInTable(id,name,dateofbirth,phone,email,userid,password) VALUES(?,?,?,?,?,?,?);"
        
        var statement : OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK
        {
            sqlite3_bind_text(statement, 2, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 3, (dateofbirth as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 4, (phone as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 5, (email as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 6, (userid as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 7, (password as NSString).utf8String, -1, nil)
            
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
    
    func read(){
        
        let query = "SELECT * FROM LogInTable;"
        var statement : OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK
        {
            while sqlite3_step(statement) == SQLITE_ROW
            {
                let id = Int(sqlite3_column_int(statement, 0))
                let name = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                let dateofbirth = String(describing: String(cString: sqlite3_column_text(statement, 2)))
                let phone = String(describing: String(cString: sqlite3_column_text(statement, 3)))
                let email = String(describing: String(cString: sqlite3_column_text(statement, 4)))
                let userid = String(describing: String(cString: sqlite3_column_text(statement, 5)))
                let pass = String(describing: String(cString: sqlite3_column_text(statement, 6)))
                                   
                                   
                print(id)
                print(name)
                print(dateofbirth)
                print(phone)
                print(email)
                print(userid)
                print(pass)
            }
        }
        
    }
                                    
    func update(id : Int, name : String, dateofbirth : String, phone : String, email : String, userid : String, pass : String) {
                    
        let query = "UPDATE LogInTable SET name = '\(name)', dateofbirth = '\(dateofbirth)', phone = '\(phone), email = '\(email), userid = '\(userid), pass = '\(pass)' WHERE id = \(id);"
        
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
