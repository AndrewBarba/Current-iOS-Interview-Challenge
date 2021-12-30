//
//  Directions.swift
//  Fast Foodz (iOS)
//
//  Created by Andrew Barba on 12/30/21.
//

import Foundation
import MapKit

public struct Directions {

    public enum DirectionsError: Error {
        case unknown
    }

    static func calculate(
        from source: CLLocation,
        to destination: CLLocation,
        transportType: MKDirectionsTransportType = .automobile
    ) async throws -> MKDirections.Response {
        return try await withCheckedThrowingContinuation { continuation in
            let request = MKDirections.Request()
            request.transportType = transportType
            request.source = MKMapItem(placemark: .init(coordinate: source.coordinate))
            request.destination = MKMapItem(placemark: .init(coordinate: destination.coordinate))

            let directions = MKDirections(request: request)

            directions.calculate { (response, error) in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                if let response = response {
                    continuation.resume(returning: response)
                    return
                }
                continuation.resume(throwing: DirectionsError.unknown)
            }
        }
    }
}
