//
//  ContentView.swift
//  Bookworm
//
//  Created by Tibin Thomas on 2024-02-15.
//
import SwiftData
import SwiftUI


struct DetailView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var isShoeing = false
    
    let book: Book
    
    var body: some View {
        ZStack {
            ScrollView {
                ZStack(alignment: .bottomTrailing) {
                    Image(book.genre)
                        .resizable()
                        .scaledToFit()
                    Text(book.genre.uppercased())
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .foregroundStyle(.white)
                        .background(.black.opacity(0.75))
                        .clipShape(Capsule())
                        .offset(x:-5, y: -5)
                    }
                Text(book.author)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(.secondary)
                Text(book.review)
                    .padding()
                RatingView(rating: .constant(book.rating))
                Button("Ok", role: .destructive) {
                    isShoeing.toggle()
                }
                }
            .alert("Delete Book", isPresented: $isShoeing)  {
                Button("Ok", role: .destructive, action: delete)
            } message: {
                Text("Delte")
            }
        
            .navigationTitle(book.title)
            .navigationBarTitleDisplayMode(.inline)
            .scrollBounceBehavior(.basedOnSize)
            }
        }
    func delete() {
        modelContext.delete(book)
        dismiss()
    }
}


struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: [
        SortDescriptor(\Book.title, order: .reverse),
        SortDescriptor(\Book.author, order: .reverse)])
    var books: [Book]
    
    @State private var showingAddScren = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(books, id: \.self) { book in
                    NavigationLink(value: book) {
                        HStack {
                            EmojiRatingView(rating: book.rating)
                                .font(.largeTitle)
                            VStack(alignment: .leading) {
                                Text(book.title)
                                    .font(.headline)
                                Text(book.author)
                                    .foregroundStyle(.secondary)
                            }
                            }
                        }
                }.onDelete(perform: deleteBooks)
            }
            .navigationDestination(for: Book.self, destination: { book in
                DetailView(book: book)
            })
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        EditButton()
                    }
                    ToolbarItem(placement: .topBarTrailing ) {
                        Button("Add", systemImage: "plus") {
                            showingAddScren.toggle()
                        }
                    }

        }        }.sheet(isPresented: $showingAddScren, content: {
            AddBookView()
        })
        
    }
    
    func deleteBooks(offSets: IndexSet) {
        for offset in offSets {
            let book = books[offset]
            modelContext.delete(book)
        }
    }
}
struct AddBookView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var author = ""
    @State private var genre = "Fantasy"
    @State private var review = ""
    @State private var rating = 3
    let genres = ["Fantasy", "Horror", "Drama", "Kids"]
    
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Title", text: $title)
                    TextField("Author", text: $author)
                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) { genre in
                            Text(genre)
                        }
                    }
                }
                Section("Review") {
                    TextField("Review", text: $review, axis: .vertical)
                    RatingView(rating: $rating)
                }
                
                Section {
                    Button("Add") {
                        let newBook = Book(title: title, author: author, genre: genre, review: review, rating: rating)
                        modelContext.insert(newBook)
                        dismiss()
                    }
                }
                
            }
        }.navigationTitle("Add Book")
    }
}
















struct ContentView3: View {
  //  @AppStorage("notes") private var notes = ""
  //  @Query var students: [Student]
  //  @Environment(\.modelContext) var modelContext
    @State var sliderValue:CGFloat = .zero
  
    var body: some View {
        Text("")
        JunoSlider(sliderValue:$sliderValue, maxSliderValue: 1, label: "label")
    }
//    var body: some View {
//        NavigationStack {
//            List(students) { student in
//                Text(student.name)
//            }
//            .toolbar {
//                Button("Add Student", action: addStudent)
//            }
//            .navigationTitle("ClassRoom")
//        }
//    }
//    
//    func addStudent() {
//        let first = ["John", "Mem", "Dark"]
//        let last = ["Johaan", "mMem", "DDark"]
//        let student = Student(id: UUID(), name: (first.randomElement() ?? "") + (last.randomElement() ?? "") )
//        modelContext.insert(student)
//    }
                       
                       
                       
    
//    var body: some View {
//        NavigationStack {
//            TextEditor(text: $notes)
//        }
//        .padding()
//    }
}

#Preview {
    ContentView()
}

import SwiftUI
import AVFoundation

/// A slider that expands on selection.
struct JunoSlider: View {
    @Binding var sliderValue: CGFloat
    let maxSliderValue: CGFloat
    let baseHeight: CGFloat
    let expandedHeight: CGFloat
    let label: String
    let editingChanged: ((Bool) -> Void)?
    
    @State private var isGestureActive: Bool = false
    @State private var startingSliderValue: CGFloat?
    @State private var sliderWidth = 10.0 // Just an initial value to prevent division by 0
    @State private var isAtTrackExtremity = false
    
    /// Create a slider that expands on selection.
    /// - Parameters:
    ///   - sliderValue: Binding for the current value of the slider
    ///   - maxSliderValue: The highest value the slider can be
    ///   - baseHeight: The slider's height when not expanded
    ///   - expandedHeight: The slider's height when selected (thus expanded)
    ///   - label: A string to describe what the data the slider represents
    ///   - editingChanged: An optional block that is called when the slider updates to sliding and when it stops
    init(sliderValue: Binding<CGFloat>, maxSliderValue: CGFloat, baseHeight: CGFloat = 9.0, expandedHeight: CGFloat = 20.0, label: String, editingChanged: ((Bool) -> Void)? = nil) {
        self._sliderValue = sliderValue
        self.maxSliderValue = maxSliderValue
        self.baseHeight = baseHeight
        self.expandedHeight = expandedHeight
        self.label = label
        self.editingChanged = editingChanged
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            // visionOS (on device) does not like when drag targets are smaller than 40pt tall, so add an almost-transparent (as it still needs to be interactive) that enforces an effective minimum height. If the slider is tall than this on its own it's essentially just ignored.
//            Color.orange.opacity(0.0001)
//                .frame(height: 40.0)
            
            LinearGradient(colors: [.red, .green], startPoint: .topLeading, endPoint: .bottom)
                .background {
                    GeometryReader { proxy in
                        Color.clear
                            .onAppear {
                                sliderWidth = proxy.size.width
                            }
                    }
                }
                .frame(height: isGestureActive ? expandedHeight : baseHeight)
//                .foregroundStyle(
//                    Color(white: 0.1, opacity: 0.5)
//                        .shadow(.inner(color: .black.opacity(0.3), radius: 3.0, y: 2.0))
//                )
//                .shadow(color: .white.opacity(0.2), radius: 1, y: 1)
                .overlay(alignment: .leading) {
                    Capsule()
//                        .overlay(alignment: .trailing) {
//                            Circle()
//                               .foregroundStyle(Color.white)
//                                .shadow(radius: 1.0)
//                                .padding(innerCirclePadding)
//                                .opacity(isGestureActive ? 1.0 : 0.0)
//                        }
                        .foregroundStyle(Color(white: isGestureActive ? 0.85 : 0.90))
                        .frame(width: calculateProgressWidth(), height: isGestureActive ? expandedHeight : baseHeight)
                }
                .clipShape(.capsule) // Best attempt at fixing a bug https://twitter.com/ChristianSelig/status/1757139789457829902
                .contentShape(.hoverEffect, .capsule)
            Circle()
                .frame(height: isGestureActive ? 50  :40)
                .offset(x:calculateProgressWidth() - 20)
                .foregroundStyle(Color.white)
                .shadow(radius: 1.0)
                .padding(innerCirclePadding)
                .opacity(isGestureActive ? 1.0 : 0.96)
                .animation(.bouncy, value: isGestureActive)
                //.scaleEffect(isGestureActive ? 1.5 : 1)
        }
        .gesture(DragGesture(minimumDistance: 0.0)
            .onChanged { value in
                if startingSliderValue == nil {
                    startingSliderValue = sliderValue
                    isGestureActive = true
                    editingChanged?(true)
                }
                
//                let percentagePointsIncreased = value.translation.width / sliderWidth
//                let initialPercentage = (startingSliderValue ?? sliderValue) // maxSliderValue
//                let newPercentage = min(1.0, max(0.0, initialPercentage + percentagePointsIncreased))
                let newPercentage = value.location.x / sliderWidth
                withAnimation(.interactiveSpring) {
                    sliderValue = newPercentage //* maxSliderValue
                }
                
                
//                if newPercentage == 0.0 && !isAtTrackExtremity {
//                    isAtTrackExtremity = true
//                } else if newPercentage == 1.0 && !isAtTrackExtremity {
//                    isAtTrackExtremity = true
//                } else if newPercentage > 0.0 && newPercentage < 1.0 {
//                    isAtTrackExtremity = false
//                }
            }
            .onEnded { value in
                // Check if they just tapped somewhere on the bar rather than actually dragging, in which case update the progress to the position they tapped
                if value.translation.width == 0.0 {
                    let newPercentage = value.location.x / sliderWidth
                    
                    withAnimation {
                        sliderValue = newPercentage * maxSliderValue
                    }
                }
                
                startingSliderValue = nil
                isGestureActive = false
                editingChanged?(false)
            }
        )
        .hoverEffect(.highlight)
        .accessibilityRepresentation {
            Slider(value: $sliderValue, in: 0.0 ... maxSliderValue, label: {
                Text(label)
            }, onEditingChanged: { editingChanged in
                self.editingChanged?(editingChanged)
            })
        }
    }
    
    var innerCirclePadding: CGFloat { expandedHeight * 0.15 }
    
    private func calculateProgressWidth() -> CGFloat {
        let minimumWidth = isGestureActive ? expandedHeight : baseHeight
        let calculatedWidth = (sliderValue) * sliderWidth
        
        // Don't let the bar get so small that it disappears
        return max(minimumWidth, calculatedWidth)
    }
}


