
import Foundation
import UIKit
import SwiftUI

class OptionManager : ObservableObject {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Published var showAlert : Bool = false
    @Published var alertTitle : String = ""
    @Published var isCopyIconChanging = false
    @Published var photoURL: UIImage?
    @Published var imageStringi: String = ""
    @Published var showCopiedAlert = false
    @Published var favoriteCardStates: [String: Bool] = [:]
    
    func copyText(text: String) {
        UIPasteboard.general.string = text
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
    }
}

class AppSettings: ObservableObject {
    
    @Published var generatedText: String = ""
    
}
