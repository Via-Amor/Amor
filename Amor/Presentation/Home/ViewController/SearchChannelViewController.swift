//
//  SearchChannelViewController.swift
//  Amor
//
//  Created by 홍정민 on 12/18/24.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchChannelViewController: BaseVC<SearchChannelView> {
    let viewModel: SearchChannelViewModel
    
    init(viewModel: SearchChannelViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    override func configureNavigationBar() {
        navigationItem.title = Navigation.Channel.search
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: .xmark,
            style: .plain,
            target: nil,
            action: nil
        )
        navigationItem.leftBarButtonItem?.tintColor = .black
    }
    
    override func bind() {
        let input = SearchChannelViewModel.Input(
            viewWillAppearTrigger: rx.methodInvoked(#selector(viewWillAppear))
                .map { _ in}
        )
        
        navigationItem.leftBarButtonItem?.rx.tap
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        Observable.just(channelList)
            .bind(to: baseView.searchCollectionView.rx.items(
                cellIdentifier: SearchChannelCollectionViewCell.identifier,
                cellType: SearchChannelCollectionViewCell.self)
            ) { (row, element, cell) in
            }
            .disposed(by: disposeBag)
    }
}

let channelList = ["하이", "하이", "하이"]
