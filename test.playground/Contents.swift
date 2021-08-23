import Cocoa

let arr1 = ["a","b","c"]
let arr2 = [0,1,2]
var dict = [String : Int]()

for (char, num) in zip(arr1,arr2) {
    dict[char] = num
}

print(dict)
