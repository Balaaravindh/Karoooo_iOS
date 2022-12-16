//
//  DashboardVC.swift
//  Challenge
//
//  Created by Aravindh on 16/12/22.
//

import UIKit

class DashboardVC: BaseViewController {
    
    private var dashboardVM: DashboardViewModel!
    
    override func inject() {
        dashboardVM = DependencyInjector.defaultInjector.getContainer().resolve(DashboardViewModel.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dashboardApiCall()
        
    }
    
    func dashboardApiCall(){
        dashboardVM.getDashboardMasterData(disposeBag: disposeBag){
            [weak self] (error, isSuccess, message) in
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
