//
//  DetailViewModel.swift
//  Pokedex
//
//  Created by t2023-m0117 on 8/7/24.
//

import Foundation
import RxSwift
import RxCocoa

class DetailViewModel {
    private let networkManager = NetworkManager.shared
    private let disposeBag = DisposeBag()
    
    let pokemonDetail: BehaviorSubject<PokemonDetail?> = BehaviorSubject(value: nil)
    let error: PublishSubject<Error> = PublishSubject()
    
    func fetchPokemonDetails(for id: String) {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(id)") else { return }
        
        networkManager.fetch(url: url)
            .subscribe(
                onSuccess: { [weak self] (pokemonDetail: PokemonDetail) in
                    self?.pokemonDetail.onNext(pokemonDetail)
                },
                onFailure: { [weak self] error in
                    self?.error.onNext(error)
                }
            )
            .disposed(by: disposeBag)
    }
}
