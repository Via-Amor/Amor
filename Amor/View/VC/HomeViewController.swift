//
//  ViewController.swift
//  Amor
//
//  Created by 양승혜 on 10/23/24.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
    let dummyLabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.Size.title1
        label.text = "HomeVC"
        return label
    }()
    
    let appleButton = CommonButton(title: "Apple로 계속하기", foregroundColor: .white, backgroundColor: .themeBlack)
    let divider = DividerView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // dummy label
        view.addSubview(dummyLabel)
        dummyLabel.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
        }
        
        // test custom buttton
        view.addSubview(appleButton)
        appleButton.snp.makeConstraints { make in
            make.top.equalTo(dummyLabel.snp.bottom).offset(50)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        // test custom divider
        view.addSubview(divider)
        divider.snp.makeConstraints { make in
            make.top.equalTo(appleButton.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
