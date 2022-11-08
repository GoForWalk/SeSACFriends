//
//  ObBoardingCollectionViewCell.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/08.
//

import UIKit

import SnapKit

final class OnBoardingCollectionCell: BaseCollectionViewCell {
    
    let mainImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    let onboardingLabel: UILabel = {
        let label = UILabel()
        label.baselineAdjustment = .alignCenters
        label.textAlignment = .center
        label.numberOfLines = 2
        let fontInfo: FontsInfo = (UIFont(name: "NotoSansKR-Regular", size: 24)!, 1.6)
        label.setLineHeight(fontInfo: fontInfo)
        return label
    }()
    
    override func configure() {
        super.configure()
        [mainImageView, onboardingLabel].forEach {
            addSubview($0)
        }
    }
    
    override func setConstraints() {
        
        onboardingLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.greaterThanOrEqualTo(self.safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(mainImageView.snp.top).offset(-56)
        }
        
        mainImageView.snp.makeConstraints { make in
            make.width.equalTo(mainImageView.snp.height)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(8)
            make.centerY.equalTo(self)
        }
        
    }
    
    func configureCell(image: UIImage, text: String, highLightText: String?) {
        
        mainImageView.image = image

        guard let highLightText else {
            onboardingLabel.text = text
            return
        }
        
        onboardingLabel.attributedText = setLabelText(text: text, highLightText: highLightText)
    }
    
    
    private func setLabelText(text: String, highLightText: String) -> NSMutableAttributedString {
        
        let range = (text as NSString).range(of: highLightText)
        
        let mutableAttributedString = NSMutableAttributedString(string: text)
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: Colors.green, range: range)
        
        return mutableAttributedString
    }

}


