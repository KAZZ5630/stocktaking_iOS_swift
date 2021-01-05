import Foundation

protocol WebService {
    func getPlaceList(
        request: GetPlaceListRequest,
        callback: @escaping (Result<[GetPlaceListResponse], Error>) -> Void
    )
    
    func getInventoryList(
        request: GetInventoryRequest,
        callback: @escaping (Result<[GetInventoryResponse], Error>) -> Void
    )
    
    func registerInventoryList(
        request: RegisterInventoryRequest,
        callback: @escaping (Result<BoolianResponce, Error>) -> Void
    )
}

final class WebServiceImp {
    
    let domain: String = "http://127.0.0.1:8080"
    let timeout = 10
    
    private lazy var session: URLSession = {
        let session = URLSession(configuration: .default)
        return session
    }()
    
    private static let unknownError = {
        return NSError(
            domain: NSURLErrorDomain,
            code: -1,
            userInfo: nil
        )
    }()
    
    private static let decoder = JSONDecoder()
    
    private func request<T: Decodable>(
        request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        session.dataTask(
            with: request,
            completionHandler: { (data, response, error) in
                func sendError() {
                    if let error = error {
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(.failure(WebServiceImp.unknownError))
                        }
                    }
                }
                
                guard let response = response as? HTTPURLResponse else {
                    sendError()
                    return
                }
                
                switch response.statusCode {
                case 200...299:
                    guard let data = data else {
                        sendError()
                        return
                    }
                    let result = Result<T, Error>(
                        catching: {
                            try WebServiceImp.decoder.decode(T.self, from: data)
                        }
                    )
                    DispatchQueue.main.async {
                        completion(result)
                    }
                default:
                    sendError()
                }
            }
        ).resume()
    }
}

extension WebServiceImp: WebService {
    
    func getPlaceList(
        request: GetPlaceListRequest,
        callback: @escaping (Result<[GetPlaceListResponse], Error>) -> Void
    ) {
        guard let url: URL = URL(string: "\(domain)/place") else { return }
        var urlReq = URLRequest(url: url)
        urlReq.timeoutInterval = TimeInterval(timeout)
        self.request(request: urlReq, completion: callback)
    }
    
    func getInventoryList(
        request: GetInventoryRequest,
        callback: @escaping (Result<[GetInventoryResponse], Error>) -> Void
    ) {
        print("WebService.getInventoryList()")
        guard let url: URL = URL(string: "\(domain)/inventory/list") else { return }
        var urlReq = URLRequest(url: url)
        urlReq.timeoutInterval = TimeInterval(timeout)
        urlReq.httpMethod = "POST"
        urlReq.httpBody = "id=\(request.placeID)".data(using: .utf8)
        self.request(request: urlReq, completion: callback)
    }
    
    func registerInventoryList(
        request: RegisterInventoryRequest,
        callback: @escaping (Result<BoolianResponce, Error>) -> Void
    ) {
        print("WebService.getInventoryList()")
        guard let url: URL = URL(string: "\(domain)/inventory/list") else { return }
        var urlReq = URLRequest(url: url)
        urlReq.timeoutInterval = TimeInterval(timeout)
        urlReq.httpMethod = "PATCH"

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        var jsonReq: Data

        do{ jsonReq = try encoder.encode(request.list) }
        catch (let err) { print(err); return; }
        
        print(String(data: jsonReq, encoding: .utf8)!)
        
        urlReq.httpBody = jsonReq
        self.request(request: urlReq, completion: callback)
    }
}

