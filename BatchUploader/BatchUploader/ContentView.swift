//
//  ContentView.swift
//  BatchUploader
//
//  Created by Eugen Fedchenko on 13.08.2020.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var model: Model
    
    @State var openPicker = false
    @State var image: UIImage?
    
    var body: some View {
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
                
            }
            .disabled(!model.readyForUpload)
            .padding(.vertical, 20)
            
            Spacer()
        }
        .padding()
        .sheet(isPresented: $openPicker, content: {
            ImagePickerView(delegate: self.model)
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static let model = Model()
    static var previews: some View {
        ContentView(model: model)
    }
}
