//
//  DynamicDataTests.swift
//  DynamicDataTests
//
//  Created by 김동우 on 2022/12/11.
//

import Foundation
import XCTest
import DynamicDomain
@testable import DynamicData

final class NetworkManagerTests: XCTestCase {
    private let networkManager = NetworkManager()
    private let urlSession = URLSession.shared
    
//    func testFetchGIPHYDatas() async throws {
//        // given
//        let expectation = expectation(description: "200")
//        var resultDataCount = 0
//
//        // when
//        let testData = try await dynamicRepository.retrieveGIFImageData(searchWord: "coding", offset: 0)
//        resultDataCount = testData.originalImages.count
//        expectation.fulfill()
//
//        wait(for: [expectation], timeout: 5)
//
//        // then
//        XCTAssertEqual(resultDataCount, 20)
//    }
    
    func testURLSetup() async throws {
        // Given
        let parameters: [String: Any] = ["api_key":"fUyNy20JVfRpEHP0UJEAJQk8mT3hyv4H",
                                         "q":"Cat",
                                         "limit":"3",
                                         "offset":"0",
                                         "rating":"g",
                                         "lang":"en"]
        let baseURL = "https://api.giphy.com"
        let searchPath = "/v1/gifs/search"
        let method: NetworkManager.Method = .get
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.path = searchPath
        urlComponents?.queryItems = parameters.map { URLQueryItem.init(name: $0, value: $1 as? String) }
        guard let url = urlComponents?.url else { return }
        var requestUrl = URLRequest(url: url, timeoutInterval: Double.infinity)
        requestUrl.httpMethod = method.rawValue
        
        // When
        let (data, urlResponse) = try await urlSession.data(for: requestUrl)
        let decodeData = try JSONDecoder().decode(GIPHYFromAPIEntity.self, from: data)
        
        // Then
        XCTAssertEqual(decodeData.giphyData.count, 3)
    }
    
    func testRequest() async throws {
        // Given
        let parameters: [String: Any] = ["api_key":"fUyNy20JVfRpEHP0UJEAJQk8mT3hyv4H",
                                         "q":"Cat",
                                         "limit":"3",
                                         "offset":"0",
                                         "rating":"g",
                                         "lang":"en"]
        let baseURL = "https://api.giphy.com"
        let searchPath = "/v1/gifs/search"
        let method: NetworkManager.Method = .get
        
        // When
        let (data, urlResponse) = try await networkManager.request(path: searchPath,
                                                                   parameters: parameters,
                                                                   method: method)
        
        // Then
        XCTAssertEqual(data.giphyData.count, 3)
    }
    
    func testRequestImageData() async throws {
        
        
    }
    
}
