//
//  BusinessListView.swift
//  Fast Foodz (iOS)
//
//  Created by Andrew Barba on 12/29/21.
//

import SwiftUI

struct BusinessListView: View {

    var businesses: [Yelp.Models.Business]

    var body: some View {
        List(businesses) { business in
            NavigationLink(destination: BusinessDetailView(business: business)) {
                BusinessCell(business: business)
            }
            .padding(.trailing, -18)
            .listRowSeparator(.hidden)
            .listRowInsets(.zero)
        }
        .listStyle(.plain)
    }
}

struct BusinessListView_Previews: PreviewProvider {
    static var previews: some View {
        BusinessListView(businesses: [.preview(), .preview()])
    }
}
