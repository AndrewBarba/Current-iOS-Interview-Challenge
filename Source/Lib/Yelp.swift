//
//  Yelp.swift
//  Fast Foodz (iOS)
//
//  Created by Andrew Barba on 12/27/21.
//

import Foundation

public class Yelp {

    public static let shared = Yelp()

    private let client: HTTPClient

    public init() {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        self.client = HTTPClient(
            host: "https://api.yelp.com/v3",
            headers: ["Authorization": "Bearer \(Constants.YelpFusion.apiKey)"],
            jsonDecoder: decoder
        )
    }

    public func businessSearch(
        latitude: Double,
        longitude: Double,
        radius: Int = 1000,
        sortBy: String = "distance",
        categories: [String] = ["pizza", "mexican", "chinese", "burgers"]
    ) async throws -> Responses.BusinessSearch {
        return try await self.client.get("businesses/search", searchParams: [
            "latitude": String(latitude),
            "longitude": String(longitude),
            "radius": String(radius),
            "sort_by": sortBy,
            "categories": categories.joined(separator: ",")
        ])
    }

    public func business(id: String) async throws -> Models.Business {
        return try await self.client.get("businesses\(id)")
    }
}

extension Yelp {
    public struct Responses {
        public struct BusinessSearch: Decodable {
            public let total: Int
            public let businesses: [Models.Business]
        }
    }

    public struct Models {
        public struct Business: Decodable, Identifiable {
            public let id: String
            public let name: String
            public let url: String
            public let imageUrl: String
            public let rating: Double
            public let price: String?
            public let phone: String?
            public let distance: Double
            public let coordinates: Coordinates
            public let categories: [Category]
        }

        public struct Coordinates: Decodable {
            public let latitude: Double
            public let longitude: Double
        }

        public struct Category: Decodable {
            public let alias: String
            public let title: String
        }
    }
}

extension Yelp.Models.Business {

    static func preview() -> Yelp.Models.Business {
        return self.init(
            id: "preview",
            name: "Marquee",
            url: "https://abarba.me",
            imageUrl: "https://abarba.me/img/bg.jpg",
            rating: 4,
            price: "$$$",
            phone: "+19085667524",
            distance: 100,
            coordinates: .init(
                latitude: Constants.Location.newYorkCity.coordinate.latitude,
                longitude: Constants.Location.newYorkCity.coordinate.longitude
            ),
            categories: [
                .init(alias: "mexican", title: "Mexican")
            ]
        )
    }
}
