//
//  Fast_FoodzApp.swift
//  Shared
//
//  Created by Andrew Barba on 12/27/21.
//

import SwiftUI

@main
struct FastFoodzApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                RootView()
            }
            .preferredColorScheme(.light)
            .environmentObject(LocationManager())
        }
    }
}
