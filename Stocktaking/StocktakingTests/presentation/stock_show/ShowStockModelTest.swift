import XCTest
@testable import Stocktaking

class ShowStockModelTest: XCTestCase{
    
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
    
    func testBackButtonTapped() {
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
