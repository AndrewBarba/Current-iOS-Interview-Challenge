//
//  BusinessMapView.swift
//  Fast Foodz (iOS)
//
//  Created by Andrew Barba on 12/29/21.
//

import SwiftUI
import MapKit

struct BusinessMapView: View {

    var businesses: [Yelp.Models.Business]

    @State private var region: MKCoordinateRegion

    init(businesses: [Yelp.Models.Business], location: CLLocation) {
        self.businesses = businesses
        self._region = .init(
            initialValue: MKCoordinateRegion(
                center: location.coordinate,
                latitudinalMeters: 400,
                longitudinalMeters: 400
            )
        )
    }

    var body: some View {
        Map(
            coordinateRegion: $region,
            interactionModes: .all,
            showsUserLocation: true,
            annotationItems: businesses
        ) { business in
            annoation(for: business)
        }
        .edgesIgnoringSafeArea(.bottom)
    }

    func annoation(for business: Yelp.Models.Business) -> MapAnnotation<Image> {
        MapAnnotation(coordinate: CLLocationCoordinate2D(
            latitude: business.coordinates.latitude,
            longitude: business.coordinates.longitude
        )) {
            Image("pin")
        }
    }
}

struct BusinessMapView_Previews: PreviewProvider {
    static var previews: some View {
        BusinessMapView(businesses: [], location: Constants.Location.newYorkCity)
    }
}
