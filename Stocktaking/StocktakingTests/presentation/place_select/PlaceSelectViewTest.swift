import XCTest
@testable import Stocktaking

class PlaceSelectViewTest: XCTestCase {
    
    func testSetListForPicker() {
        let vm = PlaceSelectView(theme: ColorTheme.mainTheme())
        let list: [String] = ["one", "two", "three"]
        vm.setListForPicker(list)
        
        XCTAssertEqual(list, vm.listForPicker)
    }

}
