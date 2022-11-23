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
        
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setConstraints()
        configure()
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        backgroundColor = .clear
    }
    
    func setConstraints() {
        frame = CGRect(x: 0, y: 0, width: 40, height: 50)
        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
    }
    
}

final class CustomAnnotation: NSObject, MKAnnotation {
    
    let annotationImage: Int
    let coordinate: CLLocationCoordinate2D
    
    init(annotationImage: Int,
         coordinate: CLLocationCoordinate2D
    ) {
        self.annotationImage = annotationImage
        self.coordinate = coordinate
        super.init()
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
