//
//  BaseVC.swift
//  Amor
//
//  Created by 김상규 on 10/27/24.
//

import UIKit
import RxSwift

class BaseVC<V: UIView>: UIViewController {
    let baseView: V
    let disposeBag = DisposeBag()
    
    init(baseView: V = V()) {
        self.baseView = baseView
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = baseView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        bind()
    }
    
    func configureNavigationBar() { }
    func bind() { }
}
