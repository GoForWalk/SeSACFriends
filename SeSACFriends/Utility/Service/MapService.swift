//
//  MapService.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/11/17.
//

import Foundation
import MapKit

import RxRelay
import RxSwift

protocol MapService {
    var mapView: MKMapView? { get set }
}

final class MapServiceImpi: NSObject, MapService {
    
    private let disposeBag = DisposeBag()
    let mapCenter = PublishRelay<CLLocationCoordinate2D>()
    var mapView: MKMapView? {
        didSet {
            mapView?.delegate = self
            self.mapView?.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(CustomAnnotationView.self))
        }
    }
    
    func setAnnotion(locations: [MapAnnotionUserDTO]) {
        let annotations = locations.map { userDTO in
            let coordinate = CLLocationCoordinate2D(latitude: userDTO.lat, longitude: userDTO.long)
            let customAnnotation = CustomAnnotation(annotationImage: userDTO.sesac, coordinate: coordinate)
            
            return customAnnotation
        }
        mapView?.addAnnotations(annotations)
    }
    
    func setMapCenter(center: CLLocationCoordinate2D, displayRange: CLLocationDistance = 5000) {
        let location = MKCoordinateRegion(center: center, latitudinalMeters: displayRange, longitudinalMeters: displayRange)
        mapView?.setRegion(location, animated: true)
    }
    
}

extension MapServiceImpi: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !annotation.isKind(of: MKAnnotation.self) else { return nil }
        
        var annotationView: MKAnnotationView?
    
        if let annotation = annotation as? CustomAnnotation {
            annotationView = setupCustomAnnotationView(for: annotation, on: mapView)
        }
        annotationView?.canShowCallout = true
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print(#function, mapView.centerCoordinate)
        self.mapCenter.accept(mapView.centerCoordinate)
    }
    
    
}

private extension MapServiceImpi {
    
    func setupCustomAnnotationView(for annotation: CustomAnnotation, on mapView: MKMapView) -> MKAnnotationView {
        
        let identifier =  NSStringFromClass(CustomAnnotationView.self)
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier, for: annotation)
                
        guard let image = AnnotationType(rawValue: annotation.annotationImage)?.image else { return MKAnnotationView()}
        annotationView.image = image
        
        let offset = CGPoint(x: image.size.width / 2 , y: image.size.height / 2 )
        annotationView.centerOffset = offset
        
        return annotationView
    }

}
