
import SwiftUI
import UIKit

struct CardView: View {
    
    @State private var isButtonPressed = false
    @State var textList: [String] = []
    @State var offset : CGFloat = 0
    @State var cardWidth: CGFloat = 300
    @State var cardSpacing: CGFloat = 56
    @State var isShareSheetPresented = false
    @State var selectedImage : Bool = true
    @State var settingsDetent = PresentationDetent.height(320)
    @State var isShowingNotification = false
    @State var isShowingActivityView = false
    @State var isShareIconChanging = false
    @State var isFavIconChanging = false
    @State var card : [Card]
    @State var currentIndex = 0
    @State var CardIndex: Int = 0
    @State var newBool : Bool = false
    @State private var translation: CGSize = .zero
    @State private var direction: Int = 0
    @ObservedObject var viewModel = MyViewModel()
    @EnvironmentObject var api : replicateAPI
    @ObservedObject var optionManager : OptionManager
    @EnvironmentObject var appSettings: AppSettings
    @ObservedObject var dataManager : DataManager
    @Environment(\.managedObjectContext) private var viewContext
    
    func addTextToFav(_ newString: String) {
        if var savedArray = UserDefaults.standard.stringArray(forKey: "cardData") {
            
            savedArray.append(newString)
            UserDefaults.standard.set(savedArray, forKey: "cardData")
            print("String added to UserDefaults successfully.\(savedArray)")
            
        } else {
            let newArray = [newString]
            UserDefaults.standard.set(newArray, forKey: "cardData")
            
            print("Array with the new string added to UserDefaults successfully.")
        }
    }
    
    func shareImageUsingFile(imageToShare: UIImage) {
        
        let temporaryDirectoryURL = FileManager.default.temporaryDirectory
        let imageURL = temporaryDirectoryURL.appendingPathComponent("photocapImage.jpg")
        
        do {
            try imageToShare.jpegData(compressionQuality: 0.8)?.write(to: imageURL)
            
            let activityViewController = UIActivityViewController(
                activityItems: [imageURL],
                applicationActivities: nil
            )
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let viewController = windowScene.windows.first?.rootViewController {
                viewController.present(activityViewController, animated: true, completion: nil)
            }
        } catch {
            print("Error creating or sharing temporary image file: \(error)")
        }
    }
    
    var body: some View {
        ZStack{
            ForEach(api.cardViewModel.cards, id: \.self) { card in
                ZStack{
                    VStack{
                        
                        Image(uiImage: card.image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 300, height: 320)
                            .clipped()
                        
                        Text(card.title)
                            .frame(width: 275, height: 55, alignment: .leading)
                            .font(Font.system(size: 15))
                            .foregroundColor(.blue)
                        
                        ZStack{
                            HStack{
                                Button {
                                    OptionManager().copyText(text: card.title)
                                    
                                    CardIndex = card.id
                                    optionManager.isCopyIconChanging = true
                                    optionManager.showCopiedAlert = true
                                    optionManager.alertTitle = "Успешно скопировано"
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.1) {
                                        optionManager.showCopiedAlert = false
                                        
                                        optionManager.isCopyIconChanging = false
                                    }
                                    isShowingNotification = true
                                } label: {
                                    Image(systemName: optionManager.isCopyIconChanging && CardIndex == card.id ? "doc.on.doc.fill" : "doc.on.doc")
                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                                }
                                
                                Divider()
                                
                                Button {
                                    let generator = UIImpactFeedbackGenerator(style: .heavy)
                                    generator.prepare()
                                    generator.impactOccurred()
                                    
                                    DispatchQueue.main.async {
                                        optionManager.showCopiedAlert = true
                                        
                                        if let isFavorite = optionManager.favoriteCardStates[card.title] {
                                            if isFavorite {
                                                optionManager.favoriteCardStates[card.title] = false
                                                if let index = dataManager.data.favourites.firstIndex(where: { $0.favourites == card.title }) {
                                                    dataManager.data.favourites.remove(at: index)
                                                }
                                                optionManager.alertTitle = "Удалено из избранного"
                                            } else {
                                                optionManager.favoriteCardStates[card.title] = true
                                                optionManager.alertTitle = "Добавлено в избранное"
                                                dataManager.addItem(favourite: card.title, date: Date())
                                            }
                                        } else {
                                            optionManager.favoriteCardStates[card.title] = true
                                            optionManager.alertTitle = "Добавлено в избранное"
                                            dataManager.addItem(favourite: card.title, date: Date())
                                        }
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.1) {
                                            isShowingNotification = true
                                            optionManager.showCopiedAlert = false
                                        }
                                    }
                                } label: {
                                    Image(systemName: optionManager.favoriteCardStates[card.title] == true ? "heart.fill" : "heart")
                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                                }
                                
                                Divider()
                                
                                Button {
                                    isShareIconChanging = true
                                    CardIndex = card.id
                                    optionManager.showCopiedAlert = true
                                    optionManager.alertTitle = "Успешно скопировано"
                                    
                                    shareImageUsingFile(imageToShare: card.image)
                                    OptionManager().copyText(text: card.title)
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.1) {
                                        isShareIconChanging = false
                                        optionManager.showCopiedAlert = false
                                    }
                                } label: {
                                    Image(systemName: isShareIconChanging && CardIndex == card.id ? "square.and.arrow.up.fill" : "square.and.arrow.up")
                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                                }
                            }
                            .frame(width: card.id == currentIndex ? 300 : 300, height: 40)
                            .foregroundStyle(.blue)
                        }.overlay(
                            Divider().padding(.bottom, 42)
                        )
                    }
                }  .padding(.horizontal, 26)
                    .frame(width: card.id == currentIndex ? 300 : 300, height: card.id == currentIndex ? 425 : 420)
                    .background(
                        Color.white
                            .aspectRatio(contentMode: .fill)
                            .blur(radius: 90)
                            .frame(width: card.id == currentIndex ? 300 : 300, height: card.id == currentIndex ? 425 : 420)
                    )
                    .cornerRadius(25)
                    .offset(x: CGFloat(card.id - currentIndex) * (cardWidth + cardSpacing) + offset, y: card.id != currentIndex ? 27 : 0)
            }
        }
        .gesture(
            DragGesture()
                .onEnded({ value in
                    let def: CGFloat = 10
                    
                    if value.translation.width > def {
                        withAnimation {
                            currentIndex = max(0, currentIndex - 1)
                        }
                    } else if value.translation.width < -def {
                        withAnimation {
                            currentIndex = min(api.cardViewModel.cards.count - 1, currentIndex + 1)
                        }
                    }
                })
        ).onAppear{
            if dataManager.data.favourites.contains(where: { $0.favourites == dataManager.deletedFavString }) {
            } else {
                optionManager.favoriteCardStates[dataManager.deletedFavString] = false
            }
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: [], viewModel: MyViewModel(), optionManager: OptionManager(), dataManager: DataManager())
    }
}
