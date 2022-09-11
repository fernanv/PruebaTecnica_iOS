//
//  Requests.swift
//  PruebaTecnica_iOS
//
//  Created by Fernando Villalba  on 10/9/22.
//

import Alamofire

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

struct Character: Codable, Identifiable{
    
    let id: Int
    let image: String
    let name: String
    let originPlanet: String
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case image = "image"
        case name = "name"
        case originPlanet = "origin"
        case status = "status"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.image = try container.decode(String.self, forKey: .image)
        self.name = try container.decode(String.self, forKey: .name)
        let origin = try container.decode(Origin.self, forKey: .originPlanet)
        self.originPlanet = origin.name
        self.status = try container.decode(String.self, forKey: .status)
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

class Requests: ObservableObject {
    
    @Published var characters: [Character] = []
    @Published var isLoadingContent = false
    private var lastPage: Int = 42
    private var currentPage = 1
    private var canLoadMore = true
    private var filterActivated = false
    
    init() {
        self.loadCharacters()
    }
    
    func loadCharacters() {
        
        if self.currentPage == self.lastPage {
            self.canLoadMore = false
        }
        
        self.getCharactersByPage(page: self.currentPage) { result in
            switch result {
            case let .success(response):
                DispatchQueue.main.async {
                    self.lastPage = response.info.pages
                    for character in response.characters {
                        self.characters.append(character)
                    }
                }
            case let .failure(error):
                print(error)
            }
        }
        
    }
    
    private func getCharactersByPage(page: Int, callback: @escaping (Result<Characters, Error>) -> Void){
        
        guard !self.isLoadingContent && self.canLoadMore else {
            return
        }
        
        self.isLoadingContent = true
        
        let weatherURLString = "https://rickandmortyapi.com/api/character/?page=\(page)"
        AF.request(weatherURLString, method: .get).validate()
            .responseDecodable(of: Characters.self) { response in
            switch response.result {
            case let .success(response):
                callback(.success(response))
                self.isLoadingContent = false
                self.currentPage += 1
            case let .failure(error):
                callback(.failure(error))
            }
        }
    }
    
    func getCharactersByStatus(page: Int, status: String, callback: @escaping (Result<Characters, Error>) -> Void){
        
        guard !self.isLoadingContent && self.canLoadMore else {
            return
        }
        
        self.isLoadingContent = true
        
        let weatherURLString = "https://rickandmortyapi.com/api/character/?page=\(page)&status=\(status)"
        AF.request(weatherURLString, method: .get).validate()
            .responseDecodable(of: Characters.self) { response in
            switch response.result {
            case let .success(response):
                callback(.success(response))
                self.isLoadingContent = false
                self.currentPage += 1
            case let .failure(error):
                callback(.failure(error))
            }
        }
    }
    
}
