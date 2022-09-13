//
//  CharacterEpisodesModel.swift
//  PruebaTecnica_iOS
//
//  Created by Fernando Villalba  on 13/9/22.
//

import Foundation

struct Episode: Codable, Identifiable{
    
    let id: Int
    let name: String
    let airDate: String
    var episode: String
    var section: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case airDate = "air_date"
        case episode = "episode"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.airDate = try container.decode(String.self, forKey: .airDate)
        
        self.episode = try container.decode(String.self, forKey: .episode)
        self.section = String(self.episode.prefix(3))
        self.episode = String(self.episode.suffix(3))
        
    }
}
