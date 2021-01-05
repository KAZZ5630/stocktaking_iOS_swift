import Foundation

class PlaceSelectDataSource {
    var ids: [Int] = []
    var items: [String] = []
    
    func append(id:Int, item: String) {
        ids.append(id)
        items.append(item)
    }
    
}
