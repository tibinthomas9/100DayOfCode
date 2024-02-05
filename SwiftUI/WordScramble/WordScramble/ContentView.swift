//
//  ContentView.swift
//  WordScramble
//
//  Created by Tibin Thomas on 2024-02-04.
//

import SwiftUI

struct ContentView: View {
    let textFile = Bundle.main.url(forResource: "start", withExtension: "text")
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    var body: some View {
        NavigationStack{
            List {
                Section {
                    TextField("Enter your word",text: $newWord)
                        .textInputAutocapitalization(.never)
                }
                Section {
                    
                   
                    
                    ForEach(usedWords, id: \.self) { word in
                        HStack {
                        Image(systemName: "\(word.count).circle")
                        Text(word)
                       }
                    }
                }
                
            }
            .navigationTitle($rootWord)
            .onSubmit(addNewWord)
            .onAppear(perform: startGame)
            .alert(errorTitle, isPresented: $showingError) {
                
            } message: {
                Text(errorMessage)
            }
        }
        .padding()
    }
    
    func isOringinal(text: String) -> Bool  {
         !usedWords.contains(text)
    }
    
    func isPosssiblel(text: String) -> Bool  {
        var tempword = rootWord
        for letter in text {
            if let index = tempword.firstIndex(of: letter) {
                tempword.remove(at: index)
            } else {
                return false
            }
        }
        return true
        
    }
    
    func isValid(text: String) -> Bool  {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: text.utf16.count)
        let misSpelledRange = checker.rangeOfMisspelledWord(in: text, range: range, startingAt: 0, wrap: false, language: "en")
        return misSpelledRange.location == NSNotFound
        
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 0 else { return }
        guard isOringinal(text: answer) else {
            wordError(title: "word used already", message: "be more original")
            return
        }
        guard isPosssiblel(text: answer) else {
            wordError(title: "word not possible", message: "Use right letters")
            return
        }
        guard isValid(text: answer) else {
            wordError(title: "word is invalid", message: "Learn English")
            return
        }
        withAnimation {
            
            
            usedWords.insert(answer, at: 0)
            newWord = ""
        }
        
    }
    
    func startGame() {
        if let file = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let contents = try? String(contentsOf: file) {
                let allWords = contents.components(separatedBy: "\n")
               // withAnimation {
                    
                    
                    rootWord = allWords.randomElement() ?? "eightten"
               // }
                return
            }
        }
        
    }
    
    func wordError(title:String, message:String) {
        errorMessage = message
        errorTitle = title
        showingError = true
    }
    
    func testChecker() {
        let word = "swift"
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misRanger = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        let allgood = misRanger.location == NSNotFound
    }
    
    func testStrings() {
        let inData = "A V C DEF".map {$0}
        //let input = inData.components(separatedBy: " ")
       // print(input)
        print(inData)
    }
    
    func testFile() {
        if let file = Bundle.main.url(forResource: "start", withExtension: "text") {
            let contents = try? String(contentsOf: file)
        }
    }
}

#Preview {
    ContentView()
}
