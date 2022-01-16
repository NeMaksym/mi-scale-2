//
//  BFPMeasurmentView.swift
//  miScale2
//
//  Created by Maksym Netreba on 07.10.2021.
//

import SwiftUI

struct BFPMeasurmentView: View {
    @EnvironmentObject var modelData: ModelData
    
    var body: some View {
        HStack {
            Text("Body Fat Percentage:")
            Spacer()
            Text("\(modelData.bfp, specifier: "%.2f") %")
        }
    }
}

struct BFPMeasurmentView_Previews: PreviewProvider {
    static var previews: some View {
        BFPMeasurmentView()
            .environmentObject(ModelData())
    }
}
