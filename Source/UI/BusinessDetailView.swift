//
//  BusinessDetailView.swift
//  Fast Foodz (iOS)
//
//  Created by Andrew Barba on 12/30/21.
//

import SwiftUI

struct BusinessDetailView: View {

    var business: Yelp.Models.Business

    var body: some View {
        VStack {
            imageView
            Spacer()
            callButton
                .padding()
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
    }

    private func shareLink() {
        let url = URL(string: business.url)!
        let share = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        let rootViewController = UIApplication.shared.windows.first?.rootViewController
        rootViewController?.present(share, animated: true, completion: nil)
    }

    private var imageView: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottomLeading) {
                AsyncImage(url: URL(string: business.imageUrl)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width, height: geo.size.width * (9 / 16))
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
    }

    private var callButton: some View {
        Link(destination: URL(string: "tel://\(business.phone ?? "")")!) {
            Text("Call Business")
                .frame(maxWidth: .infinity)
                .frame(height: 28)
        }
        .tint(.competitionPurple)
        .buttonStyle(.borderedProminent)
    }
}

struct BusinessDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BusinessDetailView(business: .preview())
        }
    }
}
