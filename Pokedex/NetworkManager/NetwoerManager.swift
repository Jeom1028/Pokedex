import Foundation
import UIKit
import RxSwift
import RxCocoa

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    // Existing generic fetch method
    func fetch<T: Decodable>(url: URL) -> Single<T> {
        return Single.create { single in
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    single(.failure(error))
                    return
                }
                
                guard let data = data else {
                    let error = NSError(domain: "NetworkErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                    single(.failure(error))
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
    
    // New method to fetch image
    func fetchImage(from url: URL) -> Observable<UIImage?> {
        return Observable.create { observer in
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                
                if let data = data, let image = UIImage(data: data) {
                    observer.onNext(image)
                } else {
                    observer.onNext(nil)
                }
                observer.onCompleted()
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
