import Foundation

protocol PlaceSelectModelDelegate: class {
    func reloadPlaceList(_ placeList: PlaceSelectDataSource)
    func alertError(_ err: NSError)
}

class PlaceSelectModel {
    weak var delegate: PlaceSelectModelDelegate?
    private let webService: WebService
    
    init(webService: WebService) {
        self.webService = webService
    }
    
    //MARK:- nutton action
    func searchButtonTapped(placeID: Int, placeNM: String, color: ColorTheme) -> ShowStockController {
        print("\(placeID): \(placeNM)")
        let nextViewModel = ShowStockModel(webService: WebServiceImp())
        let nextColorTheme = color
        let nextView = ShowStockController(id:placeID, name:placeNM, vm: nextViewModel, col: nextColorTheme)
        return nextView
    }
    
    func backToPreviousView() -> AuthorizeController {
        let nextViewController = AuthorizeController()
        return nextViewController
    }
}

// MARK:- web API
extension PlaceSelectModel {
    func getPlaceList(placeList: PlaceSelectDataSource) {
        placeList.append(id: -1, item: "")
        
        webService.getPlaceList(
            request: GetPlaceListRequest(),
            callback: { result in
                switch result {
                case .failure(let error):
                    guard let err = error as NSError? else {
                        print("evaluate failed: \(error.localizedDescription)")
                        self.delegate?.alertError(NSError(domain: "unknown", code: 9999, userInfo: nil))
                        return
                    }
                    self.delegate?.alertError(err)
                case .success(var list):
                    do { list = try result.get() }
                    catch (let err) { print(err); return; }
                    
                    for content in list {
                        placeList.append(id: content.id, item: content.name)
                    }
                    print("placeList: \(placeList.items.description)\n")
                    self.delegate?.reloadPlaceList(placeList)
                }
            }
        )
    }
}
