//
//  EpisodesView.swift
//  PruebaTecnica_iOS
//
//  Created by Fernando Villalba  on 12/9/22.
//

import SwiftUI

struct EpisodesView: View {
    
    @State var viewModel : EpisodesViewModel // Reference to ViewModel
    
    init(viewModel: EpisodesViewModel){
        self.viewModel = viewModel
    }
    
    var body: some View {

        List {
            ForEach(self.viewModel.sections.sorted(by: <), id: \.self) { section in
                Group{
                    Text("Temporada: \(section)")
                        .font(.title)
                        .bold()
                        .listRowBackground(Color(red: 204.0/255.0, green: 255.0/255.0, blue: 255.0/255.0))
                        .padding(.vertical, 20.0)
                    
                    ForEach(self.viewModel.episodes) { episode in
                        if episode.section == section {
                            Text("Episodio: \(episode.episode)")
                                .bold()
                                .listRowBackground(Color(red: 204.0/255.0, green: 255.0/255.0, blue: 255.0/255.0))
                            Text("Nombre: \(episode.name)")
                                .listRowBackground(Color(red: 204.0/255.0, green: 255.0/255.0, blue: 255.0/255.0))
                            Text("Fecha de emisión: \(episode.airDate)")
                                .listRowBackground(Color(red: 204.0/255.0, green: 255.0/255.0, blue: 255.0/255.0))
                                .padding(.bottom, 20.0)
                        }
                    }
                }
            }
        }
        .navigationBarTitle(self.viewModel.character.name)
    }
}
