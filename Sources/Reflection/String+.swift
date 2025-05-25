//
//  String+.swift
//
//
//  Created by p-x9 on 2024/03/15.
//
//

import Foundation

extension String {
    func tabbed(_ width: Int = 4) -> String {
        components(separatedBy: .newlines)
            .map { String(repeating: " ", count: width) + $0 }
            .joined(separator: "\n")
    }
}

extension String {
    package var strippedSwiftModulePrefix: String {
        var string = self
        if string.starts(with: "Swift.") {
            string = String(string.dropFirst(6))
        }
        return string
            .replacingOccurrences(of: "<Swift.", with: "<")
            .replacingOccurrences(of: "(Swift.", with: "(")
            .replacingOccurrences(of: ", Swift.", with: ", ")
    }
}

extension String {
    package var replacedToOptionalSyntaxSugar: String {
        guard let range = range(of: "Optional<") else { return self }
        let prefix = self[startIndex ..< range.lowerBound]
        let trailing = String(self[index(before: range.upperBound)...])

        guard let closingIndex = trailing.indexForMatchingBracket(open: "<", close: ">") else {
            return self
        }

        let startInex = trailing.index(trailing.startIndex, offsetBy: 1)
        let endIndex = trailing.index(trailing.startIndex, offsetBy: closingIndex)
        let content = String(trailing[startInex ..< endIndex]) // <content>
            .replacedToOptionalSyntaxSugar
            .trimmedLeadingAndTrailingWhitespaces

        let suffix = String(trailing[trailing.index(after: endIndex)...])
            .replacedToOptionalSyntaxSugar
            .trimmedLeadingAndTrailingWhitespaces

        return prefix + content + "?" + suffix
    }

    package var replacedToArraySyntaxSugar: String {
        guard let range = range(of: "Array<") else { return self }
        let prefix = self[startIndex ..< range.lowerBound]
        let trailing = String(self[index(before: range.upperBound)...])

        guard let closingIndex = trailing.indexForMatchingBracket(open: "<", close: ">") else {
            return self
        }

        let startInex = trailing.index(trailing.startIndex, offsetBy: 1)
        let endIndex = trailing.index(trailing.startIndex, offsetBy: closingIndex)
        let content = String(trailing[startInex ..< endIndex]) // <content>
            .replacedToArraySyntaxSugar
            .trimmedLeadingAndTrailingWhitespaces

        let suffix = String(trailing[trailing.index(after: endIndex)...])
            .replacedToArraySyntaxSugar
            .trimmedLeadingAndTrailingWhitespaces

        return prefix + "[" + content + "]" + suffix
    }

    package var replacedToDictionarySyntaxSugar: String {
        guard let range = range(of: "Dictionary<") else { return self }
        let prefix = self[startIndex ..< range.lowerBound]
        let trailing = String(self[index(before: range.upperBound)...])

        guard let closingIndex = trailing.indexForMatchingBracket(open: "<", close: ">") else {
            return self
        }

        let startInex = trailing.index(trailing.startIndex, offsetBy: 1)
        let endIndex = trailing.index(trailing.startIndex, offsetBy: closingIndex)
        let content = String(trailing[startInex ..< endIndex]) // <content>

        let keyAndValue = content.contents(
            separatedBy: ",",
            openings: ["(", "<", "["],
            closings: [")", ">", "]"]
        )
        guard keyAndValue.count == 2 else { return self }
        let key = keyAndValue[0]
            .replacedToDictionarySyntaxSugar
            .trimmedLeadingAndTrailingWhitespaces
        let value = keyAndValue[1]
            .replacedToDictionarySyntaxSugar
            .trimmedLeadingAndTrailingWhitespaces

        let suffix = String(trailing[trailing.index(after: endIndex)...])
            .replacedToDictionarySyntaxSugar
            .trimmedLeadingAndTrailingWhitespaces

        return prefix + "[" + key + ": " + value + "]" + suffix
    }
}

extension String {
    /// Finds the index of the closing bracket that matches the first encountered opening bracket.
    ///
    /// This method iterates through the characters of the string and tracks the depth of nested brackets.
    /// When the depth returns to zero, the matching closing bracket for the first opening bracket is found.
    ///
    /// - Parameters:
    ///   - open: The character representing the opening bracket (e.g., `<`, `(`, `[`)
    ///   - close: The character representing the closing bracket (e.g., `>`, `)`, `]`)
    /// - Returns: The index (0-based) of the matching closing bracket within the string, or `nil` if unmatched.
    /// - Complexity: O(n), where n is the length of the string.
    func indexForMatchingBracket(
        open: Character,
        close: Character
    ) -> Int? {
        var depth = 0
        for (index, char) in enumerated() {
            depth += (char == open) ? 1 : (char == close) ? -1 : 0
            if depth == 0 {
                return index
            }
        }
        return nil
    }
}

extension String {
    /// Splits the string by a separator character while ignoring separators inside nested delimiters.
    ///
    /// This method is useful for parsing comma-separated types or parameters where nested brackets may exist.
    ///
    /// - Parameters:
    ///   - separator: The character used to split the string (e.g., `,`)
    ///   - openings: A list of characters considered as opening delimiters (e.g., `(`, `<`, `[`)
    ///   - closings: A list of characters considered as closing delimiters (e.g., `)`, `>`, `]`)
    /// - Returns: An array of substrings split on the separator, ignoring separators inside nested delimiters.
    func contents(
        separatedBy separator: Character,
        openings: [Character] = [],
        closings: [Character] = []
    ) -> [String] {
        var result: [String] = []
        var depth = 0
        var entry: [Character] = []

        for (_, char) in enumerated() {
            depth += (openings.contains(char)) ? 1 : (closings.contains(char)) ? -1 : 0
            if depth == 0 && char == separator {
                result.append(String(entry))
                entry = []
            } else {
                entry.append(char)
            }
        }
        return result + [String(entry)]
    }
}

extension String {
    /// Trims leading and trailing whitespaces from the string.
    ///
    /// This method uses a regular expression to remove spaces from both the beginning and end of the string.
    /// It does not affect whitespaces within the string body.
    ///
    /// - Returns: A new string with surrounding whitespaces removed.
    var trimmedLeadingAndTrailingWhitespaces: String {
        let pattern = #"^\s+|\s+$"#
        if let regex = try? NSRegularExpression(pattern: pattern) {
            let range = NSRange(location: 0, length: utf16.count)
            let trimmed = regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "")
            return trimmed
        }
        return self
        /* replacing(/^\s+|\s+$/, with: "") */
    }
}
