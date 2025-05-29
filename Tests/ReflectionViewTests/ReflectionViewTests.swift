import XCTest
@testable import Reflection
@testable import ReflectionView

import SwiftUI

final class ReflectionViewTests: XCTestCase {
    func testParse() {
        let text = Text("hello")
        let reflection = Reflection(text)
        print(reflection.structured)
    }

    func testReplacedToOptionalSyntaxSugar_Single() {
        XCTAssertEqual("Optional<Int>".replacedToOptionalSyntaxSugar, "Int?")
        XCTAssertEqual("Optional<Optional<Int>>".replacedToOptionalSyntaxSugar, "Int??")
        XCTAssertEqual("Optional<Array<Int>>".replacedToOptionalSyntaxSugar, "Array<Int>?")
    }

    func testReplacedToArraySyntaxSugar_Single() {
        XCTAssertEqual("Array<Int>".replacedToArraySyntaxSugar, "[Int]")
        XCTAssertEqual("Array<Array<Int>>".replacedToArraySyntaxSugar, "[[Int]]")
        XCTAssertEqual("Array<Optional<Int>>".replacedToArraySyntaxSugar, "[Optional<Int>]")
    }

    func testReplacedToDictionarySyntaxSugar_Single() {
        XCTAssertEqual("Dictionary<String, Int>".replacedToDictionarySyntaxSugar, "[String: Int]")
        XCTAssertEqual("Dictionary<String, Dictionary<String, Int>>".replacedToDictionarySyntaxSugar, "[String: [String: Int]]")
        XCTAssertEqual("Dictionary<String, Optional<Int>>".replacedToDictionarySyntaxSugar, "[String: Optional<Int>]")
    }

    func testReplacedToCommonSyntaxSugar_Combined() {
        let case1 = "Optional<Array<Dictionary<String, Int>>>"
        XCTAssertEqual(case1.replacedToCommonSyntaxSugar, "[[String: Int]]?")

        let case2 = "Array<Optional<Dictionary<String, Optional<Int>>>>"
        XCTAssertEqual(case2.replacedToCommonSyntaxSugar, "[[String: Int?]?]")

        let case3 = "Optional<Dictionary<Optional<String>, Optional<Array<Optional<Int>>>>>"
        XCTAssertEqual(case3.replacedToCommonSyntaxSugar, "[String?: [Int?]?]?")

        let case4 = "Optional<Array<Dictionary<String, Dictionary<String, Optional<Int>>>>>"
        XCTAssertEqual(case4.replacedToCommonSyntaxSugar, "[[String: [String: Int?]]]?")
    }
}
