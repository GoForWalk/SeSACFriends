//
//  MainTableViewCell.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/14.
//

import UIKit

import SnapKit

final class ProfileMainTableViewCell: BaseTableViewCell {
    
    let titleImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.setLineHeight(fontInfo: Fonts.title2R16)
        return label
    }()
    
    override func configure() {
        super.configure()
        selectionStyle = .none
        [titleImage, titleLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        
//        self.snp.makeConstraints { make in
//            make.height.equalTo(74)
//        }
        
        titleImage.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.height.width.equalTo(24)
            make.leading.equalTo(contentView).inset(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(titleImage.snp.trailing).inset(-12)
        }
        
    }
    
    func configureCell(index: Int) {
        let temp = ProfileMain.allCases[index]
        titleLabel.text = temp.rawValue
        titleImage.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: temp.image.imageSize)
        titleImage.image = temp.image.image
    }
    
}

@frozen enum ProfileMain: String, CaseIterable {
    
    case notice = "공지사항"
    case qna = "자주 묻는 질문"
    case personalInquire = "1:1 문의"
    case setAlert = "알람 설정"
    case utilizationAgreement = "이용약관"
    
}

extension ProfileMain {
    
    var image: ImageInfo {
        switch self {
        case .notice:
            return Images.notice
        case .qna:
            return Images.faq
        case .personalInquire:
            return Images.qna
        case .setAlert:
            return Images.settingAlarm
        case .utilizationAgreement:
            return Images.permit
        }
    }
}
