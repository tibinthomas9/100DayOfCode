//
//  SrollableSearchView.swift
//  Menu
//
//  Created by Tibin Thomas on 2024-01-31.
//  Copyright © 2024 DoorDash, Inc. All rights reserved.
//

import SwiftUI

var currencyFormatter: NumberFormatter = {
    let nf = NumberFormatter()
    nf.numberStyle = .currency
    nf.currencyCode = "CAD"
    return nf
}()

// Custom preference key to track the view offset

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero

    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
    }
}






struct SrollableSearchView: View {
    
    
    @StateObject var vm = ContentServiceViewModel()
    @State private var scrollOffset: CGPoint = .zero
    @State private var searrchBarWidth: CGFloat = .zero
    @State private var contentAligned:Bool = false
    @State private var scrollOFFsxety:Double = 0
    
    var body: some View {
        ZStack(alignment:.top) {
            LinearGradient(colors: [.blue, .white], startPoint: .bottomTrailing, endPoint: .topLeading)
                .ignoresSafeArea()
            Color.white.padding(.top, 80)
            HStack {
                Button(action: {}, label: {
                    Image(systemName: "xmark.app.fill")
                        .resizable()
                        .foregroundColor(Color.white)
                        .background(Color.black)
                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                        .frame(width: 40, height: 40)
                        .shadow(radius: 7)
                }).padding()
                Spacer()
            }.background()
            
            VStack {
                GeometryReader { geo in
                    let finalWidth = (geo.size.width * 0.9)
                    let minWidth = (geo.size.width * 0.7)
                    let _ = print("finalWidth", finalWidth)
                    let progress = max(min(-scrollOffset.y / (finalWidth - CGFloat(minWidth)), 1), 0)
                    let scale = 1 - (progress * 0.2)
                    
                    // checking if views align
                    
                    
                    let width =  min(geo.size.width  * scale, geo.size.width  * 0.9)
                    ScrollView {
                        VStack {
                            Spacer(minLength: 40)
                            CirCleImageView(image: Image(systemName: "pencil.tip")).frame(width: 100, height: 100)
                              //  .offset(x: -scrollOffset.y, y: 0)
                            BrandView()
                            HStack {
                                Spacer()
                                SearchView()
                                    .background(SizeReader())
                                    .frame(width: min(finalWidth, max(finalWidth  + scrollOffset.y/5, minWidth)))
                                    .offset(y: scrollOFFsxety )
                                    .padding(.trailing, 10)
                                if width == geo.size.width  * 0.9 {
                                    Spacer()
                                }
                            }
                            UnderSearchBarView()
                        }.zIndex(1000)
                        .background(GeometryReader { geometry in
                            Color.clear.frame(height: 0)
                                .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll")).origin)
                        }.onPreferenceChange(ScrollOffsetPreferenceKey.self) { offset in
                            
                            // Update the scroll offset
                            withAnimation {
                                self.scrollOffset = offset
                            }
                            
                            // You can perform actions based on the scroll offset here
                            print("onPreferenceChange Scroll Offset: \(scrollOffset)")
                        }
                                    
                        )
                        
                    }.onAppear {
                        searrchBarWidth = geo.size.width - 30
                    }
                    .coordinateSpace(name: "scroll")
                }
            }
            .edgesIgnoringSafeArea(.bottom)
        }.onPreferenceChange(Sizes.self) { (value) in
           
            let searchbarY = ceil(value[0].maxY)
            if searchbarY < 100 {
                scrollOFFsxety = -scrollOffset.y
            } else {
                scrollOFFsxety = 0
            }
            
            
                print("onsame level")
              
           
            print()
        }
    }
}

#Preview {
    SrollableSearchView()
}









struct BrandView: View {
    var body: some View {
        
        VStack(spacing: 8) {
            Text("Shoppers Drug Mart")
                .font(.title2)
                .bold()
            HStack {
                Image(systemName: "star.fill")
                Text("4.6 (249)")
                Text("|").foregroundColor(.gray)
                Text("31 min")
                Text("|").foregroundColor(.gray)
                Text("24 km")
            }
            HStack {
                Text(currencyFormatter.string(for: 2) ?? "").fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/) + Text(" delivery fee")
            }
            HStack {
                Text("Pricing and fees").underline()
                Text("|")
                    .foregroundColor(.gray)
                Text( "Service fees apply").underline()
            }
        }
    }
}

struct CirCleImageView: View {
    var image: Image
    
    var body: some View {
        image
            .resizable()
            .scaledToFill()
            .background(Color.white.opacity(0.6))
            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
            .overlay(Circle().stroke(.white, lineWidth: 1))
            .shadow(radius: 7)
            
    
    }
}
    



struct SearchView: View {
    var body: some View {
        HStack {
            Image(systemName: "text.magnifyingglass.rtl")
            TextField("", text: .constant("search text")).foregroundColor(Color.red).font(.caption)
        }
        .padding()
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(Color.gray))
    }
}

struct UnderSearchBarView: View {
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(1..<10) { i in
                        VStack {
                            Image(systemName: "tray.circle.fill")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(Color.blue.opacity(0.5))
                                .scaledToFit()
                                
                            Text("Deals")
                        }.frame(width: 100, height: 100)
                    }
                }
            }
            ForEach(1..<6) { i in
                Circle().padding()
            }
        }
    }
}


struct SizeReader: View {
    var body: some View {
        GeometryReader { proxy in
            Color.clear
            .preference(key: Sizes.self, value: [proxy.frame(in: .global)])
        }
    }
}

struct Sizes: PreferenceKey {
    typealias Value = [CGRect]
    static var defaultValue: [CGRect] = []

    static func reduce(value: inout [CGRect], nextValue: () -> [CGRect]) {
        value.append(contentsOf: nextValue())
    }
}

