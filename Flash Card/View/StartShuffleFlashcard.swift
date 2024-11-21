//
//  StartShuffleFlashcard.swift
//  Flash Card
//
//  Created by Muhamad Septian Nugraha on 20/11/24.
//


import SwiftUI

struct StartShuffleFlashcard: View {
    @ObservedObject var viewModel: FlashcardViewModel
    
    @State private var showStartText = false
    @State private var countDown = 3
    @State private var timerActive = false
    
    @State private var showTranslation = false
    @State private var showMainContent = false
    @State private var showAlert = false
    
    let imageValue: String?
    
    var body: some View {
        VStack {
            
            Spacer().frame(height: 150)
            
            if showMainContent {
                // Tampilan Image dan Text
                if imageValue == "english" {
                    ZStack {
                        Image(showTranslation ? "background2" : "background1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                            .opacity(0.8)
                            .onTapGesture {
                                if showTranslation {
                                    viewModel.goToNextCard(showAlert: $showAlert)
                                }
                                showTranslation.toggle()
                            }
                            .overlay(
                                Text((showTranslation ? viewModel.currentFlashcard.translation : viewModel.currentFlashcard.word) ?? "")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.black)
                                    .padding(.bottom, 40)
                                    .cornerRadius(10),
                                alignment: .center
                            )
                    }
                } else {
                    ZStack {
                        Image(showTranslation ? "background1" : "background2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                            .opacity(0.8)
                            .onTapGesture {
                                if showTranslation {
                                    viewModel.goToNextCard(showAlert: $showAlert)
                                }
                                showTranslation.toggle()
                            }
                            .overlay(
                                Text((showTranslation ? viewModel.currentFlashcard.word : viewModel.currentFlashcard.translation) ?? "")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.black)
                                    .padding(.bottom, 40)
                                    .cornerRadius(10),
                                alignment: .center
                            )
                    }
                }
                
            } else {
                
                if countDown > 0 {
                    // Menampilkan countdown
                    Text("\(countDown)")
                        .font(.title)
                        .fontWeight(.bold)
                } else if showStartText {
                    // Menampilkan "Mulai" setelah countdown selesai
                    Text("Mulai!")
                        .font(.title)
                        .fontWeight(.bold)
                }
            }
            
            Spacer()
            
        }
        .onAppear {
            startCountdown() // Mulai countdown otomatis saat view muncul
        }
        
        // Menambahkan alert ketika telah menyelesaikan Flashcard
        .alert("Pemberitahuan", isPresented: $showAlert) {
            Button("Ok", role: .cancel) { }
        } message: {
            Text("Kerja Bagus! Anda telah menyelesaikan semua Flashcards.")
        }
        
        
    }
    
    private func startCountdown() {
        guard !timerActive else { return } // Hindari duplikasi timer
        timerActive = true
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if countDown > 0 {
                countDown -= 1
            } else {
                timer.invalidate()
                timerActive = false
                showStartText = true // Tampilkan "Mulai" setelah countdown selesai
                
                // Hilangkan teks "Mulai" setelah Main content muncul
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    showStartText = false
                    showMainContent = true
                }
            }
        }
    }
}


struct StartShuffleFlashcard_Preview: PreviewProvider {
    static var previews: some View {
        StartShuffleFlashcard(viewModel: FlashcardViewModel.preview(), imageValue: "indonesian")
            .previewLayout(.sizeThatFits)
    }
}
