//
//  main.swift
//  ccwc
//
//  Created by Tibin Thomas on 2024-02-01.
//

import Foundation

struct FileError: Error {}

print("Hello, World!")

let arguments = CommandLine.arguments

if arguments.count > 1 {
if arguments[1] == "-c" {
    if arguments.count > 2 {
        let filename = arguments[2]
        let filehandler = FileManager.default
        guard filehandler.fileExists(atPath: filename) else {
            print("file not found ")
            throw FileError()
        }
        do {
            let filedata = try Data(contentsOf: URL(fileURLWithPath: filename))
            print(filedata.count)
        }
        catch {
            print("Error reading file ")
        }
    }
        
    }
}

print(arguments)

