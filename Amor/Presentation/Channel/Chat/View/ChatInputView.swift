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
    let imageStackView = UIStackView()
    let placeholderLabel = UILabel()
    private let firstImageView = ChatAddImageView()
    private let secondImageView = ChatAddImageView()
    private let thirdImageView = ChatAddImageView()
    private let forthImageView = ChatAddImageView()
    private let fifthImageView = ChatAddImageView()
    
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
        addSubview(imageStackView)
        addSubview(placeholderLabel)
        
        imageStackView.addArrangedSubview(firstImageView)
        imageStackView.addArrangedSubview(secondImageView)
        imageStackView.addArrangedSubview(thirdImageView)
        imageStackView.addArrangedSubview(forthImageView)
        imageStackView.addArrangedSubview(fifthImageView)
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
            make.bottom.equalTo(safeAreaLayoutGuide).inset(10)
            make.leading.equalTo(addFileButton.snp.trailing).offset(5)
            make.trailing.equalTo(sendButton.snp.leading).offset(-5)
            make.height.greaterThanOrEqualTo(lineHeight)
        }
        
        placeholderLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(chatInputTextView).inset(7)
            make.verticalEdges.equalTo(chatInputTextView)
        }
        
//        imageStackView.snp.makeConstraints { make in
//            make.verticalEdges.equalTo(chatInputTextView.snp.bottom).offset(5)
//            make.leading.equalTo(addFileButton.snp.trailing).offset(10)
//            make.trailing.equalTo(sendButton.snp.leading).offset(10)
//            make.height.equalTo(35)
//        }
    }
    
    private func configureView() {
        backgroundColor = .backgroundPrimary
        layer.cornerRadius = 8
        
        addFileButton.setImage(Design.Icon.plus, for: .normal)
        sendButton.setImage(UIImage(named: "sendButtonDisable"), for: .normal)
        
        chatInputTextView.font = .body
        chatInputTextView.backgroundColor = .backgroundPrimary
        chatInputTextView.isScrollEnabled = false
        
        imageStackView.backgroundColor = .gray
        imageStackView.isHidden = true
        
        placeholderLabel.text = "메세지를 입력하세요"
        placeholderLabel.textAlignment = .left
        placeholderLabel.font = .body
        placeholderLabel.textColor = .themeGray
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureImageStackView(images: [UIImage]) {
        let imageViews = [firstImageView, secondImageView, thirdImageView, forthImageView, fifthImageView]
        switch images.count {
        case 0:
            imageStackView.isHidden = true
        default:
            imageStackView.isHidden = false
            for i in 0..<images.count {
                imageViews[i].configureUI(image: images[i])
            }
        }
    }
    
    func updateTextViewHeight() {
        let size = CGSize(width: chatInputTextView.frame.width, height: .infinity)
        let estimatedSize = chatInputTextView.sizeThatFits(size)
        let maxHeight = lineHeight * 3
            
        let newHeight = min(max(lineHeight, estimatedSize.height), maxHeight)
        
        chatInputTextView.isScrollEnabled = estimatedSize.height > maxHeight
        
        chatInputTextView.snp.remakeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(10)
            make.top.equalTo(safeAreaLayoutGuide).inset(10)
            make.height.equalTo(newHeight)
            make.leading.equalTo(addFileButton.snp.trailing).offset(5)
            make.trailing.equalTo(sendButton.snp.leading).offset(-5)
        }
        
        layoutIfNeeded()
    }
    
    func setSendButtonImage(isEmpty: Bool) {
        sendButton.setImage(UIImage(named: isEmpty ? "sendButtonDisable" : "sendButtonEnable"), for: .normal)
    }
}
