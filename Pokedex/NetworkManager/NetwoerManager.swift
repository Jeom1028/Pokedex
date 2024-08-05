//
//  NetwoerManager.swift
//  Pokedex
//
//  Created by t2023-m0117 on 8/5/24.
//

import Foundation
import RxSwift

class NetwoerManager {
    static let shared = NetwoerManager()
    
    private init() {}
    
    func fetch<T: Decodable>(url: URL) -> Single<T> {
        return Single.create { single in
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    single(.failure(error))
                    return
                }
                
                guard let data = data else {
                    single(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(T.self, from: data)
                    single(.success(result))
                } catch {
                    single(.failure(error))
                }
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
