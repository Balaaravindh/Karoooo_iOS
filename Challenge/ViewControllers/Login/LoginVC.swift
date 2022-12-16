//
//  ViewController.swift
//  Challenge
//
//  Created by Aravindh on 15/12/22.
//

import UIKit
import RxCocoa
import RxSwift

class LoginVC: BaseViewController {
    
    @IBOutlet weak var countryView: UIView!
    @IBOutlet weak var countryTextFeild: UITextField!
    
    @IBOutlet weak var emailIDView: UIView!
    @IBOutlet weak var emailIDTextFeild: UITextField!
    
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordTextFeild: UITextField!
    @IBOutlet weak var passwordEyeImageView: UIImageView!
    
    @IBOutlet weak var submitBtnBG: UIView!
    var submitBtn: TransitionSubmitButton!
    
    private var loginModel: LoginViewModel!
    
    override func inject() {
        loginModel = DependencyInjector.defaultInjector.getContainer().resolve(LoginViewModel.self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
        buttonCreate()
        
        emailIDView.layer.borderColor = UIColor.white.cgColor
        emailIDView.layer.borderWidth = 1
        
        passwordView.layer.borderColor = UIColor.white.cgColor
        passwordView.layer.borderWidth = 1
        
        emailIDTextFeild.rx.text.orEmpty.bind(to: loginModel.email).disposed(by: disposeBag)
        passwordTextFeild.rx.text.orEmpty.bind(to: loginModel.password).disposed(by: disposeBag)

        emailIDTextFeild.delegate = self
        passwordTextFeild.delegate = self
        
        loginModel.getCountryList()
 
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        //Password Hide/Show
        loginModel.isPaswordShow.asObservable().subscribe(onNext: {
            [weak self] isPasswordShowBool in
            self?.passwordEyeImageView.image = isPasswordShowBool ? UIImage.init(systemName: "eye.fill") : UIImage.init(systemName: "eye.slash.fill")
            self?.passwordTextFeild.isSecureTextEntry = !isPasswordShowBool
        }).disposed(by: disposeBag)
        
        //Selected Country
        loginModel.selectedCountry.asObservable().subscribe(onNext: {
            [weak self] selectedCountryData in
            self?.countryTextFeild.text = selectedCountryData.name
        }).disposed(by: disposeBag)
        
        //Button Enable/Disable
        Observable.combineLatest(self.loginModel.email, self.loginModel.password, self.loginModel.selectedCountry, resultSelector: { [weak self] emailStr, passwordStr, selectedCountryData in
            if(self?.submitBtn != nil){
                let isValid = emailStr.trim().isValidEmail() && passwordStr.isValidPassword() && selectedCountryData.name != nil
                self?.submitBtn.isEnabled = isValid
                self?.submitBtn.alpha = isValid ? 1 : 0.5
            }
        }).subscribe().disposed(by: disposeBag)
        
    }
    
    func buttonCreate(){
        submitBtn = TransitionSubmitButton(frame: CGRect(x: 0, y: 0, width: self.submitBtnBG.frame.size.width, height: self.submitBtnBG.frame.size.height))
        submitBtn.center = submitBtn.center
        submitBtn.layer.cornerRadius = submitBtn.frame.height / 2
        submitBtn.backgroundColor = UIColor.white
        submitBtn.setTitle("SUBMIT", for: UIControl.State())
        submitBtn.setTitleColor(UIColor.init(named: "login-center-bg"), for: .normal)
        submitBtn.titleLabel?.font = UIFont(name: "Verdana-Bold", size: 16)
        submitBtn.spinnerColor = UIColor.init(named: "login-center-bg") ?? .lightGray
        submitBtn.addTarget(self, action: #selector(submitBtnAction), for: UIControl.Event.touchUpInside)
        submitBtnBG.addSubview(submitBtn)
    }
    
    @IBAction func passwordHideShowBtn(_ sender: UIButton) {
        loginModel.isPaswordShow.accept(!loginModel.isPaswordShow.value)
    }

    @IBAction func selectCountriesBtn(_ sender: UIButton) {
        let container = UIStoryboard(storyboard: .main).instantiateViewController(withIdentifier: "SelectCountriesVC")
        let navController = UINavigationController(rootViewController: container)
        navController.isNavigationBarHidden = true
        navController.modalPresentationStyle = .overCurrentContext
        self.present(navController, animated: true, completion: nil)
    }
    
    @objc func submitBtnAction(_ sender: TransitionSubmitButton){
        if(loginModel.isValidForm()){
            submitBtn.animate(1, completion: { () -> () in
                let container = UIStoryboard(storyboard: .dashboard).instantiateViewController(identifier: "DashboardVC")
                container.transitioningDelegate = self
                container.modalPresentationStyle = .fullScreen
                self.present(container, animated: true, completion: nil)
            })
        }else{
            
        }
    }

}

extension LoginVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case emailIDTextFeild:
            Observable.combineLatest(self.loginModel.email, self.loginModel.password, resultSelector: {
                [weak self] emailStr, passwordStr in
                self?.emailIDView.layer.borderColor = emailStr.trim().isValidEmail() ? UIColor.white.cgColor : UIColor.red.cgColor
            }).subscribe().disposed(by: disposeBag)
            
            break
        case passwordTextFeild:
            Observable.combineLatest(self.loginModel.email, self.loginModel.password, resultSelector: {
                [weak self] emailStr, passwordStr in
                self?.passwordView.layer.borderColor = passwordStr.isValidPassword() ? UIColor.white.cgColor : UIColor.red.cgColor
            }).subscribe().disposed(by: disposeBag)
            break
        default:
            break
        }
        return true
    }
    
}

extension LoginVC: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeInAnimator(transitionDuration: 0.5, startingAlpha: 0.8)
    }
       
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
}
