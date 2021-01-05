import XCTest
@testable import Stocktaking

class AuthorizeModelTest: XCTestCase {
    
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
    
    func testEnterButtonTapped_WhenButtonTapped() {
        let expected = PlaceSelectController()
        
        let ws: WebService = WebServiceMock()
        let model = AuthorizeModel(webService: ws)
        let nextView = model.enterButtonTapped()
        XCTAssertNotNil(nextView)
        if type(of: expected) != type(of: nextView) {
            XCTFail()
        }
    }

}
