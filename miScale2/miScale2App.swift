//
//  miScale2App.swift
//  miScale2
//
//  Created by Maksym Netreba on 03.10.2021.
//

import SwiftUI

@main
struct miScale2App: App {
    @StateObject var hkManager = HKManager()

    var body: some Scene {
        WindowGroup {
            if hkManager.isHealthAuthorized {
                ContentView()
                    .environmentObject(hkManager)
            } else {
                Text("Provide access to write Health data. You may do this by following Seetings -> Privacy -> Health -> miScale2 ")
                    .onAppear(perform: hkManager.authorizeHealth)
            }
        }
    }
}
