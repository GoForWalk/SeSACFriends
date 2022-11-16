//
//  ProfileSettingCollectionViewCell.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/15.
//

import UIKit

import SnapKit
import MultiSlider

final class ProfileSettingCollectionViewCell: BaseCollectionViewCell {
    
    let femaleButton: MainButton = {
        let button = MainButton(frame: .zero, buttonMode: .inactive, buttonSize: .h48, hasIcon: false)
        button.setTitle("여자", for: .normal)
        return button
    }()
    
    let maleButton: MainButton = {
        let button = MainButton(frame: .zero, buttonMode: .inactive, buttonSize: .h48, hasIcon: false)
        button.setTitle("남자", for: .normal)
        return button
    }()
    
    let genderLabel: UILabel = {
        let label = UILabel()
        label.setLineHeight(fontInfo: Fonts.title4R14)
        label.text = "내 성별"
        label.textColor = .black
        return label
    }()
    
    let studyLabel: UILabel = {
        let label = UILabel()
        label.setLineHeight(fontInfo: Fonts.title4R14)
        label.text = "자주하는 스터디"
        label.textColor = .black
        return label
    }()
    
    let studyTextField: UITextField = {
        let textField = InputTextField()
        textField.placeholder = ""
        return textField
    }()
    
    let phoneNumSearchSwitch: UISwitch = {
        let numSwitch = UISwitch()
        numSwitch.onTintColor = Colors.green
        numSwitch.thumbTintColor = Colors.white
        return numSwitch
    }()
    
    let phoneNumSearchLabel: UILabel = {
        let label = UILabel()
        label.setLineHeight(fontInfo: Fonts.title4R14)
        label.text = "내 번호 검색 허용"
        label.textColor = .black
        return label
    }()
    
    let ageRangeLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.green
        label.setLineHeight(fontInfo: Fonts.title3M14)
        label.textAlignment = .right
        label.text = "18 - 35"
        return label
    }()
    
    let ageLabel: UILabel = {
        let label = UILabel()
        label.setLineHeight(fontInfo: Fonts.title4R14)
        label.text = "상대방 연령대"
        label.textColor = .black
        return label
    }()
    
    let multiSlider: MultiSlider = {
        let slider = MultiSlider()
        slider.thumbTintColor = .green
        slider.thumbViews.forEach {
            $0.layer.borderColor = Colors.white.cgColor
            $0.layer.borderWidth = 1
        }
        slider.maximumValue = 65
        slider.minimumValue = 17
        slider.outerTrackColor = Colors.gray2
        slider.valueLabelColor = Colors.green
        return slider
    }()
    
    let withDrawButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원 탈퇴", for: .normal)
        button.titleLabel?.font = Fonts.title4R14.font
        button.setTitleColor(Colors.black, for: .normal)
        button.layer.borderColor = Colors.white.cgColor
        return button
    }()
    
    override func configure() {
        contentView.addSubViews(views: femaleButton, maleButton, genderLabel, studyLabel, studyTextField, phoneNumSearchLabel, phoneNumSearchSwitch, ageLabel, ageRangeLabel, multiSlider, withDrawButton)
    }
    
    override func setConstraints() {
        
        contentView.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width - 32)
            
        }
        
        femaleButton.snp.makeConstraints { make in
            make.trailing.equalTo(contentView)
            make.width.equalTo(56)
            make.top.equalTo(contentView)
        }
        
        maleButton.snp.makeConstraints { make in
            make.trailing.equalTo(femaleButton.snp.leading).offset(-8)
            make.width.equalTo(56)
            make.centerY.equalTo(femaleButton)
        }
        genderLabel.snp.makeConstraints { make in
            make.centerY.equalTo(femaleButton)
            make.leading.equalTo(contentView)
        }
        studyLabel.snp.makeConstraints { make in
            make.centerY.equalTo(studyTextField)
            make.leading.equalTo(contentView)
        }
        studyTextField.snp.makeConstraints { make in
            make.trailing.equalTo(contentView)
            make.height.equalTo(48)
            make.width.equalTo(164)
            make.top.equalTo(maleButton.snp.bottom).offset(16)
        }
        phoneNumSearchLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView)
            make.centerY.equalTo(phoneNumSearchSwitch)
        }
        phoneNumSearchSwitch.snp.makeConstraints { make in
            make.top.equalTo(studyTextField.snp.bottom).offset(26)
            make.height.equalTo(28)
            make.width.equalTo(53)
            make.trailing.equalTo(contentView)
        }
        ageLabel.snp.makeConstraints { make in
            make.centerY.equalTo(ageRangeLabel)
            make.leading.equalTo(contentView)
        }
        
        ageRangeLabel.snp.makeConstraints { make in
            make.trailing.equalTo(contentView)
            make.top.equalTo(phoneNumSearchSwitch.snp.bottom).offset(36)
        }
        multiSlider.snp.makeConstraints { make in
            make.top.equalTo(ageRangeLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(contentView)
        }
        
        withDrawButton.snp.makeConstraints { make in
            make.top.equalTo(multiSlider.snp.bottom).offset(40)
            make.leading.equalTo(contentView)
            make.width.equalTo(200)
            make.height.equalTo(22)
        }
    }
    
}
