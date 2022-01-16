//
//  BTStatusView.swift
//  miScale2
//
//  Created by Maksym Netreba on 05.10.2021.
//

import SwiftUI

struct BTStatusView: View {
    var body: some View {
        Text("Turn on Bluetooth")
            .font(.title)
            .foregroundColor(.red)
    }
}

struct BTStatusView_Previews: PreviewProvider {
    static var previews: some View {
        BTStatusView()
    }
}
