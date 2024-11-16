//
//  ViewController.swift
//  Amor
//
//  Created by 양승혜 on 10/23/24.
//

import UIKit
import SnapKit
import RxSwift

class HomeViewController: BaseVC<HomeView> {
    
    private let viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func configureNavigationBar() {
        navigationItem.leftBarButtonItems = [.init(customView: baseView.navBar.spaceImageView), .init(customView: baseView.navBar.spaceTitleLabel)]
        
        navigationItem.rightBarButtonItem = .init(customView: baseView.navBar.myProfileButton)
    }
    
    override func bind() {
        let input = HomeViewModel.Input(trigger: BehaviorSubject<Void>(value: ()))
        let output = viewModel.transform(input)
        
        output.dataSource
            .bind(with: self) { owner, value in
                print(value)
            }
            .disposed(by: disposeBag)
    }
}
