//
//  RestManager.swift
//  OPUSDReminder
//
//  Created by Adib Aayan on 12/29/21.
//

import Foundation

/// Lightweight class to perform a RESTful web request.
class RestManager {
    
    // MARK: - Properties
    
    var requestHttpHeaders = RestEntity()
    var urlQueryParameters = RestEntity()
    var httpBodyParameters = RestEntity()
    var httpBody: Data?
    
    
    // MARK: - Public Methods
    
    /// Makes a web request to the given URL with the provifded HTTP method type.
    ///
    /// Ensure the following properties are set (if needed) prior to calling this method.
    /// - `requestHttpHeaders`
    /// - `urlQueryParameters`
    /// - `httpBodyParameters`
    /// - `httpBody`
    func makeRequest(toURL url: URL,
                     withHttpMethod httpMethod: HttpMethod,
                     completion: @escaping (_ result: Results) -> Void) {
        
//        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//            guard let self = self else { print("No self."); return }
            let targetURL = self.addURLQueryParameters(toURL: url)
            let httpBody = self.getHttpBody()
            
            guard let request: URLRequest = self.prepareRequest(withURL: targetURL, httpBody: httpBody, httpMethod: httpMethod) else
            {
                print("Hmmm")
                completion(Results(withError: CustomError.failedToCreateRequest))
                return
            }
            
            let sessionConfiguration = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfiguration)
            let task = session.dataTask(with: request) { (data, response, error) in
                completion(Results(withData: data,
                                   response: Response(fromURLResponse: response),
                                   error: error))
            }
            task.resume()
//        }
    }
    
    /// Fetches data from a URL.
    ///
    /// This method is handy for fetching complimentary data after an initial request has been made (such as retrieving an image after obtaining an initial response containing a URL to an image hosted online).
    func getData(fromURL url: URL, completion: @escaping (_ data: Data?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let sessionConfiguration = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfiguration)
            let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
                guard let data = data else { completion(nil); return }
                completion(data)
            })
            task.resume()
        }
    }
    
    // MARK: - Private Methods
    
    /// Adds any predetermined URL query parameters to the given URL, then returns the updated URL.
    private func addURLQueryParameters(toURL url: URL) -> URL {
        if urlQueryParameters.totalItems() > 0 {
            guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return url }
            var queryItems = [URLQueryItem]()
            for (key, value) in urlQueryParameters.allValues() {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
            
            urlComponents.queryItems = queryItems
            
            guard let updatedURL = urlComponents.url else { return url }
            return updatedURL
        }
        
        return url
    }
    
    /// Generates and returns the data for the HTTP body based on the values specified in the `httpBodyParameters` property, or the `httpBody` property if the prior is empty.
    private func getHttpBody() -> Data? {
        guard let contentType = requestHttpHeaders.value(forKey: "Content-Type") else { return nil }
        
        if contentType.contains("application/json") {
            return try? JSONSerialization.data(withJSONObject: httpBodyParameters.allValues(), options: [.prettyPrinted, .sortedKeys])
        }
        else if contentType.contains("application/x-www-form-urlencoded") {
            let bodyString = httpBodyParameters.allValues().map { "\($0)=\(String(describing: $1.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)))" }.joined(separator: "&") // E.g. "firstname=John&age=40"
            return bodyString.data(using: .utf8)
        }
        else {
            return httpBody
        }
    }
    
    /// Creates and returns a `URLRequest` object for the provided URL (parameters included), configured with the provided HTTP body and HTTP method type.
    private func prepareRequest(withURL url: URL?, httpBody: Data?, httpMethod: HttpMethod) -> URLRequest? {
        guard let url = url else {
            print("URL nil.")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        
        for (header, value) in requestHttpHeaders.allValues() {
            request.setValue(value, forHTTPHeaderField: header)
        }
        
        request.httpBody = httpBody
        return request
    }
}

// MARK: - RestManager Custom Types

extension RestManager {
    
    /// A type of HTTP method that can be performed in a web request.
    enum HttpMethod: String {
        case get
        case post
        case put
        case patch
        case delete
    }
    
    /// A structure to represent any REST entity that is made up of key-value pairs (such as HTTP request headers or URL query parameters).
    struct RestEntity {
        private var values: [String: String] = [:]
        
        /// Sets the property of the receiver specified by a given key to a given value.
        mutating func add(value: String, forKey key: String) {
            values[key] = value
        }
        
        /// Returns the value for the property identified by a given key.
        func value(forKey key: String) -> String? {
            return values[key]
        }
        
        /// Returns all property values.
        func allValues() -> [String: String] {
            return values
        }
        
        /// Returns the total quantity of values.
        func totalItems() -> Int {
            return values.count
        }
    }
    
    /// Represents an HTTP response, which is a message sent by a server to a client as an answer to a HTTP request that was made by that client.
    ///
    /// A response may include the following three different kind of data:
    /// - A numeric status (HTTP status code) indicating the outcome of the request. This is always returned by the server.
    /// - HTTP headers. They can optionally exist in the response.
    /// - Response body, which is the actual data a server sends back to the client app.
    ///
    /// - Note: The response data is not stored in this object, but should be handled separately.
    struct Response {
        var response: URLResponse?
        /// Represents the outcome of the request.
        var httpStatusCode: Int = 0
        var headers = RestEntity()
        
        init(fromURLResponse response: URLResponse?) {
            guard let response = response else { return }
            self.response = response
            httpStatusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
            
            if let headerFields = (response as? HTTPURLResponse)?.allHeaderFields {
                for (key, value) in headerFields {
                    headers.add(value: "\(value)", forKey: "\(key)")
                }
            }
        }
    }
    
    /// Represents the returned results of a web request.
    ///
    /// This object holds the fetched data, or an error if there is one. It also holds the `Response` object.
    struct Results {
        var data: Data?
        var response: Response?
        var error: Error?
        
        init(withData data: Data?, response: Response?, error: Error?) {
            self.data = data
            self.response = response
            self.error = error
        }
        
        init(withError error: Error) {
            self.error = error
        }
    }
    
    enum CustomError: Error {
        case failedToCreateRequest
    }
}

// MARK: - Custom Error Description

extension RestManager.CustomError: LocalizedError {
    public var localizedDescription: String {
        switch self {
        case .failedToCreateRequest: return NSLocalizedString("Unable to create the URLRequest object", comment: "")
        }
    }
}
