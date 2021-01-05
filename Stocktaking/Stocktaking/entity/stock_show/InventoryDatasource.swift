import Foundation

class InventoryDatasource {
    var shIds: [Int] = []
    var shNms: [String] = []
    var logicals: [Float] = []
    var actuals: [Float] = []
    
    func append(shId: Int, shNm: String, logical: Float, actual: Float) {
        shIds.append(shId)
        shNms.append(shNm)
        logicals.append(logical)
        actuals.append(actual)
    }
    
    func removeAll() {
        shIds.removeAll()
        shNms.removeAll()
        logicals.removeAll()
        actuals.removeAll()
    }
}
