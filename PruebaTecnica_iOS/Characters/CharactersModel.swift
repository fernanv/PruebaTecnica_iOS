//
//  CharactersModel.swift
//  PruebaTecnica_iOS
//
//  Created by Fernando Villalba  on 13/9/22.
//

import Foundation

enum Status: String, CaseIterable, Identifiable, Equatable {
    case Alive, Dead, unknown, None
    var id: Self { self }
}

struct Characters: Codable{
    
    let characters: [Character]
    let info: Info
    
    enum CodingKeys: String, CodingKey {
        case characters = "results"
        case info = "info"
    }
}

struct Info: Codable{
    
    let pages: Int
    let nextPage: String
    
    enum CodingKeys: String, CodingKey {
        case pages = "pages"
        case nextPage = "next"
    }
}

// MARK: - Character Data Struct

struct Character: Codable, Identifiable{
    
    let id: Int
    let image: String
    let name: String
    let originPlanet: String
    let status: String
    let episode: [String]
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case image = "image"
        case name = "name"
        case originPlanet = "origin"
        case status = "status"
        case episode = "episode"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.image = try container.decode(String.self, forKey: .image)
        self.name = try container.decode(String.self, forKey: .name)
        let origin = try container.decode(Origin.self, forKey: .originPlanet)
        self.originPlanet = origin.name
        self.status = try container.decode(String.self, forKey: .status)
        self.episode = try container.decode([String].self, forKey: .episode)
    }
}

struct Origin: Codable{
    
    let name: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case url = "url"
    }
}
