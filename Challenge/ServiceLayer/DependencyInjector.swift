//
//  DependencyInjector.swift
//  Challenge
//
//  Created by Aravindh on 15/12/22.
//

import Foundation
import Swinject
import CoreLocation

class DependencyInjector {
    
    private var container = Container()
    
    public static var defaultInjector: DependencyInjector = {
        let injector = DependencyInjector()
        return injector
    }()
    
    func getContainer() -> Container {
        return container
    }
    
    func reset() {
        container = Container()
        register()
    }
    
    public func register() {
        
        container.register(PreferenceManager.self) { r  in
            PreferenceManager()
        }.inObjectScope(ObjectScope.container)
        
        container.register(ApiManager.self) { r  in
            ApiManager(preferenceManager: r.resolve(PreferenceManager.self)!)
        }.inObjectScope(ObjectScope.container)
        
        //MARK: - Repository
        container.register(BaseRepository.self) { r  in
            BaseRepository(apiManager: r.resolve(ApiManager.self)!)
        }.inObjectScope(ObjectScope.container)
        
        container.register(LoginRepository.self) { r  in
            LoginRepository(apiManager: r.resolve(ApiManager.self)!)
        }.inObjectScope(ObjectScope.container)
        
        
        //MARK: - Model
        container.register(LoginViewModel.self) { r in
            LoginViewModel(baseRepository: r.resolve(LoginRepository.self)!)
        }.inObjectScope(ObjectScope.container)
        
        container.register(DashboardViewModel.self) { r in
            DashboardViewModel(baseRepository: r.resolve(LoginRepository.self)!)
        }.inObjectScope(ObjectScope.container)
    
    }
    
}
