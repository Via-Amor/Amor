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
        let cv = UICollectionView(
            frame: .zero,
            collectionViewLayout: .setChatAddImageCollectionViewLayout
        )
        cv.register(ChatAddImageCell.self, forCellWithReuseIdentifier: ChatAddImageCell.identifier)
        cv.isScrollEnabled = false
        cv.isHidden = true
        cv.backgroundColor = .clear
        
        return cv
    }()
    
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
        addSubview(chatAddImageCollectionView)
        chatInputTextView.addSubview(placeholderLabel)
    }
    
    private func configureLayout() {
        addFileButton.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.leading.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().inset(10)
        }
        
        sendButton.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.trailing.equalToSuperview().inset(5)
            make.bottom.equalToSuperview().inset(10)
        }
        
        chatInputTextView.snp.makeConstraints { make in
            make.leading.equalTo(addFileButton.snp.trailing).offset(5)
            make.trailing.equalTo(sendButton.snp.leading).offset(-5)
            make.top.equalToSuperview().inset(5)
            make.height.equalTo(30)
        }
        
        placeholderLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(7)
            make.centerY.equalToSuperview()
        }
        
        chatAddImageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(chatInputTextView.snp.bottom)
            make.bottom.equalToSuperview().inset(5)
            make.horizontalEdges.equalTo(chatInputTextView)
            make.height.equalTo(0)
        }
    }
    
    private func configureView() {
        backgroundColor = .backgroundPrimary
        layer.cornerRadius = 8
        
        addFileButton.setImage(.plusMark, for: .normal)
        sendButton.setImage(.sendButtonDisable, for: .normal)
        
        chatInputTextView.font = .body
        chatInputTextView.backgroundColor = .backgroundPrimary
        chatInputTextView.isScrollEnabled = false
        
        placeholderLabel.text = "메세지를 입력하세요"
        placeholderLabel.textAlignment = .left
        placeholderLabel.font = .body
        placeholderLabel.textColor = .themeGray
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 이미지 추가 되었을 때
    func updateChatAddImageCollectionViewHidden(isHidden: Bool) {
        chatAddImageCollectionView.isHidden = isHidden
        
        if !chatAddImageCollectionView.isHidden {
            chatAddImageCollectionView.snp.updateConstraints { make in
                make.height.equalTo(55)
            }
        } else {
            chatAddImageCollectionView.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
        }
    }
    
    // TextView높이 조절
    func updateTextViewHeight() {
        let size = chatInputTextView.bounds.size
        let newSize = chatInputTextView.sizeThatFits(CGSize(width: size.width, height: .greatestFiniteMagnitude))
        let numberOfLines = Int(newSize.height / chatInputTextView.font!.lineHeight)
        chatInputTextView.isScrollEnabled = numberOfLines > 3
        
        let textViewHeight = numberOfLines > 3 ? 55 : newSize.height

        chatInputTextView.snp.updateConstraints { make in
            make.height.equalTo(textViewHeight)
        }
    }
    
    func setSendButtonImage(isEmpty: Bool) {
        sendButton.setImage(UIImage(named: isEmpty ? "sendButtonDisable" : "sendButtonEnable"), for: .normal)
    }
}
