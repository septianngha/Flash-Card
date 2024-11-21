//
//  FlashcardListView.swift
//  Flash Card
//
//  Created by Muhamad Septian Nugraha on 19/11/24.
//

import SwiftUI

struct FlashcardListView: View {
    @StateObject var viewModel = FlashcardViewModel()
    @State private var showAddFlashcard = false
    @State private var showShuffleFlashcard = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.flashcards, id: \.self) { flashcard in
                    VStack(alignment: .leading) {
                        Text(flashcard.word ?? "")
                            .font(.headline)
                        Text(flashcard.translation ?? "")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                    }
                }
                .onDelete { indexSet in
                    indexSet.map { viewModel.flashcards[$0] }
                        .forEach(viewModel.deleteFlashcard)
                }
            }
            .navigationTitle("Flashcards")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { showShuffleFlashcard = true }) {
                        Text("Shuffle")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showAddFlashcard.toggle() }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddFlashcard) {
                AddFlashcardView(viewModel: viewModel)
            }
            
            // Navigasi ke halaman Shuffle
            NavigationLink(
                destination: ShuffleFlashcard(viewModel: viewModel),
                isActive: $showShuffleFlashcard
            ) {
                EmptyView()
            }
            
        }
        .tint(.black)
        
    }
}

struct FlashcardListView_Previews: PreviewProvider {
    static var previews: some View {
        FlashcardListView(viewModel: FlashcardViewModel.preview())
    }
}
