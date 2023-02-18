import Foundation

public protocol NetworkService {
    func request<Request: DataRequest>(_ request: Request,
                                       completion: @escaping (Result<Request.Response, Error>)
                                       -> Void)
}

public class NetworkManager: NetworkService {
    public init() {}
    public func request<Request: DataRequest>(_ request: Request,
                                       completion: @escaping (Result<Request.Response, Error>)
                                       -> Void) {
        guard var urlComponent = URLComponents(string: request.url)
        else {
            let error = NSError(
                domain: "URL not available",
                code: 404,
                userInfo: nil
            )
            return completion(.failure(error))
        }
        
        if !request.queryItems.isEmpty {
            var queryItems: [URLQueryItem] = []
            request.queryItems.forEach {
                let urlQueryItem = URLQueryItem(name: $0.key, value: $0.value)
                urlComponent.queryItems?.append(urlQueryItem)
                queryItems.append(urlQueryItem)
            }
            urlComponent.queryItems = queryItems
        }
        
        //Force Wrapping it as in line 9 checking the URL if url will be faulty URL component will be nil which will eventually return error
        var urlRequest = URLRequest(url: urlComponent.url!)
        urlRequest.httpMethod = request.method.rawValue
        if !request.headers.isEmpty {
            urlRequest.allHTTPHeaderFields = request.headers
        }
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                return completion(.failure(error))
            }
            
            guard let response = response as? HTTPURLResponse, 200..<300 ~= response.statusCode else {
                return completion(.failure(NSError()))
            }
            
            guard let data = data else {
                return completion(.failure(NSError()))
            }
            
            do {
                try completion(.success(request.decode(data)))
            } catch let error as NSError {
                completion(.failure(error))
            }
            
        }
        .resume()
    }
}
