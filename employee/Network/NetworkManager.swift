//
//  NetworkManager.swift
//  employee
//
//  Created by Vaibhav Gupta on 28/01/25.
//

import Foundation
import Combine

class NetworkManager{
    static let shared = NetworkManager()
    
    private init(){}
    var cancellables = Set<AnyCancellable>()
    //Generic method for Network Request
    func fetchData<T: Decodable>(from urlString: ApiConstants) -> AnyPublisher<T, Error> {
        guard let url = URL(string: urlString.rawValue) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
