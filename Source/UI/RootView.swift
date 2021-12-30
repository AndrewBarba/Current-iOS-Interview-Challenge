//
//  RootView.swift
//  Fast Foodz (iOS)
//
//  Created by Andrew Barba on 12/29/21.
//

import SwiftUI
import CoreLocation

struct RootView: View {

    @EnvironmentObject var locationManager: LocationManager

    @State private var businesses: [Yelp.Models.Business]?

    var body: some View {
        Group {
            switch (businesses, locationManager.location) {
            case (.some(let businesses), .some(let location)):
                BusinessCollectionView(businesses: businesses, location: location)
            default:
                ProgressView()
            }
        }
        .navigationTitle("Fast Food Places")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            locationManager.requestCurrentLocation()
        }
        .onReceive(locationManager.$location) { location in
            Task {
                guard let location = location else { return }
                await fetchBusinesses(in: location)
            }
        }
    }

    private func fetchBusinesses(in location: CLLocation) async {
        let res = try? await Yelp.shared.businessSearch(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )
        businesses = res?.businesses
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
            .environmentObject(LocationManager())
    }
}
