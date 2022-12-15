//
//  BaseViewModel.swift
//  Challenge
//
//  Created by Aravindh on 15/12/22.
//

import Foundation

class BaseViewModel {
    
    var baseRepository: BaseRepository!
    var PreferenceManagers: PreferenceManager!
    
    init(baseRepository: BaseRepository, preferenceManager: PreferenceManager) {
        self.baseRepository = baseRepository
        self.PreferenceManagers = preferenceManager
    }
    
}
