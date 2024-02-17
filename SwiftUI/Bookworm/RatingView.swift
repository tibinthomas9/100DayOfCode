//
//  RatingView.swift
//  Bookworm
//
//  Created by Tibin Thomas on 2024-02-16.
//

import SwiftUI

struct RatingView: View {
    @Binding var rating: Int
    var label = ""
    var maximumRating = 5
    var onImage = Image(systemName: "star.fill")
    var offImage: Image?
    
    var onColour = Color.yellow
    var offColour = Color.gray
    
    var body: some View {
        HStack {
            if !label.isEmpty {
                Text(label)
            }
            ForEach(1..<maximumRating + 1, id: \.self) { number in
                Button(action: {
                    rating = number
                }, label: {
                    imageFor(number: number)
                        .foregroundStyle(number > rating ? offColour : onColour )
                })
               
                
            }
        }.buttonStyle(.plain)
    }
    
    func imageFor(number: Int) -> Image {
        if number > rating {
            offImage ?? onImage
        } else {
            onImage
        }
    }
}

#Preview {
    RatingView(rating: .constant(2))
}


struct EmojiRatingView: View {
    let rating: Int
   
    
    var body: some View {
        switch rating {
        case 1:
            Text("🤬")
        case 2:
            Text("😱")
        case 3:
            Text("😇")
        case 4:
            Text("😀")
        case 5:
            Text("🤣")
        default:
            Text("😀")
        }
    }
   
}

