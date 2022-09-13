//
//  ContentView.swift
//  PruebaTecnica_iOS
//
//  Created by Fernando Villalba  on 10/9/22.
//

import SwiftUI

struct CharactersView: View {
    
    @StateObject var viewModel = CharactersViewModel()
    
    @State var selectedStatus: Status = .None
    private let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 4)
    
    var body: some View {
    
        NavigationView{
            
            ZStack {
                
                Color(red: 204.0/255.0, green: 255.0/255.0, blue: 255.0/255.0)
                    .ignoresSafeArea()
                
                VStack(alignment: .center, spacing: 5.0){
                    
                    Text("Rick & Morty Characters")
                        .foregroundColor(.cyan)
                        .font(.title)
                        .bold()
                        .italic()
                        .padding(.all, 5.0)
                    
                    HStack {
                        Text("Status: ")
                            .foregroundColor(.purple)
                        Picker("Status", selection: $selectedStatus) {
                            Text("Sin status").tag(Status.None)
                            Text("Vivo").tag(Status.Alive)
                            Text("Muerto").tag(Status.Dead)
                            Text("Desconocido").tag(Status.unknown)
                        }
                        .onChange(of: self.selectedStatus) { _ in
                            self.viewModel.newStatus = true
                            self.viewModel.loadCharacters(status: self.selectedStatus)
                        }
                        .background(Color(red: 242.0/255.0, green: 233.0/255.0, blue: 251.0/255.0))
                        .cornerRadius(10.0)
                    }
                    .padding(.leading, 180.0)
                    .padding(.all, 0.5)
                    
                    ScrollView(.vertical, showsIndicators: true){
                        LazyVGrid(columns: self.columns, spacing: 5.0){
                            ForEach(self.viewModel.characters, id: \.id){
                                character in
                                withAnimation{
                                    NavigationLink{
                                        EpisodesView(viewModel: EpisodesViewModel(character: character))
                                    } label : {
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
                                            if character.name == self.viewModel.characters.last?.name {
                                                self.viewModel.loadCharacters(status: self.selectedStatus)
                                            }
                                        }
                                    } // Fin LazyVStack
                                } // Fin label NavigationLink
                            } // Fin ForEach
                        } // Fin LazyVGrid
                        .padding(.horizontal)
                        if self.viewModel.isLoadingContent {
                            ProgressView().frame(width: 500.0, height: 500.0, alignment: .center)
                        }
                    } // Fin ScrollView
                } // Fin VStack
            } // Fin ZStack
            .navigationBarHidden(true)
        } // Fin NavigationView
    } // Fin View
}

struct CharactersView_Previews: PreviewProvider {
    static var previews: some View {
        CharactersView()
    }
}
