//
//  FlashcardViewModel.swift
//  Flash Card
//
//  Created by Muhamad Septian Nugraha on 19/11/24.
//

import Foundation
import CoreData
import SwiftUI

class FlashcardViewModel: ObservableObject {
    
    private let context = PersistenceController.shared.container.viewContext
    
    @Published var flashcards: [Flashcard] = []
    @Published var currentIndex: Int = 0
    
    init() {
        fetchFlashcards()
    }
    
    // MARK: - Mengambil Data Flashcards.
    func fetchFlashcards() {
        let request: NSFetchRequest<Flashcard> = Flashcard.fetchRequest()
        do {
            flashcards = try context.fetch(request)
        } catch {
            print("Failed to fecth flashcards: \(error.localizedDescription)")
        }
    }
    
    
    // MARK: - Function untuk Menambahkan data flashcards.
    func addFlashcard(word: String, translation: String) {
        let newFlashcard = Flashcard(context: context)
        newFlashcard.word = word
        newFlashcard.translation = translation
        
        saveContext()
        fetchFlashcards()
    }
    
    
    // MARK: - Function untuk saving data ke Core Data
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error.localizedDescription)")
        }
    }
    
    
    // MARK: - Function untuk delete data di Core Data
    func deleteFlashcard(_ flashcard: Flashcard) {
        context.delete(flashcard)
        
        saveContext()
        fetchFlashcards()
    }
    
    
    // MARK: - Function untuk menunjukan flashcard yang ditampilkan dan mengarahkan ke flashcard selanjutnya.
    var currentFlashcard: Flashcard {
        return flashcards[currentIndex]
    }
    
    func goToNextCard(showAlert: Binding<Bool>) {
        if currentIndex < flashcards.count - 1 {
            currentIndex += 1
        } else {
            currentIndex = 0
            print("Finish the sprint.")
            showAlert.wrappedValue = true
        }
    }
    
    
    // MARK: - Shake Effect pada Gambar
    struct ShakeEffect: GeometryEffect {
        var shakes: Int
        var animatableData: CGFloat {
            get { CGFloat(shakes) }
            set { shakes = Int(newValue) }
        }

        func effectValue(size: CGSize) -> ProjectionTransform {
            let translation = shakes % 2 == 0 ? -10 : 10
            return ProjectionTransform(CGAffineTransform(translationX: CGFloat(translation), y: 0))
        }
    }
    
    
    // MARK: - Data Dummy untuk Preview
    static func preview() -> FlashcardViewModel {
        let viewModel = FlashcardViewModel()
        viewModel.flashcards = [
            Flashcard.preview(word: "Hello", translation: "Halo"),
            Flashcard.preview(word: "Thank You", translation: "Terima Kasih")
        ]
        return viewModel
    }
}


// MARK: - Extension Flashcard untuk Data Dummy
extension Flashcard {
    static func preview(word: String, translation: String) -> Flashcard {
        let flashcard = Flashcard(context: PersistenceController.shared.container.viewContext)
        flashcard.word = word
        flashcard.translation = translation
        return flashcard
    }
}
    



