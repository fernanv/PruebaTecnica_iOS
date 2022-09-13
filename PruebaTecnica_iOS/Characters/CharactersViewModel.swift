//
//  CharactersViewModel.swift
//  PruebaTecnica_iOS
//
//  Created by Fernando Villalba  on 10/9/22.
//

import Alamofire

class CharactersViewModel: ObservableObject {
    
    @Published var characters: [Character] = []
    @Published var isLoadingContent = false
    
    private var lastPage: Int = 42
    private var currentPage = 1
    private var canLoadMore = true
    var newStatus = false
    
    init() {
        self.loadCharacters(status: .None)
    }
    
    func loadCharacters(status: Status) {
        
        if self.currentPage == self.lastPage {
            self.canLoadMore = false
        }
        
        if self.newStatus {
            self.characters.removeAll()
            self.currentPage = 1
            self.newStatus = false
        }
        
        if status == .None {
            
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
        else {
            self.getCharactersByStatus(page: self.currentPage, status: status.rawValue) { result in
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
        
    }
    
    private func getCharactersByPage(page: Int, callback: @escaping (Result<Characters, Error>) -> Void){
        
        guard !self.isLoadingContent && self.canLoadMore else {
            return
        }
        
        self.isLoadingContent = true
        
        let apiURLString = "https://rickandmortyapi.com/api/character/?page=\(page)"
        AF.request(apiURLString, method: .get).validate()
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
    
    private func getCharactersByStatus(page: Int, status: String, callback: @escaping (Result<Characters, Error>) -> Void){
        
        guard !self.isLoadingContent && self.canLoadMore else {
            return
        }
        
        self.isLoadingContent = true
        
        let apiURLString = "https://rickandmortyapi.com/api/character/?page=\(page)&status=\(status)"
        AF.request(apiURLString, method: .get).validate()
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
