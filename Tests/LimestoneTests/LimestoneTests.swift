import XCTest
@testable import Limestone

class LimestoneTests: XCTestCase {
    func testExample() {
        let a = "test".foreground(.red)
        XCTAssertEqual(a.text, "test")
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
