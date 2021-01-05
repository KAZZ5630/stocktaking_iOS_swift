import Foundation

struct BoolianResponce: Decodable {
    var result: Bool
}

struct GetInventoryRequest {
    var placeID: Int
}

struct GetInventoryResponse: Decodable {
    var shId: Int
    var shNm: String
    var logical: Float
    var actual: Float
}

struct ItemToRegist: Codable {
    var placeId: Int
    var shId: Int
    var amount: Float
}

struct RegisterInventoryRequest: Codable {
    var list: [ItemToRegist]
}
