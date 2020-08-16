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
                
                if self.model.uploads.isEmpty {
                    VStack {
                        Text("No active uploads")
                    }.padding(.vertical, 20)
                } else {
                    List {
                        ForEach(self.model.uploads) { (upload) in
                            VStack {
                                Text(upload.name)
                            }
                            ProgressBar(value: .constant(upload.progress))
                        }
                    }.frame(height: 200)
                }
                
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

