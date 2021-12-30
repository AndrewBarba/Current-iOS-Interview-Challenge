//
//  BusinessCollectionView.swift
//  Fast Foodz (iOS)
//
//  Created by Andrew Barba on 12/29/21.
//

import SwiftUI
import MapKit

struct BusinessCollectionView: View {

    private enum Tab {
        case map, list
    }

    var businesses: [Yelp.Models.Business]

    var location: CLLocation

    @State private var selectedView = Tab.map

    var body: some View {
        VStack(spacing: 0) {
            segmentedControl
            separator
            content
        }
    }

    @ViewBuilder
    private var content: some View {
        switch selectedView {
        case .map:
            BusinessMapView(businesses: businesses, location: location)
                .transition(.opacity)
        case .list:
            BusinessListView(businesses: businesses)
                .transition(.opacity)
        }
    }

    private var segmentedControl: some View {
        Picker("View", selection: $selectedView.animation(.linear)) {
            Text("Map").tag(Tab.map)
            Text("List").tag(Tab.list)
        }
        .pickerStyle(.segmented)
        .frame(width: 240)
        .padding([.top, .bottom], 12)
    }

    private var separator: some View {
        Color.londonSky
            .frame(height: 2)
            .frame(maxWidth: .infinity)
    }
}

struct BusinessCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        BusinessCollectionView(businesses: [], location: Constants.Location.newYorkCity)
    }
}
