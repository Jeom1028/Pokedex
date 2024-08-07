//
//  ImageService.swift
//  Pokedex
//
//  Created by t2023-m0117 on 8/7/24.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

class ImageService {
    static let shared = ImageService()
    
    private init() {}
    
    // 이미지 URL을 생성하는 메소드
    func imageURL(for id: String) -> URL? {
        let urlString = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png"
        return URL(string: urlString)
    }
    
    // 이미지 로드를 옵저버블로 처리
    func fetchImage(for id: String) -> Observable<UIImage?> {
        guard let url = imageURL(for: id) else {
            return Observable.just(nil)
        }
        
        return NetworkManager.shared.fetchImage(from: url)
    }
}
