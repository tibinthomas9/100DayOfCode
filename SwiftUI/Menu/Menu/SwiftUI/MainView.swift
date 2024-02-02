//
//  MainView.swift
//  Menu
//
//  Created by manolo on 12/20/21.
//  Copyright © 2021 DoorDash, Inc. All rights reserved.
//

import SwiftUI




struct ContentView: View {
    @State private var searchText = ""
    @State private var isSearchBarHidden = false
    @State private var scrollOffset: CGFloat = 0
    @State private var initialSearchBarOffset: CGFloat = 0

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView {
                    ScrollViewReader { proxy in
                        VStack {
                            ForEach(1..<100) { index in
                                Text("Item \(index)")
                                    .padding()
                            }
                        }
                        .onChange(of: isSearchBarHidden) { _ in
                            withAnimation {
                                proxy.scrollTo(0, anchor: .top)
                            }
                        }
                        .offset(y: -scrollOffset) // Adjust the content offset based on scroll
                        .frame(width: geometry.size.width) // Set frame width
                        .background(
                            GeometryReader { innerGeometry in
                                Color.clear.onAppear {
                                    // Store initial offset when the view appears
                                    initialSearchBarOffset = innerGeometry.frame(in: .global).minY
                                }
                            }
                        )
                    }
                }
                .navigationBarTitle("Scrolling Search")
                .overlay(
                    VStack {
                        if !isSearchBarHidden {
                            SearchBar(text: $searchText, isSearchBarHidden: $isSearchBarHidden)
                                .padding()
                                .transition(.move(edge: .top))
                                .animation(.easeInOut)
                                .frame(width: max(0, geometry.size.width - (scrollOffset - initialSearchBarOffset), 0))
                                .frame(maxWidth: .infinity)
                                .background(Color(UIColor.systemBackground))
                        }
                        Spacer() // Push content to the top
                    }
                )
                .onPreferenceChange(OffsetPreferenceKey.self) { value in
                    // Update the scroll offset
                    scrollOffset = value
                }
            }
        }
    }
}

struct OffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}









struct SearchBar: View {
    @Binding var text: String
    @Binding var isSearchBarHidden: Bool

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("Search", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onTapGesture {
                    isSearchBarHidden = true
                }
            Button(action: {
                text = ""
            }) {
                Image(systemName: "xmark.circle.fill")
            }
        }
        .padding(.vertical, 8)
        .background(Color.gray.opacity(0.1))
    }
}



struct MainView: View {
    private let service = ContentService()
    @State private var menuItems: [MenuItems] = []
    
    var body: some View {
        
        
       
        
        
        List(menuItems) { item in
            HStack(spacing: 16) {
                
                VStack(alignment: .leading, spacing: 8) {
                    if let title = item.title {
                        Text(title)
                            .font(.system(size: 18))
                            .bold()
                    }
                    
                    Text(item.description)
                        .lineLimit(2)
                        .font(.system(size: 16))
                }
                if let image_url = item.image_url, !image_url.isEmpty {
                    ImageView(url: image_url)
                        .cornerRadius(12)
                        .frame(width: 80, height: 80)
                }

            }
            .padding(16)
        }

        
//        List {
//            ForEach(menuItems, id: \.description) { item in
//                HStack {
//                    
//                    VStack(alignment: .leading) {
//                        if let title = item.title {
//                            Text(title)
//                                .font(.system(size: 18))
//                                .bold()
//                        }
//                        Text(item.description)
//                            .lineLimit(2)
//                            .font(.system(size: 16))
//                    }
//                    if let image_url = item.image_url {
//                        ImageView(url: image_url)
//                            .cornerRadius(12)
//                            .frame(width: 80, height: 80)
//                            .padding(.leading, 16)
//
//                    }
//                    
//                }.padding(16)
//            }
//        }
        .onAppear {
            service.getItemData { items in
                menuItems = items
                print(items)
            }
        }
    }

}

struct ImageView:  View {
    @StateObject var downloader = ImageDownloader()
    var url: String
    
    var body: some View {
        VStack {
            Image(uiImage: downloader.image )
                .resizable()
                .scaledToFit()
            
        }
        .onAppear {
            downloader.downloadImage(imageURL: url )
        }
    }
}


class ImageDownloader: ObservableObject {
    @Published var image: UIImage = UIImage()
    
    func downloadImage(imageURL: String) {
        
        if let url = URL(string: imageURL) {
            let req = URLRequest(url: url)
            
            URLSession.shared.dataTask(with: url) { [weak self] data, res, err in
                DispatchQueue.main.async {
                    self?.image = UIImage(data: data!) ?? UIImage()
                }
                
            }.resume()
//            let data = try? Data(contentsOf: url) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
//            image = UIImage(data: data!) ?? UIImage()
        }

        
      
        
    }
    
}


// Consume ContentService API
// Display the list
// Accomodate null value in Model


// Model: Menu Items
// [Menu]


// View
// [Menu]
// Output List View
// dependecy MenuService

// MenuService
// getMenu() _> [Menu]?

// MenuNetworkService
// dependency: Network

// Network
// Decode the data response


struct MenuItems: Codable, Identifiable {
    var id = UUID()
    var title: String?
    var image_url: String?
    var description: String
    
    private enum CodingKeys: String, CodingKey {
            case title
            case description
            case image_url
        }
    
}

struct ContentItems: Codable {
    var content_items: [MenuItems]?
}




//struct ReadMoreTextView: View {
//    @State private var showFullText = false
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            Text(showFullText ? longText : shortText)
//                .lineLimit(showFullText ? nil : 2)
//                .foregroundColor(.black)
//
//            if !showFullText {
//                Button(action: {
//                    withAnimation {
//                        showFullText.toggle()
//                    }
//                }) {
//                    Text("Read More")
//                        .foregroundColor(.blue)
//                        .font(.footnote)
//                }
//            }
//        }
//        .padding()
//    }
//
//    let shortText = "This is a short text."
//    let longText = """
//    This is a long text that provides more information. \
//    It contains additional details that you may want to read. \
//    Click on the 'Read More' link to expand and view the full text.
//    """
//}


#Preview {
    MainView()
}





