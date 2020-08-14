//
//  ContentView.swift
//  BatchUploader
//
//  Created by Eugen Fedchenko on 13.08.2020.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var model: MainViewModel
    @State var openNewUpload = false
    
    var body: some View {
        VStack {
            Text("No active uploads")
            
            Button("Create new upload") {
                self.openNewUpload = true
            }
        }
        .padding()
        .sheet(isPresented: $openNewUpload, content: {
            NewUploadView(isShown: self.$openNewUpload, model: self.model.newUploadModel())
        })

    }
}

