//
//  URLConstants.swift
//  Challenge
//
//  Created by Aravindh on 15/12/22.
//

import Foundation

struct URLConstants{
    static func getBaseURL() -> String {
        let baseURL = "https://jsonplaceholder.typicode.com/"
        return baseURL
    }
    static let url = URLConstants.getBaseURL()
    static var BASEURL = url
}
