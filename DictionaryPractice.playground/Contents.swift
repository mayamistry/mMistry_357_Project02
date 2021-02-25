import UIKit

var passwordDict: [String: String] = ["Email":"pass1", "Instagram":"pass2","Facebook":"pass3"]

let pass1: String = passwordDict["Email"]!
print(pass1)

let key1: String = "pass"

if passwordDict.keys.contains(key1) {
  print("contains key")
} else {
  print("does not contain key")
}

passwordDict.removeValue(forKey: "Email")
print(passwordDict)


