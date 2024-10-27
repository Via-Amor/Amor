//
//  BaseVC.swift
//  Amor
//
//  Created by 김상규 on 10/27/24.
//

import UIKit

class BaseVC<V: BaseView>: UIViewController {
    
    
    override func loadView() {
        view = V()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        bind()
    }
    
    func configureNavigationBar() { }
    func bind() { }
}
