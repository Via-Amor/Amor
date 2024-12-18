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
    var coordinator: SearchChannelCoordinator?
    
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
        let enterNewChannelTrigger = PublishRelay<Channel>()
        let input = SearchChannelViewModel.Input(
            viewWillAppearTrigger: rx.methodInvoked(#selector(viewWillAppear))
                .map { _ in},
            selectedChannel: baseView.searchCollectionView.rx.modelSelected(ChannelList.self),
            enterNewChannelTrigger: enterNewChannelTrigger
        )
        
        let output = viewModel.transform(input)
        
        navigationItem.leftBarButtonItem?.rx.tap
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        output.spaceChannelList
            .drive(baseView.searchCollectionView.rx.items(
                cellIdentifier: SearchChannelCollectionViewCell.identifier,
                cellType: SearchChannelCollectionViewCell.self)
            ) { (row, element, cell) in
                cell.configureData(data: element)
            }
            .disposed(by: disposeBag)
        
        output.presentChannelChat
            .emit(with: self) { owner, channel in
                owner.dismiss(animated: true)
                owner.coordinator?.showChannelChat(channel: channel)
            }
            .disposed(by: disposeBag)
        
        output.presentChatEnterAlert
            .emit(with: self) { owner, channel in
                owner.coordinator?.showChatEnterAlert(channel: channel) {
                    enterNewChannelTrigger.accept(channel)
                }
            }
            .disposed(by: disposeBag)
    }
}

