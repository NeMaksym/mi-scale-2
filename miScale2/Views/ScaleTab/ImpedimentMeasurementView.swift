//
//  ImpedimentMeasurementView.swift
//  miScale2
//
//  Created by Maksym Netreba on 06.10.2021.
//

import SwiftUI

struct ImpedimentMeasurementView: View {
    @EnvironmentObject var modelData: ModelData

    var impedance: Double {
        modelData.scaleMeasurments.impedance > 9999
            ? 0
            : modelData.scaleMeasurments.impedance
    }
    
    var body: some View {
        HStack {
            Text("Impedance:")
            Spacer()
            Text(
                Measurement(
                    value: impedance,
                    unit: UnitElectricResistance.ohms
                ).formatted()
            )
        }
    }
}

struct ImpedimentMeasurementView_Previews: PreviewProvider {
    static var previews: some View {
        ImpedimentMeasurementView()
            .environmentObject(ModelData())
    }
}
