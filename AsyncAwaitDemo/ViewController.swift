//
//  ViewController.swift
//  AsyncAwaitDemo
//
//  Created by Brian Voong on 4/22/19.
//  Copyright © 2019 Brian Voong. All rights reserved.
//

import UIKit

class Service {

    static let shared = Service() // singleton

    func fetchAuthToken(completion: @escaping (Session.resultsArr) -> ()) {
        do {
            let data = try fetchSomethingAsyncAwait()
            let tokenResponse = try JSONDecoder().decode(Session.responseData.self, from: data!)
            print(tokenResponse.D.Results[0].AuthToken)

            let s = tokenResponse.D.Results[0].AuthToken
            print("Data:", s)
        } catch {
            print("Failed to fetch stuff:", error)
            return
        }
    }
    
    enum NetworkError: Error {
        case url
        case statusCode
        case standard
    }
    struct Constants {
        static let host = "https://sparkapi.com/v1/session?"
        static let sessionParams = ["ApiKey": "vc_c15909466_key_1", "ApiSig" : "a2b8a9251df6e00bf32dd16402beda91"]
        static let headers = ["X-SparkApi-User-Agent": "SparkiOS"]
    }
    
    struct Session: Codable {
        struct responseData: Decodable {
            var D: ResultsData
        }
        struct ResultsData: Decodable {
            var Results: [resultsArr]
        }
        struct resultsArr: Decodable {
            var AuthToken: String
            var Expires: String
        }
    }

    // async await fetch function
    func fetchSomethingAsyncAwait() throws -> Data? {

        let urlString = Constants.host
        let parameters = Constants.sessionParams
        let headers = Constants.headers
        var urlComponents = URLComponents(string: urlString)
        
        var queryItems = [URLQueryItem]()
        for (key, value) in parameters {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        urlComponents?.queryItems = queryItems
        var request = URLRequest(url: (urlComponents?.url)!)
        request.httpMethod = "POST"
        
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }

        print(request)
        var data: Data?
        var response: URLResponse?
        var error: Error?
        
        // Semaphore
        let semaphore = DispatchSemaphore(value: 0)
        
        URLSession.shared.dataTask(with: request) { (d, r, e) in
            data = d
            response = r
            error = e
            
            semaphore.signal()
        }.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        if let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode > 300 {
            throw NetworkError.statusCode
        }
        
        if error != nil {
            throw NetworkError.standard
        }
        
        return data
    }
    // callback hell
    
//    func fetchSomething(completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
//        guard let dummyURL = URL(string: "https://www.google.com") else { return }
//        URLSession.shared.dataTask(with: dummyURL) { (data, res, err) in
//            completion(data, res, err)
//        }.resume()
//    }
}
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    enum NetworkError: Error {
//        case badStatusCode
//        case request
//        case url
//    }
//
//    func fetchSearchAwait() throws -> Data? {
//        guard let url = URL(string: "https://www.google.com") else {
//            throw NetworkError.url
//        }
//
//        var data: Data?
//        var response: URLResponse?
//        var error: Error?
//
//        let semaphore = DispatchSemaphore(value: 0)
//
//        URLSession.shared.dataTask(with: url) { (d, r, e) in
//            data = d
//            response = r
//            error = e
//
//            semaphore.signal()
//
//            }.resume()
//
//        _ = semaphore.wait(timeout: .distantFuture)
//
//        if let resp = response as? HTTPURLResponse, resp.statusCode > 300 {
//            throw NetworkError.badStatusCode
//        }
//
//        if error != nil {
//            throw NetworkError.request
//        }
//
//        return data
//    }
//
//    func fetchSearches(completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
//
//        guard let url = URL(string: "") else { return }
//        URLSession.shared.dataTask(with: url) { (data, res, err) in
//            completion(data, res, err)
//
//        }.resume()
//
//    }
//
//    fileprivate func fetchUsingNestedCallback() {
//        fetchSearches(query: "Taylor Swift") { (res, resp, err) in
//            self.fetchSearches(query: "Maroon 5", completion: { (res, resp, err) in
//                self.fetchSearches(query: "nSync", completion: { (res, resp, err) in
//                    self.fetchSearches(query: "nSync", completion: { (res, resp, err) in
//                        self.fetchSearches(query: "nSync", completion: { (res, resp, err) in
//                            print("Finished search all")
//                        })
//                    })
//                })
//            })
//        }
//    }
//
//    fileprivate func fetchUsingAsyncAwait() {
//        // 1. Search Taylor Swift
//        let taylorSwiftResults = fetchSearchResultsAwait(query: "Taylor Swift")
//        guard let taytayData = taylorSwiftResults.0 else { return }
//        print(String(decoding: taytayData, as: UTF8.self))
//
//        // 2. Maroon 5
//        let maroon5Res = fetchSearchResultsAwait(query: "Maroon 5")
//        guard let maroonData = maroon5Res.0 else { return }
//        print(String(decoding: maroonData, as: UTF8.self))
//
//        // 3. Backstreet Boys
//        let backstreetBoysRes = fetchSearchResultsAwait(query: "backstreet boys")
//        guard let backstreetBoysData = backstreetBoysRes.0 else { return }
//        _ = String(decoding: backstreetBoysData, as: UTF8.self)
//
//    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    func fetchSearches(query: String, completion: @escaping (Data?, URLResponse?, Error?) ->()) {
//        guard let url = URL(string: "https://itunes.apple.com/search?term=\(query)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
//            completion(nil, nil, NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "Bad url"]))
//            return
//        }
//
//        URLSession.shared.dataTask(with: url) {
//            // do you JSON decoding here with JSONDecoder
//            completion($0, $1, $2)
//            }.resume()
//    }
//
//    func fetchSearchResultsAwait(query: String) -> (Data?, URLResponse?, Error?) {
//        guard let url = URL(string: "https://itunes.apple.com/search?term=\(query)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
//            return (nil, nil, NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "Bad url"]))
//        }
//
//        var data: Data?
//        var response: URLResponse?
//        var error: Error?
//
//        let semaphore = DispatchSemaphore(value: 0)
//
//        URLSession.shared.dataTask(with: url) {
//            data = $0
//            response = $1
//            error = $2
//
//            semaphore.signal()
//        }.resume()
//
//        _ = semaphore.wait(timeout: .distantFuture)
//        return (data, response, error)
//    }
//
//
//}

