//
//  CountriesModel.swift
//  Challenge
//
//  Created by Aravindh on 15/12/22.
//

import Foundation

struct CountriesList: Codable {
    var countriesList: [Countries]?
}

struct Countries: Codable {
    var name: String?
    var code: String?
}
