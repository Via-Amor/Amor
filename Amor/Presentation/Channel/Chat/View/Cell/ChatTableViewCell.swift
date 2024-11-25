//
//  ChatTableViewCell.swift
//  Amor
//
//  Created by 홍정민 on 11/23/24.
//

import UIKit
import SnapKit
import Kingfisher

final class ChatTableViewCell: UITableViewCell {
    private let profileImageView = RoundImageView()
    private let nicknameLabel = UILabel()
    private let chatContentView = UIView()
    private let chatLabel = UILabel()
    private let imageStackView = UIStackView()
    private let firstImageStackView = UIStackView()
    private let secondImageStackView = UIStackView()
    private let firstImageView = UIImageView()
    private let secondImageView = UIImageView()
    private let thirdImageView = UIImageView()
    private let forthImageView = UIImageView()
    private let fifthImageView = UIImageView()
    private lazy var imageList = [
        firstImageView,
        secondImageView,
        thirdImageView,
        forthImageView,
        fifthImageView
    ]
    private let dateLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        chatContentView.addSubview(chatLabel)
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(nicknameLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(chatContentView)
        contentView.addSubview(imageStackView)
        
        imageStackView.addArrangedSubview(firstImageStackView)
        imageStackView.addArrangedSubview(secondImageStackView)
    }
    
    private func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(6)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(16)
            make.size.equalTo(34)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
        }
        
        chatLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
        chatContentView.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(5)
            make.leading.equalTo(nicknameLabel)
            make.trailing.lessThanOrEqualTo(contentView.safeAreaLayoutGuide).offset(-91)
        }
        
        imageStackView.snp.makeConstraints { make in
            make.top.equalTo(chatContentView.snp.bottom).offset(5)
            make.leading.equalTo(nicknameLabel)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).offset(-91)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(6)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageStackView.snp.trailing).offset(8)
            make.width.equalTo(53)
            make.bottom.equalTo(imageStackView)
        }
    }
    
    private func configureUI() {
        nicknameLabel.font = .caption

        chatContentView.layer.cornerRadius = 12
        chatContentView.layer.borderWidth = 1
        chatContentView.layer.borderColor = UIColor.themeInactive.cgColor
        chatLabel.font = .body
        chatLabel.numberOfLines = 0
        
        dateLabel.font = .mini
        
        imageList.forEach {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 4
        }
        
        imageStackView.axis = .vertical
        imageStackView.spacing = 2
        imageStackView.clipsToBounds = true
        imageStackView.layer.cornerRadius = 12

        firstImageStackView.axis = .horizontal
        firstImageStackView.distribution = .fillEqually
        firstImageStackView.spacing = 2
        
        secondImageStackView.axis = .horizontal
        secondImageStackView.distribution = .fillEqually
        secondImageStackView.spacing = 2
    }
    
    func configureData(data: Chat) {
        configureProfileImage(data.profileImage)
        configureNickname(data.nickname)
        configureChatContent(data.content)
        configureChatImages(data.files)
        configureChatDate(data.createdAt)
    }
}

extension ChatTableViewCell {
    private func configureProfileImage(_ image: String?) {
        guard let image else {
            profileImageView.image = UIImage(resource: .userGreen)
            return
        }
        
        if let profileImage = URL(string: image) {
            profileImageView.kf.setImage(with: profileImage)
        }
    }
    
    private func configureNickname(_ nickname: String) {
        nicknameLabel.text = nickname
    }
    
    private func configureChatContent(_ content: String) {
        if !content.isEmpty {
            chatLabel.text = content
        } else {
            remakeImageConstraint()
        }
    }
    
    private func configureChatImages(_ images: [String]) {
        let count = images.count
        if count == 0 {
            remakeTextConstraint()
            return
        }
        
        for i in 0..<count {
            if let imageURL = URL(string: apiUrl + images[i]) {
                imageList[i].kf.setImage(with: imageURL)
            }
        }

        switch count {
        case 1:
            createOneImageLayout()
        case 2:
            createTwoImageLayout()
        case 3:
            createThreeImageLayout()
        case 4:
            createFourImageLayout()
        case 5:
            createFiveImageLayout()
        default:
            print("Invalid Image Count")
        }
        
    }
    
    private func configureChatDate(_ createdAt: String) {
        dateLabel.text = createdAt.toChatTime()
    }
    
    private func remakeImageConstraint() {
        imageStackView.snp.remakeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(5)
            make.leading.equalTo(nicknameLabel)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).offset(-91)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(6)
        }
    }
    
    private func remakeTextConstraint() {
        dateLabel.snp.remakeConstraints { make in
            make.leading.equalTo(chatContentView.snp.trailing).offset(8)
            make.bottom.equalTo(chatContentView)
        }
        imageStackView.snp.updateConstraints { make in
            make.top.equalTo(chatContentView.snp.bottom)
        }
    }
    
    private func createOneImageLayout() {
        firstImageView.snp.makeConstraints { make in
            make.height.equalTo(160)
        }
        imageStackView.layer.cornerRadius = 12
        firstImageStackView.addArrangedSubview(firstImageView)
    }
    
    private func createTwoImageLayout() {
        [firstImageView, secondImageView].forEach {
            firstImageStackView.addArrangedSubview($0)
            $0.snp.makeConstraints { make in
                make.height.equalTo(80)
            }
        }
    }
    
    private func createThreeImageLayout() {
        [firstImageView, secondImageView, thirdImageView].forEach {
            firstImageStackView.addArrangedSubview($0)
            
            $0.snp.makeConstraints { make in
                make.height.equalTo(80)
            }
        }
    }
    
    private func createFourImageLayout() {
        [firstImageView, secondImageView].forEach {
            firstImageStackView.addArrangedSubview($0)
            
            $0.snp.makeConstraints { make in
                make.height.equalTo(80)
            }
        }
        
        [thirdImageView, forthImageView].forEach {
            secondImageStackView.addArrangedSubview($0)
            
            $0.snp.makeConstraints { make in
                make.height.equalTo(80)
            }
        }
    }
    
    private func createFiveImageLayout() {
        [firstImageView, secondImageView, thirdImageView].forEach {
            firstImageStackView.addArrangedSubview($0)
            
            $0.snp.makeConstraints { make in
                make.height.equalTo(80)
            }
        }
        
        [forthImageView, fifthImageView].forEach {
            secondImageStackView.addArrangedSubview($0)
            
            $0.snp.makeConstraints { make in
                make.height.equalTo(80)
            }
        }
    }
}
