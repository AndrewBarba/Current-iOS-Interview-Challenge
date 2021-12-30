//
//  BusinessCell.swift
//  Fast Foodz (iOS)
//
//  Created by Andrew Barba on 12/29/21.
//

import SwiftUI

struct BusinessCell: View {

    var business: Yelp.Models.Business

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                icon
                VStack(alignment: .leading, spacing: 6) {
                    title
                        .lineLimit(nil)
                        .multilineTextAlignment(.leading)
                    HStack(spacing: 6) {
                        price
                        Text("·")
                        miles
                        Spacer()
                    }
                    .foregroundColor(Color.lilacGrey)
                }
                chevron
            }
            .padding(16)
            seperator
        }
    }

    private var title: some View {
        Text(business.name)
            .font(.title3)
            .foregroundColor(.deepIndigo)
    }

    private var price: some View {
        HStack(alignment: .center, spacing: 1) {
            Text("$").foregroundColor(priceColor(at: 0))
            Text("$").foregroundColor(priceColor(at: 1))
            Text("$").foregroundColor(priceColor(at: 2))
            Text("$").foregroundColor(priceColor(at: 3))
        }
    }

    private var miles: some View {
        let miles = business.distance / 1609.344
        let string = String(format: "%.2f", miles)
        return Text("\(string) miles")
    }

    private var icon: some View {
        Image(imageName)
            .resizable()
            .foregroundColor(Color.deepIndigo)
            .frame(width: 32, height: 32)
    }

    private var imageName: String {
        let set = Set(business.categories.map { $0.alias })
        if set.contains("chinese") {
            return "chinese"
        }
        if set.contains("mexican") {
            return "mexican"
        }
        if set.contains("burgers") {
            return "burgers"
        }
        if set.contains("pizza") {
            return "pizza"
        }
        return "logo"
    }

    private var chevron: some View {
        Image("chevron")
    }

    private var seperator: some View {
        Color.londonSky
            .frame(height: 2)
            .frame(maxWidth: .infinity, idealHeight: 1)
            .padding([.leading, .trailing], 12)
    }

    private func priceColor(at index: Int) -> Color {
        let count = business.price?.count ?? 0
        return index < count ? Color.pickleGreen : Color.lilacGrey
    }
}

struct BusinessCell_Previews: PreviewProvider {
    static var previews: some View {
        BusinessCell(business: .preview())
    }
}
