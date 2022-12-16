//
//  DashboardViewModel.swift
//  Challenge
//
//  Created by Aravindh on 16/12/22.
//

import Foundation
import RxSwift
import RxCocoa

class DashboardViewModel: BaseViewModel {
    
    var loginRegisterRepository: LoginRepository!
    
    init(baseRepository: LoginRepository) {
        super.init(baseRepository: DependencyInjector.defaultInjector.getContainer().resolve(BaseRepository.self)!, preferenceManager: DependencyInjector.defaultInjector.getContainer().resolve(PreferenceManager.self)!)
        self.loginRegisterRepository = baseRepository
    }
    
    func getDashboardMasterData(disposeBag: DisposeBag, completion:@escaping (Error?, Bool, String)->Void) {
        self.loginRegisterRepository.getMasterData().asObservable().subscribe(onNext: {
            [weak self] (response) in
            if let responseDictionary = response as? NSArray {
                 
                completion(nil, true, "")
            }else{
                completion(nil, false, "")
            }
        }, onError: { (error) in
            completion(error, false, error.localizedDescription)
        }).disposed(by: disposeBag)
    }
}
