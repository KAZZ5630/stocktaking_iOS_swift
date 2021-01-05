import XCTest
@testable import Stocktaking

class PlaceSelectModelTest: XCTestCase{
    
    private class WebServiceMock: WebService {
        func getPlaceList(request: GetPlaceListRequest, callback: @escaping (Result<[GetPlaceListResponse], Error>) -> Void) {
            // nothing to do
        }
        
        func getInventoryList(request: GetInventoryRequest, callback: @escaping (Result<[GetInventoryResponse], Error>) -> Void) {
            // nothing to do
        }
        
        func registerInventoryList(request: RegisterInventoryRequest, callback: @escaping (Result<BoolianResponce, Error>) -> Void) {
            // nothing to do
        }
    }
    
    func testSearchButtonTapped() {
        let ws: WebService = WebServiceMock()
        let expected = ShowStockController(id:1, name:"name", vm: ShowStockModel(webService: ws), col: ColorTheme.mainTheme())

        let model = PlaceSelectModel(webService: ws)
        let nextView = model.searchButtonTapped(placeID: 1, placeNM: "name", color: ColorTheme.mainTheme())
        XCTAssertNotNil(nextView)
        if type(of: expected) != type(of: nextView) {
            XCTFail()
        }
    }
    
    func testBackToPreviousView() {
        let expected = AuthorizeController()
        
        let ws: WebService = WebServiceMock()
        let model = PlaceSelectModel(webService: ws)
        let nextView = model.backToPreviousView()
        XCTAssertNotNil(nextView)
        if type(of: expected) != type(of: nextView) {
            XCTFail()
        }
    }
}
