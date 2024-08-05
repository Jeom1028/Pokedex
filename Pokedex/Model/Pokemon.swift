//
//  Pokemon.swift
//  Pokedex
//
//  Created by t2023-m0117 on 8/5/24.
//

import Foundation

// 포켓몬 기본 정보를 담을 구조체
struct Pokemon: Codable {
    let name: String
    let url: String
}

// 포켓몬 목록 API 응답을 담을 구조체
struct PokemonListResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Pokemon]
}

// 포켓몬 디테일 정보를 담을 구조체
struct PokemonDetail: Codable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let types: [PokemonType]
    let abilities: [PokemonAbility]
    let sprites: PokemonSprites
}

// 포켓몬 타입 정보를 담을 구조체
struct PokemonType: Codable {
    let slot: Int
    let type: NamedAPIResource
}

// 포켓몬 능력 정보를 담을 구조체
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

// 포켓몬 스프라이트 정보를 담을 구조체
struct PokemonSprites: Codable {
    let frontDefault: String?
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

// 이름이 있는 API 리소스를 담을 구조체
struct NamedAPIResource: Codable {
    let name: String
    let url: String
}

