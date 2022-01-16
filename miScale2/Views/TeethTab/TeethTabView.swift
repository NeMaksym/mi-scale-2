//
//  TeethTabView.swift
//  miScale2
//
//  Created by Maksym Netreba on 07.10.2021.
//

import SwiftUI

struct TeethTabView: View {
    @State private var brushingDuration = 1
    
    var body: some View {
        NavigationView {            
            List {
                Section(header: Text("Toothbrushing")) {
                    TimepickerView(brushingDuration: $brushingDuration)
                    UploadToothbrushongView(brushingDuration: brushingDuration + 1)
                }
            }
            .navigationTitle(Text("Teeth"))
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct TeethTabView_Previews: PreviewProvider {
    static var previews: some View {
        TeethTabView()
    }
}
