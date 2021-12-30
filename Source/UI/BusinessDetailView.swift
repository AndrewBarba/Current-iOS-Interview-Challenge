//
//  BusinessDetailView.swift
//  Fast Foodz (iOS)
//
//  Created by Andrew Barba on 12/30/21.
//

import SwiftUI
import MapKit

struct BusinessDetailView: View {

    var business: Yelp.Models.Business

    var location: CLLocation

    @State private var directionsResponse: MKDirections.Response?

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                imageView(size: geo.size)
                mapView
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.red)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding([.top, .leading, .trailing])
                    .padding(.bottom, 12)
                callButton
                    .padding(.top, 12)
                    .padding([.bottom, .leading, .trailing])
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: shareLink) {
                    Image("share")
                }
            }
        }
        .task {
            do {
                let destination = CLLocation(latitude: business.coordinates.latitude, longitude: business.coordinates.longitude)
                let res = try await Directions.calculate(from: location, to: destination)
                self.directionsResponse = res
            } catch {
                // ignore
            }
        }
    }

    @ViewBuilder
    private var mapView: some View {
        if let res = directionsResponse, let route = res.routes.first {
            MapRouteView(polyline: route.polyline)
        } else {
            Color.gray
        }
    }

    private func shareLink() {
        let url = URL(string: business.url)!
        let share = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        let rootViewController = UIApplication.shared.windows.first?.rootViewController
        rootViewController?.present(share, animated: true, completion: nil)
    }

    private func imageView(size: CGSize) -> some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: URL(string: business.imageUrl)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: size.width, height: size.width * (9 / 16))
                    .clipped()
            } placeholder: {
                Color.gray
                    .aspectRatio(16 / 9, contentMode: .fit)
            }

            Text(business.name)
                .font(.title3)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding([.top, .bottom], 12)
                .padding([.leading, .trailing], 16)
                .background(Color.black.opacity(0.85))
        }

    }

    private var callButton: some View {
        Link(destination: URL(string: "tel://\(business.phone ?? "")")!) {
            Text("Call Business")
                .frame(maxWidth: .infinity)
                .frame(height: 36)
        }
        .tint(.competitionPurple)
        .buttonStyle(.borderedProminent)
    }
}

struct BusinessDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BusinessDetailView(business: .preview(), location: Constants.Location.newYorkCity)
    }
}
