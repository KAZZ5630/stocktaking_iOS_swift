import Foundation

class AuthorizeModel {
    private let webService: WebService
    
    init(webService: WebService) {
        self.webService = webService
    }
    
    func enterButtonTapped() -> PlaceSelectController {
        print("AuthorizeModel.enterButtonTapped()")
        let nextViewController = PlaceSelectController()
        return nextViewController
    }
    
}
