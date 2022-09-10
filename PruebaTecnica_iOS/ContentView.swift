//
//  ContentView.swift
//  PruebaTecnica_iOS
//
//  Created by Fernando Villalba  on 10/9/22.
//

import SwiftUI

struct ContentView: View {
    let request = Requests()
    
    @State private var characters : [Character] = []
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 20.0) {
            Text(self.characters.first?.name ?? "")
            AsyncImage(url: URL(string: self.characters.first?.image ?? ""))
            Text(self.characters.first?.originPlanet ?? "")
            Text(self.characters.first?.status ?? "")
        }
        .padding()
        .onAppear(){
            request.getAllCharacters() { result in
                switch result {
                case let .success(response):
                    print("Los datos obtenidos de mi petición son \(String(describing: response))")
                    DispatchQueue.main.async {
                        self.characters = response.characters
                    }
                    
                case let .failure(error):
                    print(error)
                    
                    DispatchQueue.main.async {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
