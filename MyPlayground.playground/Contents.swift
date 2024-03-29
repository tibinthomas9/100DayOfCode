import UIKit

class Solution17 {
    func maxProfit(_ prices: [Int]) -> Int {
        var l = 1
        var buyPrice = prices[0]
        var profit = 0
        var r = prices.count - 1
        while (l < r) {
            if prices[l] > buyPrice {
                profit = max(profit, prices[l] - buyPrice)
            } else {
                buyPrice = prices[l]
            }
            l = l + 1
        }
      return profit
    }
}
Solution17().maxProfit([7,1,5,3,6,4])

class Solution16 {
    func largestRectangleArea(_ heights: [Int]) -> Int {
        var maxA = 0
        for (i, height) in heights.enumerated() {
            let area = height + calcleftArea(value: height, left: i - 1) + calcRightArea(value: height, right: i + 1)
            maxA = max(maxA, area)
        }
        return maxA
        
        func calcleftArea(value: Int, left: Int) -> Int {
            if left < 0 {
                return  0
            }
            if heights[left] < value {
                return 0
            }
            return value + calcleftArea(value: value, left: left - 1)
            
        }
        
        func calcRightArea(value: Int, right: Int) -> Int {
            if right >= heights.count {
                return  0
            }
            if heights[right] < value {
                return 0
            }
            return value + calcRightArea(value: value, right: right + 1)
            
        }
    }
    
}
//Input: heights = [2,1,5,6,2,3]
//Output: 10
//let heights = [2,1,5,6,2,3]
///Solution16().largestRectangleArea(heights)
//Input: heights = [2,4]
//Output: 4
let heights = [2,4,10]
Solution16().largestRectangleArea(heights)
    
    
    
//Output: 10

class Solution15 {
    func trap(_ height: [Int]) -> Int {
        // find first posiutve vlasue whuch is left edge
        // then if next value is decrement compared to left edge
       // push to sthack left - jeight
      // when next value is greater or equal to left, it is right
      // area = comined of all stack
      // if we reach end with no right
       // then pop
        
        var l = 0, r = height.count - 1
        var lMax = height[l], rMax = height[r]
        var res = 0
        
        while (l < r) {
            if lMax <= rMax {
                l += 1
                lMax = max(lMax, height[l])
                res += lMax - height[l]
            } else  {
                r -= 1
                rMax = max(rMax, height[r])
                res += rMax - height[r]
            }
        }
        return res
    }
}

let height = [0,1,0,2,1,0,1,3,2,1,2,1]
Solution15().trap(height)
//Output: 6

class Solution14 {
    
    func longestConsecutive2(_ nums: [Int]) -> Int {
        let numSet = Set(nums)
        var seen = Set<Int>()
        var largest = 0
        for ele in numSet {
            var lower = ele - 1
            var count = 1
            if seen.contains(ele) {
                continue
            }
            while numSet.contains(lower) {
               seen.insert(lower)
               count += 1
               lower = lower - 1
            }
            largest = max(largest, count)
        }
        return largest
    }
    func longestConsecutive(_ nums: [Int]) -> Int {
        let numSet = Set(nums)
        var hashMap = [Int: [Int]]()
        var largest = 0
        for ele in nums {
            
            let upper = ele + 1
            let lower = ele - 1
            if let upperArray = hashMap[upper] {
                hashMap[upper]?.append(ele)
                largest = max(largest, upperArray.count)
            }
            if let lowerArray = hashMap[lower] {
                hashMap[lower]?.append(ele)
                largest = max(largest, lowerArray.count)
            }
        }
        return largest
    }

}

let nums = [100,4,200,1,3,2]
Solution14().longestConsecutive2(nums)
//Output: 4
class Solution13 {
    func carFleet(_ target: Int, _ position: [Int], _ speed: [Int]) -> Int {
        var  pair = [(Int, Int)]()
        let count = position.count
        for (i, pos) in position.enumerated() {
            pair.append((pos, speed[i]))
        }
        var stack = [Double]()
       let sorted = pair.sorted { $0.0 > $1.0 }
        print("sorted", sorted)
        for (p, s) in sorted {
            stack.append((Double(target - p)) / Double(s))
            print(stack)
            if stack.count >= 2 && stack.last ?? 0 <= stack.suffix(2).first ?? 0 {
                print("pop", stack.suffix(2).first ?? 0 )
                stack.popLast()
            }
        }
        
       
        return stack.count
    }
    
}
let target = 10, position = [6,8], speed = [3,2]
Solution13().carFleet(target, position, speed)

class Solution12 {
    func isValidSudoku(_ board: [[Character]]) -> Bool {
        
        var rowSet = [Int: Set<Character>]()
        var columnSet = [Int: Set<Character>]()
        var squareSet = [Int: Set<Character>]()

        for row in 0...8 {
            for column in 0...8 {
                let ele =  board[row][column]
                let square = (row)/3 * 3 + (column)/3
                if ele == "." {
                    continue
                }
                if let rowSet = rowSet[row], rowSet.contains(ele) {
                  return false
                }
                    
                else if let columnSet =  columnSet[column], columnSet.contains(ele) {
                    return false
                }
                
                else if let squareSet = squareSet[square], squareSet.contains(ele) {
                    return false
                }
                else {
                   
                    rowSet[row, default: []].insert(ele)
                    columnSet[column, default: []].insert(ele)
                    squareSet[square, default: []].insert(ele)
                }
            }
        }
        return true
    }
}

let board:  [[Character]] =
[["8","3",".",".","7",".",".",".","."]
,["6",".",".","1","9","5",".",".","."]
,[".","9","8",".",".",".",".","6","."]
,["8",".",".",".","6",".",".",".","3"]
,["4",".",".","8",".","3",".",".","1"]
,["7",".",".",".","2",".",".",".","6"]
,[".","6",".",".",".",".","2","8","."]
,[".",".",".","4","1","9",".",".","5"]
,[".",".",".",".","8",".",".","7","9"]]

Solution12().isValidSudoku(board)
class Solution11 {
    func dailyTemperatures(_ temperatures: [Int]) -> [Int] {
        var ans = [Int]()
        for (i,temp) in temperatures.enumerated() {
            if let nextMaxIndex = temperatures[i...].firstIndex(where: { $0 > temp }) {
                ans.append(nextMaxIndex - i)
            } else {
                ans.append(0)
            }
        }
       return ans
    }
}

let temperatures = [73,74,75,71,69,72,76,73]
Solution11().dailyTemperatures(temperatures)
//Output: [1,1,4,2,1,1,0,0]


/*
 Given n pairs of parentheses, write a function to generate all combinations of well-formed parentheses.
 Input: n = 3
 Output: ["((()))","(()())","(())()","()(())","()()()"]
 
 Input: n = 1
 Output: ["()"]
 */
class Solution10 {
    func generateParenthesis(_ n: Int) -> [String] {
        
        // add open only if open < n
        // add closed only if closed < open
        // open, cloded , n equal
        
        var stack = [String]()
        var res = [String]()
        
        func backtrack(open: Int, closed: Int) {
            if open == closed, open == n {
                res.append(stack.joined())
                print("base end")
                print(stack)
                return
            }
            
            if open < n {
                stack.append("(")
                print("first beg")
                print(stack)
                backtrack(open: open + 1, closed: closed)
                stack.popLast()
                print("first end")
                print(stack)
                
            }
            if closed < open {
                stack.append(")")
                print("second beg")
                print(stack)
                backtrack(open: open , closed: closed + 1)
                stack.popLast()
                print("second end")
                print(stack)
                
            }
        }
        backtrack(open: 0, closed: 0)
        return res
//        var res = ["("]
//        var str = "("
//        for i in 2...(2 * n - 1) {
//            str.append("(")
//            str.append(")")
//        }
//        for i in n...1  {
//            var comb = ""
//            var stack = Array(repeating: "(", count: i)
//            for j in i - n + 1 {
//                
//            }
//            
//        }
    }
}
Solution10().generateParenthesis(3)
/*
 Input: tokens = ["2","1","+","3","*"]
 Output: 9
 Explanation: ((2 + 1) * 3) = 9
 */
class Solution9 {
    func evalRPN(_ tokens: [String]) -> Int {
        var stack = [String]()
        let operation = ["+", "-", "*", "/"]
        
        // loop thorugh token
        // if not operastion , push to stack
        // else pop two and do operation
        // and push back to stalc
        for str in tokens {
            if  operation.contains(str) {
                
                let b = Int(stack.popLast() ?? "") ?? 0
                let a = Int(stack.popLast() ?? "") ?? 0
                
                switch str {
                case "+":
                    stack.append( String(a + b))
                case "-":
                    stack.append( String(a - b))
                case "*":
                    stack.append( String(a * b))
                case "/":
                    stack.append( String(a / b))
                default:
                    break
                }
            } else {
                stack.append(str)
            }
        }
        return Int(stack.first ?? "") ?? 0
    }
}
let tokens = ["2","1","+","3","*"]
Solution9().evalRPN(tokens)

class MinStack {
    
    var stackStore: [Int]
    var minStack: [Int]

    init() {
        stackStore = []
        minStack = []
    }
    
    func push(_ val: Int) {
        if stackStore.count < 1 {
            stackStore.append(val)
            minStack.append(val)
        }
        else {
            
            if val < minStack.last ?? 0 {
                stackStore.append(val)
                minStack.append(val)
            } else {
                minStack.append(minStack.last ?? 0)
                stackStore.append(val)
               
            }
        }
    }
    
    func pop() {
        stackStore.popLast()
        minStack.popLast()
    }
    
    func top() -> Int {
        stackStore.last ?? -1
    }
    
    func getMin() -> Int {
        return minStack.last ?? 0
    }
}

/**
 * Your MinStack object will be instantiated and called as such:
 * let obj = MinStack()
 * obj.push(val)
 * obj.pop()
 * let ret_3: Int = obj.top()
 * let ret_4: Int = obj.getMin()
 */



 
  let obj = MinStack()
obj.push(-2);
obj.push(0);
obj.push(-3);
obj.getMin(); // return -3
obj.pop();
obj.top();    // return 0
obj.getMin(); // return -2
 



/*
 Input: s = "()[]{}"
 Output: true
 */


class Solution {
    
    func isValid(_ s: String) -> Bool {
        let braces: [Character: Character] = ["]":"[", ")":"(", "}":"{"]
        
        var stack = [Character]()
        for char in s {
            
            // closing
            
            if braces.keys.contains(char) {
                let item = stack.popLast()
                if braces[char] != item {
                    return false
                }
            } else {
                // opening
                stack.append(char)
            }
            
        }
        return stack.isEmpty
    }
}

var s = "(()[]]{})"
print(Solution().isValid(s))

/*
 Input: nums = [1,2,3,4]
 Output: [24,12,8,6]
 */
    func productExceptSelf(_ nums: [Int]) -> [Int] {
        var prefix = [Int]()
        var postfix =  [Int]()
        var result =  [Int]()
        
        var prod = 1
         nums.forEach { num in
            prod *= num
            prefix.append(prod)
        }
        prod = 1
        nums.reversed().forEach { num in
            prod *= num
            postfix.append(prod)
        }
        postfix.reverse()
        print(prefix)
        print(postfix)
        for i in  0..<nums.count {
            let prefix = i == 0 ? 1 : prefix[i - 1]
            let postfix = i == (nums.count - 1)   ? 1 : postfix[i + 1]
            print(prefix,postfix)
            result.append (prefix * postfix)
        }
        return result
        
        
        //        let product = nums.reduce(1) { $0 * $1 }
        //        return nums.map { product / $0 }
//        var result = [Int]()
//        for (i,n) in nums.enumerated() {
//            var product = 1
//            for (j, item) in nums.enumerated() {
//                if i != j {
//                    product *= item
//                }
//                
//            }
//            result.append(product)
//
//            
//        }
//        return result
    }
    //}

//var nums = [1,2,3,4]
//    print(Solution().productExceptSelf(nums))
    
    /*
     Input: s = "abcabcbb"
     Output: 3
     Explanation: The answer is "abc", with the length of 3.
     */
    
    func lengthOfLongestSubstring(_ s: String) -> Int {
        // move through string from left to right
        // add the count of char to countDict
        // if a chars count become more than 1, move left by 1 until count becomes 1, also calculate length by
        var l = 0, r = 0
        let strArray = Array(s)
        var charCount: [Character: Int] = [:]
        var maxLength = 1
        while (r < strArray.count) {
            let righChar = strArray[r]
            charCount[righChar, default: 0] += 1
            r = r + 1
            
            while(charCount[righChar, default: 0] > 1) {
                let leftChar = strArray[l]
                charCount[leftChar, default: 0] -= 1
                l = l + 1
            }
            maxLength = max(maxLength, r - l)
            
            
            
//            let charCountR = charCount[strArray[r]] ?? 0
//            if charCountR > 0 {
//                charCount[strArray[l]] =  (charCount[strArray[l]] ?? 0) - 1
//                l = l + 1
//            } else {
//                charCount[strArray[r]] = 1
//                r = r + 1
//            }
//            maxLength = max(maxLength, r - l)
        }
        
        return maxLength
    }
    

//var s = "abcabcbb"
//    print(Solution().lengthOfLongestSubstring(s))
    /*
     Input: s = "A man, a plan, a canal: Panama"
     Output: true
     */
    func isPalindrome(_ s: String) -> Bool {
        let input = Array(s.filter { $0.isLetter || $0.isNumber }.lowercased())
        var l = 0, r = input.count - 1
        while(l < r) {
            if input[l] != input[r] {
                return false
            }
            l += 1
            r -= 1
        }
        return true
    }
//}
//    var s = "A man, a plan, a canal: Panama"
//    print(Solution().isPalindrome(s))
    //Day 3
    /* Input: prices = [7,1,5,3,6,4]
     Output: 5
     Explanation: Buy on day 2 (price = 1) and sell on day 5 (price = 6), profit = 6-1 = 5.
     Note that buying on day 2 and selling on day 1 is not allowed because you must buy before you sell.
     */
    func maxProfit(_ prices: [Int]) -> Int {
        var l = 1
        
        var maxProfit = 0
        var buyPrice = prices[0]
        
        // loop through array from start
        while l < prices.count {
            // if pricce greater than last check profit and save else buy
            if  prices[l] > buyPrice {
                var profit = prices[l] - buyPrice
                if profit > maxProfit {
                    maxProfit = profit
                }
            } else {
                buyPrice = prices[l]
            }
            print(maxProfit, l)
            l = l + 1
        }
        return maxProfit
    }
    

//var nums = [1,1,1,2,2,3]
//Solution().topKFrequent3(nums, 2)
//var prices = [7,1,5,3,6,4]
//Solution().maxProfit(prices)
    
    // Container With Most Water
    
    
// Day 2
//Input: height = [1,8,6,2,5,4,8,3,7]
//Output: 49
//Explanation: The above vertical lines are represented by array [1,8,6,2,5,4,8,3,7]. In this case, the max area of water (blue section) the container can contain is 49.
    func maxArea(_ height: [Int]) -> Int {
        var l = 0
        var r = height.count - 1
        
        // move from left and right
        // find area, save to maxarea
        // if l < r , move l by one and vice versa
        // if they cross or equal end and repat maxarea
        var maxArea = 0
        while l < r {
            maxArea = max((r - l) * min(height[l], height[r]), maxArea)
            if height[l] > height[r] {
                r = r - 1
            } else {
                l = l + 1
            }
        }
        return maxArea
    }
    func topKFrequent3(_ nums: [Int], _ k: Int) -> [Int] {
            var frequency:[Int: Int] = [:]
            for x in nums {
                frequency[x, default: 0] += 1
            }
            var orderedNumbers = Array(frequency)
            orderedNumbers.sort{$0.value > $1.value}
            var result = orderedNumbers[0..<k].map{ $0.key}
            return result

        }
    
    func topKFrequent2(_ nums: [Int], _ k: Int) -> [Int] {
            var info = [Int: Int]() // num: count
            for num in nums {
                info[num, default: 0] += 1
            }
            var result = [Int]()
        
            let sortedInfo = info.sorted { $0.value > $1.value }
        print(sortedInfo)
        print(Array(info))
        
        
            for i in 0..<k {
                result.append(sortedInfo[i].key)
            }
            return result
        }
    func topKFrequent(_ nums: [Int], _ k: Int) -> [Int] {

        var countMap = [Int:Int]()
        var freqArr = Array(repeating: [Int](), count: nums.count+1)

        // move to countmap
        for ele in nums {
            countMap[ele] = countMap[ele, default: 0] + 1
        }
        for (key,value) in countMap {
            freqArr[value].append(key)
        }
        var out = [Int]()
        var kcount = 0
        for i in (0...nums.count).reversed() {
            let ele = freqArr[i]
            for item in ele {
                out.append(item)
                kcount += 1
                if kcount >= k {
                    return out
                }
            }
            
            
        }
        print("countMap", countMap)
        return out
    }
    
   
//}
//var nums = [1,1,1,2,2,3]
//Solution().topKFrequent3(nums, 2)


//var height = [1,8,6,2,5,4,8,3,7]
//Solution().maxArea(height)
