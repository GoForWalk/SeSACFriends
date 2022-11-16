//
//  HomeView.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/14.
//

import UIKit
import MapKit

import SnapKit

final class HomeMainView: BaseView {
    
    lazy var map: MKMapView = {
        let map = MKMapView()
        
        return map
    }()
    
    lazy var statusButton: UIButton = {
        let button = UIButton()
        
        return button
    }()
    
    lazy var genderStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [allGenderButton, maleButton, femaleButton])
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.layer.cornerRadius = 8
        stackView.clipsToBounds = true
        return stackView
    }()
    
    lazy var allGenderButton: MainButton = {
        let button = MainButton(frame: .zero, buttonMode: .fill, buttonSize: .h48 , hasIcon: false)
        button.setTitle("전체", for: .normal)
        return button
    }()
    
    lazy var maleButton: MainButton = {
        let button = MainButton(frame: .zero, buttonMode: .inactive, buttonSize: .h48 , hasIcon: false)
        button.setTitle("남자", for: .normal)
        return button
    }()
    
    lazy var femaleButton: MainButton = {
        let button = MainButton(frame: .zero, buttonMode: .inactive, buttonSize: .h48 , hasIcon: false)
        button.setTitle("여자", for: .normal)

        return button
    }()
    
    lazy var setLocationButton: MainButton = {
        let button = MainButton(frame: .zero, buttonMode: .inactive, buttonSize: .h48 , hasIcon: false)
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.setImageSize(imageInfo: Images.place, state: .normal)
        return button
    }()

    override func configure() {
        map.addSubViews(views: genderStackView, statusButton, setLocationButton)
        addSubViews(views: map)
    }
    
    override func setConstraints() {
        
        map.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top)
            make.horizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        
        statusButton.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview().inset(16)
            make.width.height.equalTo(64)
        }
        
        genderStackView.snp.makeConstraints { make in
            make.leading.top.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.width.equalTo(48)
        }
        
        setLocationButton.snp.makeConstraints { make in
            make.width.equalTo(48)
            make.top.equalTo(genderStackView.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(16)
        }
        
    }
    
    
}
