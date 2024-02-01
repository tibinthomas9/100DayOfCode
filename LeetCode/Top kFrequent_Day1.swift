class Solution {
    
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
    
   
}
var nums = [1,1,1,2,2,3]
Solution().topKFrequent3(nums, 2)
