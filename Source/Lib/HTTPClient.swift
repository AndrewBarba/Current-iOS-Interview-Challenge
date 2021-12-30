//
//  HttpClient.swift
//  Fast Foodz (iOS)
//
//  Created by Andrew Barba on 12/27/21.
//

import Foundation

public typealias HTTPHeaders = [String: String]

public typealias HTTPSearchParams = [String: String]

public typealias HTTPBodyParams = [String: Any]

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    case options = "OPTIONS"
}

public enum HTTPRequestError: Error {
    case invalidURL
}

public class HTTPClient {

    let host: String

    let headers: HTTPHeaders

    let timeout: TimeInterval

    let jsonDecoder: JSONDecoder

    let jsonEncoder: JSONEncoder

    init(host: String, headers: HTTPHeaders = [:], timeout: TimeInterval = 20, jsonDecoder: JSONDecoder? = nil, jsonEncoder: JSONEncoder? = nil) {
        self.host = host
        self.headers = headers
        self.timeout = timeout
        self.jsonDecoder = jsonDecoder ?? JSONDecoder()
        self.jsonEncoder = jsonEncoder ?? JSONEncoder()
    }

    public func get<T>(_ urlPath: String, searchParams: HTTPSearchParams? = nil) async throws -> T where T: Decodable {
        return try await request(.get, urlPath: urlPath, searchParams: searchParams)
    }

    public func delete<T>(_ urlPath: String, searchParams: HTTPSearchParams? = nil) async throws -> T where T: Decodable {
        return try await request(.delete, urlPath: urlPath, searchParams: searchParams)
    }

    public func post<T, V>(_ urlPath: String, searchParams: HTTPSearchParams? = nil, body: V) async throws -> T where T: Decodable, V: Encodable {
        return try await request(.post, urlPath: urlPath, searchParams: searchParams, body: body)
    }

    public func put<T, V>(_ urlPath: String, searchParams: HTTPSearchParams? = nil, body: V) async throws -> T where T: Decodable, V: Encodable {
        return try await request(.put, urlPath: urlPath, searchParams: searchParams, body: body)
    }

    public func patch<T, V>(_ urlPath: String, searchParams: HTTPSearchParams? = nil, body: V) async throws -> T where T: Decodable, V: Encodable {
        return try await request(.patch, urlPath: urlPath, searchParams: searchParams, body: body)
    }

    public func request<T>(_ method: HTTPMethod, urlPath: String, searchParams: HTTPSearchParams? = nil) async throws -> T where T: Decodable {
        return try await request(method, urlPath: urlPath, searchParams: searchParams, httpBody: nil)
    }

    public func request<T, V>(_ method: HTTPMethod, urlPath: String, searchParams: HTTPSearchParams? = nil, body: V) async throws -> T where T: Decodable, V: Encodable {
        let data = try self.jsonEncoder.encode(body)
        return try await request(method, urlPath: urlPath, searchParams: searchParams, httpBody: data)
    }

    private func request<T>(_ method: HTTPMethod, urlPath: String, searchParams: HTTPSearchParams? = nil, httpBody: Data? = nil) async throws -> T where T: Decodable {
        var components = URLComponents(string: "\(self.host)/\(urlPath)")
        components?.queryItems = searchParams?.compactMapValues { $0 }.map(URLQueryItem.init)

        guard let url = components?.url else {
            throw HTTPRequestError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("fast-foodz/1.0", forHTTPHeaderField: "User-Agent")
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        request.httpBody = httpBody
        request.timeoutInterval = self.timeout

        let (data, _) = try await URLSession.shared.data(for: request)

        return try self.jsonDecoder.decode(T.self, from: data)
    }
}
