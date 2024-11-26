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
    

    override func configureNavigationBar() {
        let chatName = viewModel.channel.name
        let participant = 14
        let titleName = chatName + " \(participant)"
        
        let attributedTitle = NSMutableAttributedString(string: titleName)
        attributedTitle.addAttribute(
            .font,
            value: UIFont.boldSystemFont(ofSize: 17),
            range: titleName.findRange(str: titleName)!
        )
        
        if let range = titleName.findRange(str: "\(participant)") {
            attributedTitle.addAttribute(.foregroundColor, value: UIColor.textSecondary, range: range)
        }
        
        let titleLabel = UILabel()
        titleLabel.attributedText = attributedTitle
        navigationItem.titleView = titleLabel
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "Home_selected"),
            style: .plain,
            target: nil,
            action: nil
        )
    }
    
    override func bind() {
        Observable.just(chatList)
            .bind(to: baseView.chatTableView.rx.items(cellIdentifier: ChatTableViewCell.identifier, cellType: ChatTableViewCell.self)) { (row, element, cell) in
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
        if selectedImages.value.isEmpty {
            baseView.chatInputView.chatAddImageCollectionView.isHidden = true
        } else {
            baseView.chatInputView.chatAddImageCollectionView.isHidden = false
        }
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
        
        var photoImages: [UIImage] = []
        let dispatchGroup = DispatchGroup()
        
        for result in results {
            dispatchGroup.enter()
            let itemProvider = result.itemProvider
            itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
                if let image = object as? UIImage {
                    photoImages.append(image)
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.selectedImages.accept(photoImages)
            self.remakeCollectionViewLayout()
        }
    }
}
