//
//  UserSettings.swift
//  LocalStorageDemo
//
//  Created by Hristo Lesev on 2/11/16.
//  Copyright © 2016 DiaDraw. All rights reserved.
//

import Foundation

class UserSettings : NSObject, NSCoding {
    var userName : String
    var lovesPizza : Bool
    var age: Int
    var nickNames: [String]
    
    // Memberwise initializer
    init(userName: String, lovesPizza: Bool, age: Int, nickNames: [String]) {
        self.userName = userName
        self.lovesPizza = lovesPizza
        self.age = age
        self.nickNames = nickNames
    }
    
    //Print all properties of the class
    override var description: String {
            return "UserSettings: \(userName), \(lovesPizza), \(age), \(nickNames)"
    }
    
    // MARK: NSCoding
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.userName, forKey: "userName")
        coder.encodeBool(self.lovesPizza, forKey: "lovesPizza")
        coder.encodeInt(Int32(self.age), forKey: "age")
        coder.encodeObject(self.nickNames, forKey: "nickNames")
    }
    
    required convenience init?(coder decoder: NSCoder) {
        guard let userName = decoder.decodeObjectForKey("userName") as? String else {
            return nil
        }
        
        let lovesPizza = decoder.decodeBoolForKey("lovesPizza");
        
        let age = decoder.decodeIntegerForKey("age");
        
        guard let nickNames = decoder.decodeObjectForKey("nickNames") as? [String] else {
            return nil
        }
        
        self.init(
            userName: userName,
            lovesPizza: lovesPizza,
            age: age,
            nickNames: nickNames
        )
    }
}