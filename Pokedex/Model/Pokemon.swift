//
//  Pokemon.swift
//  Pokedex
//
//  Created by t2023-m0117 on 8/5/24.
//

import Foundation

struct Pokemon: Codable {
    let name: String
    let url: String
}

struct PokemonListResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Pokemon]
}

struct PokemonDetail: Codable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let types: [PokemonType]
    let abilities: [PokemonAbility]
    let sprites: PokemonSprites
}

struct PokemonType: Codable {
    let slot: Int
    let type: NamedAPIResource
}

struct PokemonAbility: Codable {
    let isHidden: Bool
    let slot: Int
    let ability: NamedAPIResource
    
    enum CodingKeys: String, CodingKey {
        case isHidden = "is_hidden"
        case slot
        case ability
    }
}

struct PokemonSprites: Codable {
    let frontDefault: String?
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

struct NamedAPIResource: Codable {
    let name: String
    let url: String
}

