import UIKit

protocol ShowStockModelDelegate: class {
    func reloadTable()
    func updateInventoryArray(_ list: InventoryDatasource)
    func alertRegistrationSucceed()
    func alertRegistrationFailed()
    func alertError(_ err: NSError)
}

class ShowStockModel {
    weak var delegate: ShowStockModelDelegate?
    var inventoryArray: [Inventory] = []
    private let webService: WebService
    
    init(webService: WebService) {
        self.webService = webService
    }
    
    func loadTable() {
        print("ShowStockModel.loadTable()")
        self.delegate?.reloadTable()
    }
    
    //MARK:- button action
    func editActualStockAndReload(row: Int, actual: Float) {
        self.inventoryArray[row].actual = actual
        self.delegate?.reloadTable()
    }
    
    func onRegisterButtonTapped(placeId: Int) {
        self.registerInventoryList(place: placeId)
    }
    
    func onRefreshButtonTapped(list: InventoryDatasource, id: Int) {
        self.getInventoryList(inventoryList: list, place: id)
    }
    
    func setInventoryArray(_ list: [Inventory]) {
        self.inventoryArray = list
    }

    func backButtonTapped() -> PlaceSelectController {
        print("backbutton tapped")
        let nextView = PlaceSelectController()
        return nextView
    }
}

// MARK:- web API
extension ShowStockModel {
    func getInventoryList(inventoryList: InventoryDatasource, place:Int) {
        print("ShowStockModel.getInventoryList(placeID: \(place))")
        
        webService.getInventoryList(
            request: GetInventoryRequest(placeID: place),
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
                        inventoryList.append(
                            shId: content.shId,
                            shNm: content.shNm,
                            logical: content.logical,
                            actual: content.actual
                        )
                    }
                    print("inventoryList: \(inventoryList.shNms.description)")
                    self.delegate?.updateInventoryArray(inventoryList)
                }
            }
        )
    }
    
    func registerInventoryList(place:Int) {
        var inventoryList = RegisterInventoryRequest(list: [])
        for item in inventoryArray {
            print("place: \(place), shNm: \(item.productID), amount: \(item.actual)")
            let itemRegist = ItemToRegist(
                placeId: place,
                shId: item.productID,
                amount: item.actual
            )
            inventoryList.list.append(itemRegist)
        }
        
        webService.registerInventoryList(
            request: inventoryList,
            callback: { result in
                switch result {
                case .failure(let error):
                    print("result failed: \(error)")
                    self.delegate?.alertRegistrationFailed()

                case .success(var list):
                    do { list = try result.get() }
                    catch (let err) { print(err); return; }
                    if list.result {
                        self.delegate?.alertRegistrationSucceed()
                    } else {
                        self.delegate?.alertRegistrationFailed()
                    }
                }
            }
        )
    }
}
