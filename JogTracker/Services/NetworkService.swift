//
//  NetworkService.swift
//  JogTracker
//
//  Created by Prostor9 on 10/30/19.
//  Copyright © 2019 me. All rights reserved.
//

import Foundation
import RxSwift

fileprivate struct APIConstants {
    static let baseURL = "https://jogtracker.herokuapp.com/api/v1"
    
    static let auth = baseURL + "/auth/uuidLogin"
    static let jogsList = baseURL + "/data/sync"
    static let jog = baseURL + "/data/jog"
    
}

enum NetworkError: Error {
    case requestDataPreparing
    case clientError(Error?)
    case serverError
    case dataError
}

class NetworkService {
    enum SendMethod: String {
        case add = "POST"
        case update = "PUT"
    }
    
    static let shared = NetworkService()
    
    private var token: String?
    
    func logIn(completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        let parameters = ["uuid": "hello"]
        
        guard let url = URL(string: APIConstants.auth),
            let parametersData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
            else { completion(.failure(.requestDataPreparing)); return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = parametersData
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(.failure(.clientError(error)))
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                completion(.failure(.serverError))
                return
            }
            
            guard let data = data, let token = Parser.parseToken(data) else {
                completion(.failure(.dataError))
                return
            }
            print("Token got successfully! Token:", token)
            self.token = token
            completion(.success(true))
            
        }.resume()
    }
    
    func getJogs(completion: @escaping (Result<[Jog], NetworkError>) -> Void) {
        guard let token = token,
            let url = URL(string: APIConstants.jogsList + "?access_token=" + token)
            else { completion(.failure(.requestDataPreparing)); return }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(.failure(.clientError(error)))
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                completion(.failure(.serverError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.dataError))
                return
            }
            
            guard let jogs = Parser.parseJogs(data) else {
                completion(.failure(.dataError))
                return
            }
            
            completion(.success(jogs))
            
        }.resume()
    }
    
    func rxGetJog() -> Single<[Jog]> {
        guard let token = self.token,
            let url = URL(string: APIConstants.jogsList + "?access_token=" + token)
            else { return Single.error(NetworkError.requestDataPreparing) }
        
        return Single.create { single in
            let request = URLRequest(url: url)
            
            let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    single(.error(NetworkError.clientError(error)))
                    return
                }
                
                guard let data = data, let jogs = Parser.parseJogs(data) else {
                    single(.error(NetworkError.dataError))
                    return
                }
                
                single(.success(jogs))
            }
            dataTask.resume()
            
            return Disposables.create {
                dataTask.cancel()
            }
        }
    }

    func sendJog(jog: Jog, sendMethod: SendMethod, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        guard let token = token,
            let url = URL(string: APIConstants.jog + "?access_token=" + token)
            else { completion(.failure(.requestDataPreparing)); return }
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try! encoder.encode(jog)

        var request = URLRequest(url: url)
        request.httpMethod = sendMethod.rawValue
        request.httpBody = data
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(.failure(.clientError(error)))
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                completion(.failure(.serverError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.dataError))
                return
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                print(json)
            }
            
            completion(.success(true))
            
        }.resume()
    }
}
