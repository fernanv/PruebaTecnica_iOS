//
//  CharacterEpisodesViewModel.swift
//  PruebaTecnica_iOS
//
//  Created by Fernando Villalba  on 13/9/22.
//

import Alamofire

class EpisodesViewModel: ObservableObject {
    
    @Published var episodes: [Episode] = []
    
    @Published var character: Character
    @Published var sections: Set<String> = []
    @Published var isLoadingContent = false
    
    init(character: Character) {
        self.character = character
        self.getCharacterEpisodes()
    }

    func getCharacterEpisodes(){
        
        for episode in self.character.episode {
            self.getEpisode(episodeURL: episode){
                result in
                switch result {
                case let .success(response):
                    DispatchQueue.main.async {
                        self.episodes.append(response)
                        self.sections.insert(response.section)
                    }
                case let .failure(error):
                    print(error)
                }
            }
        }
    }
    
    private func getEpisode(episodeURL: String, callback: @escaping (Result<Episode, Error>) -> Void){
    
        self.isLoadingContent = true
        
        AF.request(episodeURL, method: .get).validate()
            .responseDecodable(of: Episode.self) { response in
            switch response.result {
            case let .success(response):
                callback(.success(response))
                self.isLoadingContent = false
            case let .failure(error):
                callback(.failure(error))
            }
        }
    }
    
}
