//
//  EpisodesModel.swift
//  PruebaTecnica_iOS
//
//  Created by Fernando Villalba  on 13/9/22.
//

import Foundation

struct Episode: Codable, Identifiable{
    
    let id: Int
    let name: String
    var airDate: String
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
        
        self.airDate = TranslateDate(dateString: self.airDate)
        
    }
    
    // MARK: - Episode functions 
    /*
     Se obtiene la fecha en el formato deseado y en Español y se añaden las palabras 'de'
     */
    private func TranslateDate(dateString: String) -> String{

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "es_ES")
        dateFormatter.dateFormat = "d, MMMM, yyyy"
        let date = dateFormatter.date(from: dateString) ?? Date()
        
        let dateString = dateFormatter.string(from: date).replacingOccurrences(of: ",", with: " de")
        
        return dateString
    }


}
