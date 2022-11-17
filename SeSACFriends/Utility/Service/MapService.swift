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
    
    var mapView: MKMapView?
    private let mapCenter = PublishRelay<CLLocationCoordinate2D>()
    
    override init() {
        super.init()
        self.mapView?.delegate = self
        self.mapView?.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: CustomAnnotationView.identifier)
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
    
    func getMapCenterCoordinator() -> Observable<CLLocationCoordinate2D> {
        return mapCenter.asObservable()
    }
}

extension MapServiceImpi: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let annotation = annotation as? CustomAnnotation else { return nil }
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: CustomAnnotationView.identifier) as? CustomAnnotationView else { return nil }
        
        annotationView.annotation = annotation
        annotationView.charactorImageView.image = AnnotationType(rawValue: annotation.annotationImage)?.image
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        mapView.centerCoordinate
    }
    
}
