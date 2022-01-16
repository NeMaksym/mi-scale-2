//
//  ScaleTabView.swift
//  miScale2
//  
//  Created by Maksym Netreba on 05.10.2021.
//

import SwiftUI

struct ScaleTabView: View {
    @EnvironmentObject var bleManager: BLEManager
    
    private let footerText = "Based on profile data"
    
    var body: some View {
        NavigationView {
            List {                
                Section(header: Text("Scale measurments")) {
                    WeightMeasurementView()
                    ImpedimentMeasurementView()
                }
                
                Section(header: Text("Calculated measurments"), footer: Text(footerText)) {
                    BMIMeasurmentView()
                    BFPMeasurmentView()
                    LBMMeasurmentView()
                }
                
                Section(header: Text("Actions")) {
                    UploadButtonView(
                        text: "Export all",
                        uploadType: UploadType.both
                    )
                    UploadButtonView(
                        text: "Export weight",
                        uploadType: UploadType.weight
                    )
                    UploadButtonView(
                        text: "Export calculated",
                        uploadType: UploadType.calculated
                    )
                }
            }
            .navigationTitle(Text("Scale"))
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

enum UploadType {
    case weight
    case calculated
    case both
}

struct ScaleTabView_Previews: PreviewProvider {
    static var previews: some View {
        ScaleTabView()
            .environmentObject(BLEManager())
            .environmentObject(ModelData())
    }
}
