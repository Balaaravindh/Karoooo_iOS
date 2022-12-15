//
//  LoginViewModel.swift
//  Challenge
//
//  Created by Aravindh on 15/12/22.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Alamofire

class LoginViewModel: BaseViewModel {
    
    var loginRegisterRepository: LoginRepository!
    
    var email = BehaviorRelay<String>(value: "")
    var password = BehaviorRelay<String>(value: "")
    var isPaswordShow = BehaviorRelay<Bool>(value: false)
    
    var countriesList = BehaviorRelay<[Countries]>(value: [Countries]())
    var filteredcountriesList = BehaviorRelay<[Countries]>(value: [Countries]())
    var selectedCountry = BehaviorRelay<Countries>(value: Countries())
        
    init(baseRepository: LoginRepository) {
        super.init(baseRepository: DependencyInjector.defaultInjector.getContainer().resolve(BaseRepository.self)!, preferenceManager: DependencyInjector.defaultInjector.getContainer().resolve(PreferenceManager.self)!)
        self.loginRegisterRepository = baseRepository
    }
    
    func getCountryList() {
        getCountries { [weak self]
            data in
            guard let countryList = data else { return }
            self?.filteredcountriesList.accept(countryList.countriesList ?? [])
            self?.countriesList.accept(countryList.countriesList ?? [])
        }
    }
    
    func isValidForm() -> Bool {
        return (email.value.isValidEmail() && password.value.isValidPassword() && selectedCountry.value.name != nil)
    }
        
    func getCountries(completion: @escaping(CountriesList?) -> Void) {
        readFromFile(fileName: "countries", completion: completion)
    }
    
    func readFromFile<T>(fileName: String, completion: @escaping (T?) -> Void) where T : Decodable {
        do {
            if let bundlePath = Bundle.main.path(forResource: fileName, ofType: "json"),
            let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
            let decodedData = try JSONDecoder().decode(T.self, from: jsonData)
                completion(decodedData)
            }
        }catch(let error) {
            ConsoleLog.d("JSON Read Errro --> \(error)")
        }
    }
    
}
