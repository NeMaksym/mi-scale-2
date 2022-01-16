//
//  BMIMeasurmentView.swift
//  miScale2
//
//  Created by Maksym Netreba on 07.10.2021.
//

import SwiftUI

struct BMIMeasurmentView: View {
    @EnvironmentObject var modelData: ModelData
    
    var body: some View {
        HStack {
            Text("Body Mass Index:")
            Spacer()
            Text("\(modelData.bmi, specifier: "%.2f")")
        }
    }
}

struct BMIMeasurmentView_Previews: PreviewProvider {
    static var previews: some View {
        BMIMeasurmentView()
            .environmentObject(ModelData())
    }
}
