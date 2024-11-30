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
import Toast

final class ChatViewController: BaseVC<ChatView> {
    var coordinator: ChatCoordinator?
    let viewModel: ChatViewModel
    private let selectedImages = BehaviorRelay<[UIImage]>(value: [])
    private let selectedImageName = BehaviorRelay<[String]>(value: [])
    
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
    
    // MARK: - 채널 선택 후 진입 이전에 서버통신 후 값 전달 필요
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
            viewWillAppearTrigger: rx.methodInvoked(#selector(self.viewWillAppear))
                .map { _ in },
            viewWillDisappearTrigger: rx.methodInvoked(#selector(self.viewWillDisappear))
                .map { _ in },
            sendButtonTap: baseView.chatInputView.sendButton.rx.tap,
            chatText: baseView.chatInputView.chatInputTextView.rx.text.orEmpty,
            chatImage: selectedImages,
            chatImageName: selectedImageName
        )
        
        let output = viewModel.transform(input)
        
        // 네비게이션 영역 컨텐츠 설정
        output.navigationContent
            .drive(with: self) { owner, content in
                owner.configureNavigationContent(content)
            }
            .disposed(by: disposeBag)
        
        // 네비게이션 오른쪽 버튼 클릭 시 화면 전환
        navigationItem.rightBarButtonItem!.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                let channelID = owner.viewModel.channel.channel_id
                owner.navigationItem.backButtonTitle = ""
                owner.coordinator?.showChannelSetting(channelID: channelID)
            }
            .disposed(by: disposeBag)
        
        
        // 채팅 리스트 출력
        output.presentChatList
            .drive(baseView.chatTableView.rx.items(
                cellIdentifier: ChatTableViewCell.identifier,
                cellType: ChatTableViewCell.self)
            ) { (row, element, cell) in
                cell.configureData(data: element)
                cell.selectionStyle = .none
            }
            .disposed(by: disposeBag)
        
        // 채팅 리스트 출력 시 오류 발생 Toast
        output.presentErrorToast
            .emit(with: self) { owner, toastText in
                owner.baseView.makeToast(toastText)
            }
            .disposed(by: disposeBag)
        
        // 채팅 전송 이후 TextView 클리어
        output.clearChatText
            .emit(with: self){ owner, _ in
                owner.baseView.chatInputView.chatInputTextView.text = ""
                owner.selectedImages.accept([])
                owner.selectedImageName.accept([])
            }
            .disposed(by: disposeBag)
        
        
        // 화면 초기 진입 시 최하단 스크롤
        output.initScrollToBottom
            .filter { $0 > 0 }
            .emit(with: self) { owner, count in
                let indexPath = IndexPath(row: count - 1, section: 0)
                
                owner.baseView.chatTableView.scrollToRow(
                    at: indexPath,
                    at: .bottom,
                    animated: false
                )
            }
            .disposed(by: disposeBag)
        
        // 소켓을 통해 실시간 데이터 전송 시 스크롤
        // TODO: 추후 변경(스크롤 상태에 따라 다른 동작)
        output.scrollToBottom
            .emit(with: self) { owner, count in
                let indexPath = IndexPath(row: count - 1, section: 0)
                owner.baseView.chatTableView.scrollToRow(
                    at: indexPath,
                    at: .bottom,
                    animated: false
                )
            }
            .disposed(by: disposeBag)
        
        // 채팅 입력에 따른 TextView 높이 조절
        baseView.chatInputView.chatInputTextView.rx.text
            .distinctUntilChanged()
            .bind(with: self) { owner, value in
                owner.baseView.chatInputView.updateTextViewHeight()
            }
            .disposed(by: disposeBag)
        
        // 입력값에 따른 전송버튼 이미지 변경
        Observable.combineLatest(
            baseView.chatInputView.chatInputTextView.rx.text.orEmpty,
            selectedImages
        )
        .map { $0.0.isEmpty && $0.1.isEmpty }
        .bind(with: self) { owner, value in
            owner.baseView.chatInputView.setSendButtonImage(isEmpty: value)
        }
        .disposed(by: disposeBag)
        
        // 입력값에 따른 Placeholder Visibility 변경
        baseView.chatInputView.chatInputTextView.rx.text.orEmpty
            .map { !$0.isEmpty }
            .bind(to: baseView.chatInputView.placeholderLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        // PHPicker 사진 선택 시 CollectionView 갱신
        selectedImages
            .bind(to: baseView.chatInputView.chatAddImageCollectionView.rx.items(
                cellIdentifier: ChatAddImageCell.identifier,
                cellType: ChatAddImageCell.self)
            ) {
                (index, item, cell) in
                cell.configureUI(image: item)
                
                cell.cancelButtonTap()
                    .map({ index })
                    .bind(with: self) { owner, value in
                        owner.removeImage(at: value)
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        // 추가 버튼 클릭 시 PHPicker 표시
        baseView.chatInputView.addFileButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.showPHPickerView()
            }
            .disposed(by: disposeBag)
    }
}

extension ChatViewController {
    private func removeImage(at index: Int) {
        var currentImages = selectedImages.value
        currentImages.remove(at: index)
        selectedImages.accept(currentImages)
        
        remakeCollectionViewLayout()
    }
    
    private func remakeCollectionViewLayout() {
        baseView.chatInputView.chatAddImageCollectionView.isHidden = selectedImages.value.isEmpty
        baseView.chatInputView.updateTextViewHeight()
    }
}

extension ChatViewController: PHPickerViewControllerDelegate {
    private func showPHPickerView() {
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
            var fileNames: [String] = []
            
            for result in results {
                if let image = await loadImage(result: result) {
                    photoImages.append(image)
                    fileNames.append(result.itemProvider.suggestedName ?? "")
                }
            }
            
            self.selectedImages.accept(photoImages)
            self.selectedImageName.accept(fileNames)
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
