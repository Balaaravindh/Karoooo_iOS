//
//  BaseViewController.swift
//  Challenge
//
//  Created by Aravindh on 15/12/22.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class BaseViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inject()
    }
    
    func inject(){
    }
    
}
