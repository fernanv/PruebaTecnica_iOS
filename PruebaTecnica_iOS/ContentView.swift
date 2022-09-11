//
//  ContentView.swift
//  PruebaTecnica_iOS
//
//  Created by Fernando Villalba  on 10/9/22.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var request = Requests()
    
    //@State private var status : String = ""
    private let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 4)
    
    var body: some View {
    
        ZStack {
            
            Color(red: 204.0/255.0, green: 255.0/255.0, blue: 255.0/255.0)
                .ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 5.0){
                
                Text("Rick & Morty Characters")
                    .foregroundColor(.cyan)
                    .font(.title)
                    .bold()
                    .italic()
                
                
                ScrollView(.vertical, showsIndicators: true){
                    LazyVGrid(columns: self.columns, spacing: 5.0){
                        ForEach(self.request.characters, id: \.id){
                            character in
                            withAnimation{
                                LazyVStack(alignment: .center, spacing: 10.0){
                                    AsyncImage(
                                        url: URL(string: character.image),
                                        content: { image in
                                            image.resizable()
                                                 .aspectRatio(contentMode: .fit)
                                                 .frame(maxWidth: 100, maxHeight: 100)
                                                 .clipShape(Circle())
                                        },
                                        placeholder: {
                                            ProgressView()
                                        }
                                    )
                                    Text("\(character.name)")
                                        .font(.headline)
                                        .foregroundColor(.purple)
                                    Text("Planet: \(character.originPlanet)")
                                        .font(.caption)
                                    Text("Status: \(character.status)")
                                        .font(.caption)
                                }
                                .padding(.vertical)
                                .onAppear(){
                                    if character.name == self.request.characters.last?.name {
                                        self.request.loadCharacters()
                                    }
                                }
                            } // Fin LazyVStack
                        } // Fin ForEach
                    } // Fin LazyVGrid
                    .padding(.horizontal)
                    if self.request.isLoadingContent {
                        ProgressView().frame(width: 500.0, height: 500.0, alignment: .center)
                    }
                } // Fin ScrollView
            } // Fin VStack
        } // Fin ZStack
    } // Fin View
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
