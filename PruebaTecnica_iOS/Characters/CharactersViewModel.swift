//
//  CharactersViewModel.swift
//  PruebaTecnica_iOS
//
//  Created by Fernando Villalba  on 10/9/22.
//

import Alamofire

class CharactersViewModel: ObservableObject {
    
    @Published var characters: [Character] = [] // Reference to Model
    
    @Published var isLoadingContent = false
    
    private var lastPage = 42 // Se debería obtener mediante una función y no mirando la info del json obtenido
    private var currentPage = 1
    private var canLoadMore = true
    var newStatus = false
    
    init() {
        self.loadCharacters(status: .None) // Inicialmente sin status
    }
    
    // MARK: - CharactersViewModel public functions
    
    /*
     Función que carga todos los caracteres según el status dado,
     se obtienen de forma paginada y cada vez que se cambia de status
     se vacía el array de personajes y se comienza la carga con la paginación
     desde cero.
     */
    func loadCharacters(status: Status) {
        
        // Si la página actual es la última no se pueden cargar más personajes
        if self.currentPage == self.lastPage {
            self.canLoadMore = false
        }
        
        // Cada vez que se cambia de status se reinicia la paginación
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
    
    // MARK: - CharactersViewModel private functions
    
    /*
     Se otienenn todos los personajes de una página dada
     */
    private func getCharactersByPage(page: Int, callback: @escaping (Result<Characters, Error>) -> Void){
        
        guard !self.isLoadingContent && self.canLoadMore else {
            return
        }
        // Para mostrar la carga de datos de forma visual
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
    
    /*
     Se obtienen todos los personajes de una página dada y con el status pasado
     como parámetro
     */
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
