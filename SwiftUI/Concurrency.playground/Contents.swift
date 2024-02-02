import Foundation



// Starts program

scheduleDetailPrint("1", onQueue: .main, waitType: .sync, byQueue: .main)
printWithThreadName("1")


scheduleDetailPrint("2", onQueue: .main, waitType: .async, byQueue: .main)
DispatchQueue.main.async {
    sleepWithPrint(2)
    printWithThreadName("2")
}


scheduleDetailPrint("3", onQueue: .main, waitType: .async, byQueue: .main)
DispatchQueue.main.async {
    printWithThreadName("3")
}


scheduleDetailPrint("4", onQueue: .main, waitType: .async, byQueue: .main)
DispatchQueue.main.async {
    printWithThreadName("4")
}


scheduleDetailPrint("5", onQueue: .main, waitType: .sync, byQueue: .main)
printWithThreadName("5")
sleepWithPrint(1)



scheduleDetailPrint("6", onQueue: .global, waitType: .async, byQueue: .main)
DispatchQueue.global().async {
    sleepWithPrint(3)
    printWithThreadName("6")
}


scheduleDetailPrint("7", onQueue: .global, waitType: .async, byQueue: .main)
DispatchQueue.global().async {
    printWithThreadName("7")
}


scheduleDetailPrint("8", onQueue: .global, waitType: .async, byQueue: .main)
DispatchQueue.global().async {
    printWithThreadName("8")
        // sync allowed becuase running synchronously on the same concurrent queue(here global) will not cause a deadlock

    DispatchQueue.global().sync {
        scheduleDetailPrint("0", onQueue: .global, waitType: .async, byQueue: .global)
        printWithThreadName("0")
    }
}

scheduleDetailPrint("9", onQueue: .main, waitType: .sync, byQueue: .main)
printWithThreadName("9")

// sync not allowed becuase running synchronously on the same serial queue(here main) will cause a deadlock
//DispatchQueue.main.sync {
//    printWithThreadName("0")
//}



enum Quetype {
    case main
    case global
}
enum WaitType {
    case sync
    case async
    
    var desc: String {
        switch self {
        case .sync:
            return "no wait"
        case .async:
            return "waiting on other tasks to finish"
        }
    }
}

func printWithThreadName(_ str: String) {
    print( str + " \(Thread.current)")
}

func sleepWithPrint(_ time: Double) {
    print( "\t\t sleeping \(time) on \(Thread.current)")
    Thread.sleep(forTimeInterval: time)
}

func scheduleDetailPrint(_ string: String,onQueue:Quetype , waitType: WaitType , byQueue: Quetype) {
    print("\t \(string) gets scheduled on \(onQueue) by \(byQueue) with \(waitType.desc)")
}



//let concurrent = DispatchQueue(label: "com.besher.concurrent", attributes: .concurrent)
//let isolation = DispatchQueue(label: "com.besher.isolation", attributes: .concurrent)
//    private var _array = [1,2,3,4,5]
//    
//    var threadSafeArray: [Int] {
//        get {
//            return isolation.sync {
//                _array
//            }
//        }
//        set {
//            isolation.async(flags: .barrier) {
//                _array = newValue
//            }
//        }
//    }
//    
//     
//    
//    
//    func race() {
//        concurrent.async {
//            for i in threadSafeArray {
//                print(i)
//            }
//        }
//        
//        concurrent.async {
//            for i in 0..<10 {
//                threadSafeArray.append(i)
//            }
//        }
//    }
//for _ in 0...15 {
//    race()
//}
//
//
//
//
//
//
//
//
//
//
