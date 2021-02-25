//
//  main.swift
//  mMistry_Proj02
//
//  Created by Maya Mistry on 2/22/21.
//

import Foundation

//FUNCTION unwrap with guard
func unwrapWithGuard(input: String?) -> String {
    guard let unwrappedString = input else {
        print("didnt work")
        return ""
    }
    print("Sucess: \(unwrappedString)")
    return unwrappedString
}


//Class that allows us to read userInput
class Ask {
    static func AskQuestion(questionText output:String, acceptableReplies inputArr: [String], caseSensitive: Bool = false) -> String {
        print(output) //ask our question
        
        //Handle response
        guard let response = readLine() else {
            //they didnt type anything
            print("Invalid input - please try again.")
            //recursive function until they do the right thing
            return AskQuestion(questionText: output, acceptableReplies: inputArr)
        }
        
        //they typed a valid answer
        // verify that the response is acceptable OR don't care what response is
        if (inputArr.contains(response) || inputArr.isEmpty) {
            return response
        } else {
            //resposne does not conform to requirements
            print("Invalid input - please try again.")
            //recursive function until they do the right thing
            return AskQuestion(questionText: output, acceptableReplies: inputArr)
        }
    }
}

func reverseInput(stringToReverse input: String) -> String {
    //built in function with the String class
    return String(input.reversed())
    //getting casted from array of characters back to string
}

//Function used within the scramble function
func translateScramble(l: Character, trans: Int) -> Character {
    if let ascii = l.asciiValue {
        var outputInt = ascii
        if (ascii >= 97 && ascii <= 122) {
           outputInt = (((ascii - 97) + UInt8(trans)) % 26) + 97
        } else if (ascii >= 65 && ascii <= 90) {
            outputInt = (((ascii - 65) + UInt8(trans)) % 26) + 65
        }
        //65 -> 65 the char value ->  A
        return Character(UnicodeScalar(outputInt))
    }
    return Character("")
}

//Function used within the descramble function
func translateDescramble(l: Character, trans: Int) -> Character {
    if let ascii = l.asciiValue {
        var outputInt = ascii
        if (ascii >= 97 && ascii <= 122) {
            let temp = ascii - UInt8(trans)
            if (temp < 97) {
                outputInt = outputInt + 26
            } else if (temp > 122) {
                outputInt = outputInt - 26
            }
            outputInt = (((outputInt - 97) - UInt8(trans)) % 26) + 97
        } else if (ascii >= 65 && ascii <= 90) {
            let temp = ascii - UInt8(trans)
            if (temp < 65) {
                outputInt = outputInt + 26
            } else if (temp > 90) {
                outputInt = outputInt - 26
            }
            outputInt = (((outputInt - 65) - UInt8(trans)) % 26) + 65
        }
        //65 -> 65 the char value ->  A
        return Character(UnicodeScalar(outputInt))
        
    }
    print(l)
    return Character("")
}

//Encryption function
func scramblePassword(password: String) -> String {
    var scrambled = ""
    let shift = password.count
    
    for letter in password {
        scrambled += String(translateScramble(l: letter, trans: shift))
    }
    return scrambled
}

//Decryption function *** NEEDS TO BE FIGURED OUT !!!!!!!
func descramblePassword(password: String) -> String {
    var unscrambled = ""
    let shift = password.count
    for letter in password {
        unscrambled += String(translateDescramble(l: letter, trans: shift))
    }
    return unscrambled
}



//Function that views all the passwords from the dictionary
func viewAllPasswords (dict: Dictionary<String, String>) -> Void{
    print("All keys currently stored: ")
    for (key, _) in dict {
        print("Key: ", key)
    }
}

//Function that views a single password based
func viewSinglePassword (key1: String, dict: Dictionary<String, String>) -> String {
    var password: String = "Does not exist, go back to main menu"
    if dict.keys.contains(key1) {
        password = dict[key1]!
        let passphrase = Ask.AskQuestion(questionText: "Enter your passphrase: ", acceptableReplies: [String]()) //any response is fine
        let reverse = reverseInput(stringToReverse: password)
        let unscrambled = descramblePassword(password: reverse)
        password = unscrambled
        
        //need to check if passphrase is correct
        let index = password.index(password.startIndex, offsetBy: (password.count - passphrase.count))..<password.endIndex
        let passphraseCheck = password[index]
        if (passphraseCheck != passphrase) {
            password = "Error: passphrase is incorrect"
            return password
        } else {
            print("Password for: ", key1)
            //only should be displaying password and not passphrase
            password = String(password.prefix(password.count - passphrase.count))
            return password
        }
    } else {
        return password
    }
}

//Function that deletes a password
func deleteSinglePassword (key1: String, dict: Dictionary<String, String>) -> Dictionary <String, String> {
    var dict1 = dict
    // Remove item for a key
    if let removedValue = dict1.removeValue(forKey: key1) {
        print("We have just removed '\(key1)' from our dictionary")
    } else {
        print("Could not remove dictionary item (either dictionary is empty or key does not exist")
    }
    return dict1
}

func addSinglePassword (key1: String, dict: Dictionary<String, String>) -> Dictionary <String, String> {
    var dict1 = dict
    let password = Ask.AskQuestion(questionText: "Enter a password that you want to add for this key: ", acceptableReplies: [String]()) //any response is fine
    let passphrase = Ask.AskQuestion(questionText: "Enter your passphrase: ", acceptableReplies: [String]()) //any response is fine
    let together = password + passphrase
    let reverse = reverseInput(stringToReverse: together)
    let scrambled = scramblePassword(password: reverse)
    dict1[key1] = scrambled
    print("Password added successfully!")
    return dict1
}


//Function that reads file and returns a dictionary
func readFile() -> Dictionary <String, String> {
    var passwordDict = Dictionary <String, String>()
    do {
        let fileURL = try FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("mybadpasswords.json")
        let data = try Data(contentsOf: fileURL)
        passwordDict = try JSONSerialization.jsonObject(with: data) as! Dictionary<String, String>
    } catch {
        print(error)
    }
    return passwordDict
}

func writeFile(dict: Dictionary<String, String>) -> Void {
    do {
        let fileURL = try FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("mybadpasswords.json")
        try JSONSerialization.data(withJSONObject: dict)
            .write(to: fileURL)
    } catch {
        print(error)
    }
}

func printMenu() -> Void {
    print("What would you like to do? Enter the Integer of what you want do: ")
    print("1: View all passwords")
    print("2: View a single password")
    print("3: Delete a password")
    print("4: Add a password")
    print("5: Exit the program")
}

func runProgram() {
    var passwordDict = readFile()
    var userExit: Bool = false
    var userInput = ""
    while (userExit == false) {
        printMenu()
        userInput = Ask.AskQuestion(questionText: "What would you like to do from the menu? Enter the integer value", acceptableReplies: ["1","2","3","4","5"])
        if (userInput == "1") {
            print(viewAllPasswords(dict: passwordDict))
        } else if (userInput == "2") {
            viewAllPasswords(dict: passwordDict)
            userInput = Ask.AskQuestion(questionText: "Enter the key for which password you would like to view: ", acceptableReplies: [String]()) //any response is fine
            print(viewSinglePassword(key1: userInput, dict: passwordDict))
        } else if (userInput == "3") {
            viewAllPasswords(dict: passwordDict)
            userInput = Ask.AskQuestion(questionText: "Enter the key for which password you would like to delete: ", acceptableReplies: [String]()) //any response is fine
            passwordDict = deleteSinglePassword(key1: userInput, dict: passwordDict)
        } else if (userInput == "4") {
            userInput = Ask.AskQuestion(questionText: "Create a key for your new password: ", acceptableReplies: [String]()) //any response is fine
            passwordDict = addSinglePassword(key1: userInput, dict: passwordDict)
        } else if (userInput == "5") {
            userExit = true
            writeFile(dict: passwordDict)
            break
        }
    }
}

//MAIN CODE

runProgram()
print("Program done...saving file")
