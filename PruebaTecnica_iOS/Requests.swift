//
//  Requests.swift
//  PruebaTecnica_iOS
//
//  Created by Fernando Villalba  on 10/9/22.
//

//import Combine
import Alamofire

struct Characters: Codable{
    
    let characters: [Character]
    
    enum CodingKeys: String, CodingKey {
        case characters = "results"
    }
}

struct Character: Codable{
    
    let image: String
    let name: String
    let originPlanet: String
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case image = "image"
        case name = "name"
        case originPlanet = "origin"
        case status = "status"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        image = try container.decode(String.self, forKey: .image)
        name = try container.decode(String.self, forKey: .name)
        let origin = try container.decode(Origin.self, forKey: .originPlanet)
        originPlanet = origin.name
        status = try container.decode(String.self, forKey: .status)
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

class Requests {
    
    func getAllCharacters(callback: @escaping (Result<Characters, Error>) -> Void){
        let weatherURLString = "https://rickandmortyapi.com/api/character"
        AF.request(weatherURLString, method: .get).validate()
            .responseDecodable(of: Characters.self) { response in
            switch response.result {
            case let .success(response):
                callback(.success(response))
            case let .failure(error):
                callback(.failure(error))
            }
        }
    }
    
}
