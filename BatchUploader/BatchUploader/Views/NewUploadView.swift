//
//  NewUploadView.swift
//  BatchUploader
//
//  Created by Eugen Fedchenko on 14.08.2020.
//  Copyright © 2020 Eugen Fedchenko. All rights reserved.
//

import SwiftUI
import PromiseKit

struct NewUploadView: View {
    @ObservedObject var model: NewUploadModel
    @State var openPicker = false
    
    var content: some View {
        VStack {
            Group {
                if self.model.selectedImages.isEmpty  {
                    Text("No images yet").padding()
                } else {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(model.selectedImages, id: \.self) { image in
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: 100, height: 100)
                            }
                        }
                    }
                }
            }
            .padding(.vertical, 20)
            
            Button("Add image") {
                self.openPicker = true
            }
            .padding(.vertical, 20)
            
            Button("Start upload") {
                self.model.upload()
            }
            .disabled(!model.readyForUpload)
            .padding(.vertical, 20)
                        
            Spacer()
        }
        .padding(.top, 20)
        .sheet(isPresented: $openPicker, content: {
            ImagePickerView(delegate: self.model)
        })
    }
    
    var body: some View {
        LoadingView(isShowing: self.model.isLoading) {
            self.content
        }
    }
}
