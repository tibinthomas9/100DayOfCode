//
//  MainView.swift
//  Menu
//
//  Created by manolo on 12/20/21.
//  Copyright © 2021 DoorDash, Inc. All rights reserved.
//

import SwiftUI

@MainActor
struct MainView: View {
    @StateObject private var vm = ContentServiceViewModel()
    
    
    var body: some View {
       
        List(vm.menuItems, id: \.description) { item in
            HStack(spacing: 10) {
                VStack(alignment: .leading) {
                    Spacer()
                    if (item.image_url != nil) {
                        Text(item.title ?? "")
                            .font(.system(size: 18))
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    }
                    Text(item.description)
                        .font(.system(size: 16))
                        .lineLimit(3)
                    Spacer()
                }
                if (item.image_url != nil) {
                    AsyncImageView( url: item.image_url ?? "")
                        .cornerRadius(12)
                        .frame(width: 80, height: 80)
                    
                    
                }
            }.padding(6)
            
        }
        
            .onAppear {
               
                        vm.fetchdata()
                    
                   
                }
            }
                
    }



struct AsyncImageView: View {
    @StateObject private var downloader = ImageDownloader()
    var url: String
    
    
    var body: some View {
        Image(uiImage: downloader.image)
            .resizable()
            .scaledToFit()
            .onAppear {
                Task {
                    await downloader.downloadImage(url:url)
                }
            }
        
    }
}

@MainActor
class ImageDownloader: ObservableObject {
    @Published var image = UIImage()
    
    func downloadImage(url: String) async {
        guard let url = URL(string: url) else {return }
        guard let (data, _) = try? await URLSession.shared.data(from: url) else { return }
        image = UIImage(data: data) ?? UIImage()
        
    }
}
