//
//  SelectCountriesVC.swift
//  Challenge
//
//  Created by Aravindh on 15/12/22.
//

import UIKit
import RxCocoa
import RxSwift

class SelectCountriesVC: BaseViewController {
    
    @IBOutlet weak var countriesTableView: UITableView!
    @IBOutlet weak var searchTextFeild: UITextField!

    private var loginModel: LoginViewModel!
    
    override func inject() {
        loginModel = DependencyInjector.defaultInjector.getContainer().resolve(LoginViewModel.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loginModel.filteredcountriesList.accept(loginModel.countriesList.value)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginModel.filteredcountriesList.asObservable().bind(to: self.countriesTableView.rx.items(cellIdentifier: CountryCell.Identifier, cellType: CountryCell.self)){
            row, singleModel, cell in
            cell.updateUI(countryModel: singleModel, selectedCountry: self.loginModel.selectedCountry.value)
        }.disposed(by: disposeBag)
        
        searchTextFeild.delegate = self
        countriesTableView.delegate = self

    }
    
    @IBAction func closeBtnAction(_ sender: UIButton) {
        self.navigationController?.dismiss(animated: true)
    }

}

extension SelectCountriesVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        loginModel.selectedCountry.accept(loginModel.filteredcountriesList.value[indexPath.row])
        dismiss(animated: true)
    }
    
}

extension SelectCountriesVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var neededTxt = ""
        let originalText = textField.text ?? ""
        if string != "" {
            neededTxt = originalText == "" ? string : originalText + string
        }else{
            neededTxt = String(originalText.dropLast())
        }
        loginModel.filteredcountriesList.accept(loginModel.countriesList.value.filter({ $0.name?.lowercased().contains(neededTxt) ?? false }))
        return true
    }
    
}
