//
//  MainViewModel.swift
//  Pokedex
//
//  Created by t2023-m0117 on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

class MainViewModel {
    private let networkManager = NetworkManager.shared
    private let disposeBag = DisposeBag()
    
    let pokemonList: BehaviorRelay<[Pokemon]> = BehaviorRelay(value: [])
    let selectedPokemon: PublishSubject<Pokemon> = PublishSubject()
    let error: PublishSubject<Error> = PublishSubject()
    
    init() {
        fetchPokemonList(limit: 20, offset: 0)
    }
    
    private func fetchPokemonList(limit: Int, offset: Int) {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=\(limit)&offset=\(offset)") else {
            return
        }
        
        networkManager.fetch(url: url)
            .subscribe(
                onSuccess: { [weak self] (response: PokemonListResponse) in
                    self?.pokemonList.accept(response.results)
                },
                onFailure: { [weak self] error in
                    self?.error.onNext(error)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func selectPokemon(_ pokemon: Pokemon) {
        selectedPokemon.onNext(pokemon)
    }
}
