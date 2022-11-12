//
//  BirthInputView.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/11.
//

import UIKit

import SnapKit
import TextFieldEffects

final class BirthInputView: BaseView {
    
    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.setLineHeight(fontInfo: Fonts.display1R20)
        label.text = "생년월일을 알려주세요"
        return label
    }()
    
    // TODO: DatePickerView
    lazy var dateStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [yearTextField, yearlabel, monthTextField, monthlabel, dayTextField, daylabel])
        stackView.alignment = .fill
        stackView.spacing = 2
        return stackView
    }()
    
    let yearTextField: InputTextField = {
        let textField = InputTextField()
        textField.placeholder = ""
        textField.placeholderLabel.setLineHeight(fontInfo: Fonts.title4R14)
        return textField
    }()
    
    let yearlabel: UILabel = {
        let label = UILabel()
        label.setLineHeight(fontInfo: Fonts.title2R16)
        label.text = "년"
        
        return label
    }()
    
    let monthTextField: InputTextField = {
        let textField = InputTextField()
        textField.placeholder = ""
        textField.placeholderLabel.setLineHeight(fontInfo: Fonts.title4R14)
        
        return textField
    }()
    
    let monthlabel: UILabel = {
        let label = UILabel()
        label.setLineHeight(fontInfo: Fonts.title2R16)
        label.text = "월"

        
        return label
    }()

    let dayTextField: InputTextField = {
        let textField = InputTextField()
        textField.placeholder = ""
        textField.placeholderLabel.setLineHeight(fontInfo: Fonts.title4R14)
        
        return textField
    }()
    
    let daylabel: UILabel = {
        let label = UILabel()
        label.setLineHeight(fontInfo: Fonts.title2R16)
        label.text = "일"
        
        return label
    }()
    
    let authButton: MainButton = {
        let button = MainButton(frame: .zero, buttonMode: .disable, buttonSize: .h48, hasIcon: false)
        button.setTitle("다음", for: .normal)
        return button
    }()
    
    lazy var datePickerView: UIDatePicker = {
        let datepicker = UIDatePicker()
        datepicker.preferredDatePickerStyle = .wheels
        datepicker.setDate(Date(), animated: true)
        datepicker.datePickerMode = .date
        return datepicker
    }()
    
    override func configure() {
        super.configure()
        [label, dateStackView, authButton].forEach {
            addSubview($0)
        }
        
        [yearTextField, monthTextField, dayTextField].forEach {
            $0.inputView = datePickerView
        }
        
    }
    
    override func setConstraints() {
        
        authButton.snp.makeConstraints { make in
            make.center.equalTo(self)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(16)
        }
        
        dateStackView.snp.makeConstraints { make in
            make.bottom.equalTo(authButton.snp.top).offset(-48)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(48)
        }
        
        label.snp.makeConstraints { make in
            make.bottom.equalTo(dateStackView.snp.top).offset(-40)
            make.horizontalEdges.equalTo(self).inset(16)
        }
        
        [yearlabel, monthlabel, daylabel].forEach {
            $0.snp.makeConstraints { make in
                make.width.equalTo(16)
            }
        }
        
        [monthTextField, dayTextField].forEach {
            $0.snp.makeConstraints { make in
                make.width.equalTo(yearTextField.snp.width)
            }
        }
        
    }
    
}
