//
//  CustomAnnotation.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/17.
//

import UIKit
import MapKit
import SnapKit

final class CustomAnnotationView: MKAnnotationView {
    
    static let identifier = "CustomAnnotationView"
    
    lazy var charactorImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        configure()
        setConstraints()
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        backgroundColor = .clear
        addSubview(charactorImageView)
    }
    
    func setConstraints() {
        charactorImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.size.equalTo(83)
        }
    }
    
}

final class CustomAnnotation: NSObject, MKAnnotation {
    
    let title: String?
    let subtitle: String?
    let annotationImage: Int
    let coordinate: CLLocationCoordinate2D
    
    init(annotationImage: Int,
         coordinate: CLLocationCoordinate2D,
         subtitle: String? = nil,
         title: String? = nil
    ) {
        self.annotationImage = annotationImage
        self.coordinate = coordinate
        self.subtitle = subtitle
        self.title = title
    }
    
    func setConfigure() {
        
    }
    
}

@frozen enum AnnotationType: Int {
    case normalface
    case growface
    case greenface
    case purpleface
    case goldface
}

extension AnnotationType {
    var image: UIImage {
        switch self {
        case .normalface:
            return Images.sesacFace1.image
        case .growface:
            return Images.sesacFace2.image
        case .greenface:
            return Images.sesacFace3.image
        case .purpleface:
            return Images.sesacFace4.image
        case .goldface:
            return Images.sesacFace5.image
        }
    }
}
