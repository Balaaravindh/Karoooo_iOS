//
//  DashboardVC.swift
//  Challenge
//
//  Created by Aravindh on 16/12/22.
//

import UIKit

class DashboardVC: BaseViewController {
    
    @IBOutlet weak var dashboardListTableView: UITableView!
    
    private var dashboardVM: DashboardViewModel!
    
    override func inject() {
        dashboardVM = DependencyInjector.defaultInjector.getContainer().resolve(DashboardViewModel.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dashboardListTableView.dataSource = self
        dashboardListTableView.reloadData()
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

extension DashboardVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardCell", for: indexPath) as! DashboardCell
        cell.cardView.cardView()
        return cell
    }
    
    
    
    
}
