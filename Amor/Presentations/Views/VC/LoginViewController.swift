//
//  LoginViewController.swift
//  Amor
//
//  Created by 홍정민 on 11/13/24.
//

import UIKit

final class LoginViewController: BaseVC<LoginView> {
    let viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func bind() {
        let input = LoginViewModel.Input()
        let output = viewModel.transform(input)
        
        
    }
    
}

