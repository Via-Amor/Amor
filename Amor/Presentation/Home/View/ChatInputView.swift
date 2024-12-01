//
//  ChatInputView.swift
//  Amor
//
//  Created by 김상규 on 11/24/24.
//

import UIKit
import SnapKit
import RxSwift

final class ChatInputView: UIView {
    let chatInputTextView = UITextView()
    let addFileButton = UIButton()
    let sendButton = UIButton()
    let placeholderLabel = UILabel()
    lazy var chatAddImageCollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: self.setChatAddImageCollectionViewLayout())
        cv.register(ChatAddImageCell.self, forCellWithReuseIdentifier: ChatAddImageCell.identifier)
        cv.isScrollEnabled = false
        cv.isHidden = true
        
        return cv
    }()
    
    private let lineHeight = UIFont.body.lineHeight
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    private func configureHierarchy() {
        addSubview(chatInputTextView)
        addSubview(addFileButton)
        addSubview(sendButton)
        addSubview(placeholderLabel)
        addSubview(chatAddImageCollectionView)
    }
    
    private func configureLayout() {
        addFileButton.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.top.greaterThanOrEqualTo(safeAreaLayoutGuide).inset(10)
            make.leading.bottom.equalTo(safeAreaLayoutGuide).inset(10)
        }
        
        sendButton.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.top.greaterThanOrEqualTo(safeAreaLayoutGuide).inset(10)
            make.trailing.bottom.equalTo(safeAreaLayoutGuide).inset(10)
        }
        
        chatInputTextView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(10)
            make.leading.equalTo(addFileButton.snp.trailing).offset(5)
            make.trailing.equalTo(sendButton.snp.leading).offset(-5)
            make.height.greaterThanOrEqualTo(lineHeight)
        }
        
        placeholderLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(chatInputTextView).inset(7)
            make.verticalEdges.equalTo(chatInputTextView)
        }
        
        chatAddImageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(chatInputTextView.snp.bottom).inset(5)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(5)
            make.leading.equalTo(addFileButton.snp.trailing).offset(5)
            make.trailing.equalTo(sendButton.snp.leading).offset(5)
            make.height.equalTo(60)
        }
    }
    
    private func configureView() {
        backgroundColor = .backgroundPrimary
        layer.cornerRadius = 8
        
        addFileButton.setImage(Design.Icon.plus, for: .normal)
        sendButton.setImage(UIImage(named: "sendButtonDisable"), for: .normal)
        
        chatInputTextView.font = .body
        chatInputTextView.backgroundColor = .backgroundPrimary
        chatInputTextView.isScrollEnabled = false
        
        placeholderLabel.text = "메세지를 입력하세요"
        placeholderLabel.textAlignment = .left
        placeholderLabel.font = .body
        placeholderLabel.textColor = .themeGray
        
        chatAddImageCollectionView.isHidden = true
        chatAddImageCollectionView.backgroundColor = .clear
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateTextViewHeight() {
        let size = CGSize(width: chatInputTextView.frame.width, height: .infinity)
        let estimatedSize = chatInputTextView.sizeThatFits(size)
        let maxHeight = lineHeight * 3
        let newHeight = min(max(lineHeight, estimatedSize.height), maxHeight)
        
        if chatAddImageCollectionView.isHidden {
            chatInputTextView.snp.remakeConstraints { make in
                make.bottom.equalTo(safeAreaLayoutGuide).inset(10)
                make.top.equalTo(safeAreaLayoutGuide).inset(10)
                make.height.equalTo(newHeight)
                make.leading.equalTo(addFileButton.snp.trailing).offset(5)
                make.trailing.equalTo(sendButton.snp.leading).offset(-5)
            }
        } else {
            chatInputTextView.snp.remakeConstraints { make in
                make.top.equalTo(safeAreaLayoutGuide).inset(10)
                make.height.equalTo(newHeight)
                make.leading.equalTo(addFileButton.snp.trailing).offset(5)
                make.trailing.equalTo(sendButton.snp.leading).offset(-5)
            }
            
            configureCollectionViewLayout()
        }
        
        chatInputTextView.isScrollEnabled = estimatedSize.height > maxHeight
        layoutIfNeeded()
    }
    
    func setSendButtonImage(isEmpty: Bool) {
        sendButton.setImage(UIImage(named: isEmpty ? "sendButtonDisable" : "sendButtonEnable"), for: .normal)
    }
    
    func configureCollectionViewLayout() {
        chatAddImageCollectionView.snp.remakeConstraints { make in
            make.top.equalTo(chatInputTextView.snp.bottom).offset(5)
            make.leading.equalTo(addFileButton.snp.trailing).offset(5)
            make.trailing.equalTo(sendButton.snp.leading).offset(-5)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(5)
            make.height.equalTo(60)
        }
    }
}
