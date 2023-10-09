
import Foundation
import Replicate
import UIKit
import Alamofire
import SwiftUI

class replicateAPI: ObservableObject {
    
    @Published var showCard : Bool = false
    @Published var generatedText: String = ""
    @Published var isShowingResult: Bool = false
    @Published var titles : [String] = []
    var dataManager = DataManager()
    var card : [Card] = []
    @ObservedObject var cardViewModel = CardViewModel()
    
    let replicate = Replicate.Client(token: "YOURAPITOKEN")
    
    func isValueExistsInUserDefaults(forKey key: String) -> Bool {
        let defaults = UserDefaults.standard
        return defaults.object(forKey: key) != nil
    }
    
    func generateCap(cap: String, image: UIImage) {
        
        let apiKey = "YOURAPIKEY"
        let url = "https://api.openai.com/v1/completions"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(apiKey)",
            "Content-Type": "application/json"
        ]
        
        let prompt = "come up with a unique caption to go with the photo where \(generatedText) "
        
        let parameters : Parameters = [
            "prompt": prompt,
            "max_tokens": 200,
            "n": 10,
            "temperature": 0.4,
            "model": "text-davinci-003"
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                //                debugPrint(response)
                switch response.result {
                case .success(let value):
                    if let json = value as? [String: Any],
                       let choices = json["choices"] as? [[String: Any]] {
                        var generatedText: [String] = []
                        for choice in choices {
                            if let text = choice["text"] as? String {
                                
                                generatedText.append(text)
                            }
                        }
                        DispatchQueue.main.async {
                            self.card = Array(generatedText.enumerated()).map { (index, text) in
                                let trimmedTitle = text.trimmingCharacters(in: .whitespacesAndNewlines)
                                Card(id: index, image: image, title: text)
                                return Card(id: index, image: image, title: trimmedTitle)
                            }
                            self.cardViewModel.cards = self.card
                            self.showCard = true
                            self.cardViewModel.titles = generatedText
                            let titles = self.card.map { $0.title }
                            self.cardViewModel.titles = titles
                            let updatedDataModel = self.dataManager.addHistoryItems(titlse: self.cardViewModel.titles)
                            self.dataManager.saveDataModelToUserDefaults(updatedDataModel)
                            self.dataManager.addHistoryItems(titlse: self.cardViewModel.titles)
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    func formatFileSize(_ bytes: Int) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: Int64(bytes))
    }
    
    func resizeImage(image: UIImage, scaleFactor: CGFloat) -> UIImage? {
        let newSize = CGSize(width: image.size.width * scaleFactor, height: image.size.height * scaleFactor)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func generateText(from image: UIImage) {
        Task.detached {
            do {
                let modelID = "salesforce/blip"
                let mimeType = "image/jpeg"
                if let resizedImage = await self.resizeImage(image: image, scaleFactor: 1/3){
                    
                    if let imageData = resizedImage.jpegData(compressionQuality: 0.5) {
                        let uriEncoded = imageData.uriEncoded(mimeType: mimeType)
                        
                        let model = try await self.replicate.getModel(modelID)
                        if let latestVersion = model.latestVersion {
                            
                            let prediction = try await self.replicate.createPrediction(
                                version: latestVersion.id,
                                input: ["image": Value.string(uriEncoded), "task": "image_captioning"],
                                wait: true
                            )
                            
                            switch prediction.output {
                                
                            case .string(let outputString):
                                
                                let components = outputString.components(separatedBy: ":")
                                if components.count > 1 {
                                    let trimmedOutput = components[1].trimmingCharacters(in: .whitespaces)
                                    
                                    DispatchQueue.main.async {
                                        
                                        self.generatedText = trimmedOutput
                                        self.isShowingResult = true
                                        
                                        if self.generatedText != nil {
                                            self.generateCap(cap: self.generatedText, image: image)
                                        }
                                    }
                                }
                            default:
                                print("Ответ не является строкой.")
                            }
                        }
                    } else {
                        print("Ошибка: Не удалось преобразовать изображение в data.")
                    }
                }
            } catch {
                print("Ошибка при отправке фото и получении описания: \(error)")
            }
        }
    }
}

class CardViewModel: ObservableObject {
    
    @Published var cards: [Card] = []
    @Published var titles : [String] = []
    
}
