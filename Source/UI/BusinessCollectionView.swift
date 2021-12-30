//
//  BusinessCollectionView.swift
//  Fast Foodz (iOS)
//
//  Created by Andrew Barba on 12/29/21.
//

import SwiftUI
import MapKit

struct BusinessCollectionView: View {

    var businesses: [Yelp.Models.Business]

    var location: CLLocation

    @State private var selectedView = 0

    var body: some View {
        VStack(spacing: 0) {
            Picker("View", selection: $selectedView) {
                Text("Map").tag(0)
                Text("List").tag(1)
            }
            .pickerStyle(.segmented)
            .frame(width: 240)
            .padding([.top, .bottom], 12)

            Color.londonSky
                .frame(height: 2)
                .frame(maxWidth: .infinity)

            switch selectedView {
            case 0:
                BusinessMapView(businesses: businesses, location: location)
            case 1:
                BusinessListView(businesses: businesses)
            default:
                fatalError("Invalid view index")
            }
        }
    }
}

struct BusinessCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        BusinessCollectionView(businesses: [], location: Constants.Location.newYorkCity)
    }
}
