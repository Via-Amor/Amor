//
//  ChatViewController.swift
//  Amor
//
//  Created by 홍정민 on 11/23/24.
//

import UIKit
import RxSwift
import RxCocoa
import PhotosUI

final class ChatViewController: BaseVC<ChatView> {
    var coordinator: ChatCoordinator?
    let viewModel: ChatViewModel
    private let selectedImages = BehaviorRelay<[UIImage]>(value: [])
        
    init(viewModel: ChatViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView() {
        view.backgroundColor = .themeWhite
        tabBarController?.tabBar.isHidden = true
    }
    
    // 우측 바버튼 설정
    override func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: Design.TabImage.homeSelected,
            style: .plain,
            target: nil,
            action: nil
        )
    }

    // 네비게이션 영역 타이틀 설정
    private func configureNavigationContent(_ content: Channel) {
        let channelName = content.name
//        let memberCount = content.memberCount.formatted()
        let titleName = channelName
        
        let attributedTitle = NSMutableAttributedString(string: titleName)
//        attributedTitle.addAttribute(
//            .font,
//            value: UIFont.boldSystemFont(ofSize: 17),
//            range: titleName.findRange(str: titleName)!
//        )
        
//        if let range = titleName.findRange(str: memberCount) {
//            attributedTitle.addAttribute(.foregroundColor, value: UIColor.textSecondary, range: range)
//        }
//        
        let titleLabel = UILabel()
        titleLabel.attributedText = attributedTitle
        navigationItem.titleView = titleLabel
    }
    
    override func bind() {
        let input = ChatViewModel.Input(
            viewDidLoadTrigger: Observable.just(())
        )
        
        let output = viewModel.transform(input)
        
        output.navigationContent
            .drive(with: self) { owner, content in
                owner.configureNavigationContent(content)
            }
            .disposed(by: disposeBag)
        
        output.presentChatList
            .drive(baseView.chatTableView.rx.items(cellIdentifier: ChatTableViewCell.identifier, cellType: ChatTableViewCell.self)) { (row, element, cell) in
               cell.configureData(data: element)
               cell.selectionStyle = .none
            }
            .disposed(by: disposeBag)
        
        baseView.chatInputView.chatInputTextView.rx.text
            .distinctUntilChanged()
            .bind(with: self) { owner, value in
                owner.baseView.chatInputView.updateTextViewHeight()
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(baseView.chatInputView.chatInputTextView.rx.text.orEmpty, selectedImages)
            .map { $0.0.isEmpty && $0.1.isEmpty }
            .bind(with: self) { owner, value in
                owner.baseView.chatInputView.setSendButtonImage(isEmpty: value)
            }
            .disposed(by: disposeBag)
        
        
        baseView.chatInputView.chatInputTextView.rx.text.orEmpty
            .map { !$0.isEmpty }
            .bind(to: baseView.chatInputView.placeholderLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        selectedImages
            .bind(to: baseView.chatInputView.chatAddImageCollectionView.rx.items(cellIdentifier: ChatAddImageCell.identifier, cellType: ChatAddImageCell.self)) { (index, item, cell) in
                cell.configureUI(image: item)
                
                cell.cancelButtonTap()
                    .map({ index })
                    .bind(with: self) { owner, value in
                        owner.removeImage(at: value)
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        baseView.chatInputView.addFileButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.showPHPickerView()
            }
            .disposed(by: disposeBag)
    }
}

extension ChatViewController {
    private func configureView() {
        view.backgroundColor = .themeWhite
        tabBarController?.tabBar.isHidden = true
        
    }
    
    private func removeImage(at index: Int) {
        var currentImages = selectedImages.value
        currentImages.remove(at: index)
        selectedImages.accept(currentImages)
        
        remakeCollectionViewLayout()
    }
    
    func remakeCollectionViewLayout() {
        baseView.chatInputView.chatAddImageCollectionView.isHidden = selectedImages.value.isEmpty
        baseView.chatInputView.updateTextViewHeight()
    }
}

extension ChatViewController: PHPickerViewControllerDelegate {
    func showPHPickerView() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 5
        configuration.selection = .ordered
        configuration.filter = .images
        
        let pickerView = PHPickerViewController(configuration: configuration)
        pickerView.delegate = self
        present(pickerView, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        Task {
            var photoImages: [UIImage] = []
            
            for result in results {
                if let image = await loadImage(result: result) {
                    photoImages.append(image)
                }
            }
            
            self.selectedImages.accept(photoImages)
            self.remakeCollectionViewLayout()
        }
    }
    
    func loadImage(result: PHPickerResult) async -> UIImage? {
        return await withCheckedContinuation { continuation in
            let itemProvider = result.itemProvider
            itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
                if let image = object as? UIImage {
                    continuation.resume(returning: image)
                } else {
                    continuation.resume(returning: nil)
                }
            }
        }
    }
}
