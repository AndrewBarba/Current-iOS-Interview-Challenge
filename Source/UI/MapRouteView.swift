//
//  MapRouteView.swift
//  Fast Foodz (iOS)
//
//  Created by Andrew Barba on 12/30/21.
//

import SwiftUI
import MapKit

struct MapRouteView: UIViewRepresentable {

    var polyline: MKPolyline

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.isUserInteractionEnabled = false
        mapView.interactions = []
        mapView.showsUserLocation = false
        mapView.userTrackingMode = .none
        mapView.pointOfInterestFilter = .excludingAll
        mapView.addOverlay(polyline, level: .aboveRoads)
        mapView.setRegion(.init(polyline.boundingMapRect.insetBy(dx: -100, dy: -100)), animated: false)
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        // update
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let rendere = MKPolylineRenderer(overlay: overlay)
            rendere.lineWidth = 4
            rendere.strokeColor = .bluCepheus
            return rendere
        }
    }
}
