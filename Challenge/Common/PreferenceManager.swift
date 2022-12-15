//
//  PreferenceManager.swift
//  Challenge
//
//  Created by Aravindh on 15/12/22.
//

import Foundation


class PreferenceManager {
    
    func set(key:String, value:String){
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func get(key:String) -> String?{
        return UserDefaults.standard.string(forKey: key)
    }
    
    func set(key:String, value:Bool){
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }

    func getInt(key:String) -> Int?{
        let value =  UserDefaults.standard.integer(forKey:key)
        if value == 0 {
            return nil
        }else{
            return value
        }
    }
    
    func set(key:String, value:Int){
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func setDate(key:String, value:Date){
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }

    func getDate(key:String) -> Date?{
        return UserDefaults.standard.value(forKey: key) as? Date
    }
    
    func getBool(key:String) -> Bool{
        return UserDefaults.standard.bool(forKey:key)
    }
    
    func remove(key:String){
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    func clearBearerToken(){
        UserDefaults.standard.synchronize()
    }

    func clear(){
        UserDefaults.standard.synchronize()
    }
    
    func clearUserDetail() {
        UserDefaults.standard.synchronize()
    }
}
