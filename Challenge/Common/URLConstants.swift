//
//  URLConstants.swift
//  Challenge
//
//  Created by Aravindh on 15/12/22.
//

import Foundation

struct URLConstants{
    static func getBaseURL() -> String {
        let baseURL = "http://172.16.4.22:8173/"
        return baseURL
    }
    static let url = URLConstants.getBaseURL()
    static var BASEURL = url
}
