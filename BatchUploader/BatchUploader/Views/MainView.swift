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
        NavigationView {
            VStack {
                
                VStack {
                    Text("No active uploads")
                }.padding(.vertical, 20)
                
                Button("Create new upload") {
                    self.openNewUpload = true
                }
                
                Spacer()
                
                NavigationLink(destination: NewUploadView(model: NewUploadModel(isActive: self.$openNewUpload)), isActive: self.$openNewUpload) {
                    EmptyView()
                }
            }
            .padding()
        }
    }
}

