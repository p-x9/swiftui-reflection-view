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
}
