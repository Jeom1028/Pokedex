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
    
    private var limit = 20
    private var offset = 0
    private var isloading = false
    
    init() {
        fetchPokemonList()
    }
    
    private func fetchPokemonList() {
        guard !isloading else { return }
        isloading = true
        
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=\(limit)&offset=\(offset)") else {
            return
        }
        
        networkManager.fetch(url: url)
            .subscribe(
                onSuccess: { [weak self] (response: PokemonListResponse) in
                    guard let self = self else { return }
                    
                    var currentPokemons = self.pokemonList.value
                    currentPokemons.append(contentsOf: response.results)
                    self.pokemonList.accept(currentPokemons)
                    self.offset += self.limit
                    self.isloading = false
                },
                onFailure: { [weak self] error in
                    self?.error.onNext(error)
                    self?.isloading = false
                }
            )
            .disposed(by: disposeBag)
    }
    
    func loadMorePokemons() {
        fetchPokemonList()
    }
    
    func selectPokemon(_ pokemon: Pokemon) {
        selectedPokemon.onNext(pokemon)
    }
}
