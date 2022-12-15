//
//  CountryCell.swift
//  Challenge
//
//  Created by Aravindh on 15/12/22.
//

import UIKit

class CountryCell: UITableViewCell {
    
    static let Identifier = "CountryCell"
    
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var countrySelected: UIImageView!
    
    func updateUI(countryModel: Countries, selectedCountry: Countries){
        countryName.text = countryModel.name
        countrySelected.image = selectedCountry.code?.lowercased() == countryModel.code?.lowercased() ? UIImage.init(systemName: "checkmark.circle.fill") : UIImage.init(systemName: "circle")
    }

}
