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
    private let contentStackView = UIStackView()
    
    // 레이블
    private let chatContentView = UIView()
    private let chatLabel = UILabel()
    
    // 이미지
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
    private let dateStackView = UIStackView()
    private let dateLabel = UILabel()
    private let timeLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        let firstSubViews = firstImageStackView.arrangedSubviews
        let secondSubViews = secondImageStackView.arrangedSubviews
        firstSubViews.forEach { $0.removeFromSuperview() }
        secondSubViews.forEach { $0.removeFromSuperview() }

        imageList.forEach {
            $0.snp.removeConstraints()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        chatContentView.addSubview(chatLabel)
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(nicknameLabel)
        contentView.addSubview(dateStackView)
        contentView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(chatContentView)
        contentStackView.addArrangedSubview(imageStackView)
        imageStackView.addArrangedSubview(firstImageStackView)
        imageStackView.addArrangedSubview(secondImageStackView)
        dateStackView.addArrangedSubview(dateLabel)
        dateStackView.addArrangedSubview(timeLabel)
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
        
        contentStackView.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(5)
            make.leading.equalTo(nicknameLabel)
            make.width.lessThanOrEqualTo(224)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(6)
        }
        
        dateStackView.snp.makeConstraints { make in
            make.leading.equalTo(contentStackView.snp.trailing).offset(8)
            make.bottom.equalTo(contentStackView)
        }
    }
    
    private func configureUI() {
        nicknameLabel.font = .caption
        
        chatContentView.layer.cornerRadius = 12
        chatContentView.layer.borderWidth = 1
        chatContentView.layer.borderColor = UIColor.themeInactive.cgColor
        chatLabel.font = .body
        chatLabel.numberOfLines = 0
        
        dateLabel.textColor = .textSecondary
        dateLabel.font = .mini
        timeLabel.textColor = .textSecondary
        timeLabel.font = .mini

        imageList.forEach {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 4
        }
        
        contentStackView.alignment = .leading
        contentStackView.axis = .vertical
        contentStackView.spacing = 5
        
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
        
        dateStackView.axis = .vertical
        dateStackView.spacing = 5
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
    
    private func configureChatContent(_ content: String?) {
        if let content, !content.isEmpty {
            chatContentView.isHidden = false
            chatLabel.text = content
        } else {
            chatContentView.isHidden = true
        }
    }
    
    private func configureChatImages(_ images: [String]) {
        let count = images.count
        
        if count == 0 {
            imageStackView.isHidden = true
            return
        } else {
            imageStackView.isHidden = false
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
        
        setImageViewHeight(count: count)
        
    }
    
    private func configureChatDate(_ createdAt: String) {
        if createdAt.isToday() {
            dateLabel.isHidden = true
            timeLabel.text = createdAt.toChatTime()
        } else {
            dateLabel.isHidden = false
            dateLabel.text = createdAt.toChatDate()
            timeLabel.text = createdAt.toChatTime()
        }
    }

}


extension ChatTableViewCell {
    private func createOneImageLayout() {
        firstImageStackView.addArrangedSubview(firstImageView)
    }
    
    private func createTwoImageLayout() {
        [firstImageView, secondImageView].forEach {
            firstImageStackView.addArrangedSubview($0)
        }
    }
    
    private func createThreeImageLayout() {
        [firstImageView, secondImageView, thirdImageView].forEach {
            firstImageStackView.addArrangedSubview($0)
        }
    }
    
    private func createFourImageLayout() {
        [firstImageView, secondImageView].forEach {
            firstImageStackView.addArrangedSubview($0)
        }
        
        [thirdImageView, forthImageView].forEach {
            secondImageStackView.addArrangedSubview($0)
        }
    }
    
    private func createFiveImageLayout() {
        [firstImageView, secondImageView, thirdImageView].forEach {
            firstImageStackView.addArrangedSubview($0)
        }
        
        [forthImageView, fifthImageView].forEach {
            secondImageStackView.addArrangedSubview($0)
        }
    }
    
    private func setImageViewHeight(count: Int) {
        if count > 1 {
            firstImageStackView.subviews.forEach {
                $0.snp.makeConstraints { make in
                    make.height.equalTo(80).priority(.high)
                }
            }
            
            secondImageStackView.subviews.forEach {
                $0.snp.makeConstraints { make in
                    make.height.equalTo(80).priority(.high)
                }
            }
        } else {
            firstImageView.snp.makeConstraints { make in
                make.height.equalTo(162).priority(.high)
            }
        }
    }
 
}
