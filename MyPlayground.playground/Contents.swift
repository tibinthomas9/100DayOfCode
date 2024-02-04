import UIKit



class Solution {
    
    
    
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
    
}

var prices = [7,1,5,3,6,4]
Solution().maxProfit(prices)
    
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
