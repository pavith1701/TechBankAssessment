//
//  APIService.swift
//  TestBank
//
//  Created by Pavithran P K on 27/11/25.
//

import Foundation
import Alamofire

class APIService {
    
    static let shared = APIService()
    
    private init() {}
    
    private let baseURL = "https://nodeapi.techbank.live/interview"
    func getRequest<T:Decodable>(path:String,
                                 params:[String:Any]? = nil,
                                 complectionHandler:@escaping(Result<T,Error>)->Void) {
        let url = "\(baseURL)\(path)"
        let header : HTTPHeaders = [
            "x-api-key": "user-key",
            "Content-Type": "application/json"
        ]
        showLoader()
        AF.request(url,method:.get,parameters: params,headers: header).validate().responseDecodable(of: T.self) { result in
            self.hideLoader()
            switch result.result {
            case .success(let decoded):
                complectionHandler(.success(decoded))
            case.failure(let error):
                complectionHandler(.failure(error))
            }
            
        }
        
    }
    
    func postRequest<T: Decodable>(
        path: String,
        body: [String: Any],
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        let url = "\(baseURL)\(path)"
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "x-api-key": "user-key"
        ]
        showLoader()
        AF.request(
            url,
            method: .post,
            parameters: body,
            encoding: JSONEncoding.default,
            headers: headers
        )
        .validate(statusCode: 200..<300)
        .responseDecodable(of: T.self) { response in
            self.hideLoader()
            switch response.result {
                
            case .success(let decodedData):
                completion(.success(decodedData))
                
            case .failure(let afError):
                
                if let statusCode = response.response?.statusCode,
                       let data = response.data,
                       let serverError = try? JSONDecoder().decode(ServerError.self, from: data) {

                        let customError = NSError(
                            domain: "",
                            code: statusCode,
                            userInfo: [NSLocalizedDescriptionKey: serverError.error]
                        )
                    completion(.failure(customError))
                        return
                    }
            }
        }
    }


    func uploadNFT<T: Decodable>(
        path: String,
        image: UIImage,
        title: String,
        description: String,
        sellingPrice: String,
        complectionHandler: @escaping (Result<T, Error>) -> Void
    ) {
        let urlString = "\(baseURL)\(path)"

        let boundary = "Boundary-\(UUID().uuidString)"

        let header: HTTPHeaders = [
            "x-api-key": "user-key",
            "Content-Type": "multipart/form-data; boundary=\(boundary)"
        ]

        guard let url = URL(string: urlString) else {
            print("Invalid URL:", urlString)
            return
        }

        var body = Data()
        if let imgData = image.jpegData(compressionQuality: 0.8) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"Nft_image\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imgData)
            body.append("\r\n".data(using: .utf8)!)
        }

        let fields: [String: String] = [
            "title": title,
            "description": description,
            "selling_price": sellingPrice,
            "userid": "user-001",
            "email": "jane.cooper@example.com"
        ]

        for (key, value) in fields {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        let bodyData = body

        showLoader()
        AF.request(
            url,
            method: .post,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: header
        ) { urlRequest in
            urlRequest.httpBody = bodyData
        }
        .validate()
        .responseDecodable(of: T.self) { result in
            
            self.hideLoader()

            switch result.result {

            case .success(let decoded):
                complectionHandler(.success(decoded))

            case .failure(let error):
                if let statusCode = result.response?.statusCode,
                   let data = result.data,
                   let serverError = try? JSONDecoder().decode(ServerError.self, from: data)
                {
                    let customError = NSError(
                        domain: "",
                        code: statusCode,
                        userInfo: [NSLocalizedDescriptionKey: serverError.error]
                    )
                    complectionHandler(.failure(customError))
                    return
                }


                complectionHandler(.failure(error))
            }
        }
    }

    
    func showLoader() { Loader.show() }
    func hideLoader() { Loader.hide() }
}

