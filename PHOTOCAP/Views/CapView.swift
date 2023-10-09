
import SwiftUI

struct CapView: View {
    
    @State var showGallery : Bool = false
    @State var selectedImage : Bool = false
    @State private var isSaved = false
    @State var show : Bool = false
    @StateObject var optionManager : OptionManager
    @State var card : Card
    @EnvironmentObject private var api: replicateAPI
    @EnvironmentObject var dataManager: DataManager
    @ObservedObject var myViewModel = MyViewModel()
    @ObservedObject var cardViewModel = CardViewModel()
    @State private var loadingText = "Generation is in progress."
    @Binding var imageSel: UIImage?
    var loadingArray = ["Creating captions for your photos...", "Loading captions for you...", "Captions are being generated.", "Preparing captions for you.", "Generating captions for you...", "Crafting unique phrases for your photos...", "Caption generation in progress.", "Curating unique phrases for your pictures...", "Crafting personalized captions for your images...", "Loading captions just for you...", "Captions are in the works", "We're preparing captions for your photos.", "Generating custom captions for you...", "Curating unique phrases for your pictures..."]
    
    func updateRandomElement() {
        loadingText = loadingArray.randomElement() ?? ""
    }
    
    func resetSelection() {
        selectedImage = false
        imageSel = nil
        api.showCard = false
        isSaved = false
        optionManager.favoriteCardStates = [:]
    }
    
    var body: some View {
        ZStack{
            Image("backsecond")
                .resizable()
            
            if selectedImage == false {
                Button {
                    showGallery = true
                    
                } label: {
                    VStack{
                        Image(systemName: "photo.on.rectangle")
                            .resizable()
                            .frame( width: 66, height: 66)
                            .padding(.bottom, 20)
                        
                        
                        Text("Choose photo")
                            .frame( width: 250, height: 50)
                            .background(.white)
                            .cornerRadius(25)
                    }
                } .sheet(isPresented: $showGallery) {
                    ImagePickerView(selectedImage: $imageSel)
                        .onDisappear {
                            if imageSel != nil {
                                self.selectedImage = true
                                api.generateText(from: imageSel!)
                            }
                            
                        }
                }
            }else{
                ZStack{
                    VStack{
                        if api.showCard != true {
                            VStack{
                                ProgressView()
                                Text(loadingText)
                                    .padding()
                                    .foregroundColor(.white)
                                    .onAppear {
                                        
                                        Timer.scheduledTimer(withTimeInterval: 3.5, repeats: true) { _ in
                                            self.updateRandomElement()
                                        }
                                    }
                            }
                        } else {
                            VStack{
                                HStack{
                                    Spacer()
                                    Button {
                                        resetSelection()
                                    } label: {
                                        Image(systemName: "xmark")
                                            .bold()
                                            .font(.system(size: 30))
                                            .foregroundColor(.white)
                                            .padding([.bottom, .trailing], 40)
                                    }
                                }
                                
                                CardView(card: api.cardViewModel.cards, viewModel: myViewModel, optionManager: optionManager, dataManager: dataManager)
                                    .onAppear() {
                                        if !isSaved {
                                            let allTitles = api.cardViewModel.titles
                                            let updatedDataModel = dataManager.addHistoryItems(titlse: allTitles)
                                            dataManager.saveDataModelToUserDefaults(updatedDataModel)
                                            isSaved = true
                                        }
                                    }
                            }.padding(.bottom, 100)
                        }
                    }
                }.frame(maxWidth: .infinity, maxHeight:.infinity )
            }
        }
        .overlay(
            VStack{
                if optionManager.showCopiedAlert {
                    PopupView(optionManager: optionManager)
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .opacity(optionManager.showCopiedAlert ? 1 : 0)
                .animation(.easeInOut)
        )
        .navigationBarBackButtonHidden()
    }
}

struct CapView_Previews: PreviewProvider {
    static var previews: some View {
        CapView(optionManager: OptionManager(), card: Card(id: 0, image: UIImage(), title: ""), imageSel: .constant(nil))
    }
}

struct PopupView: View {
    
    @StateObject var optionManager : OptionManager
    
    var body: some View {
        VStack {
            Text(optionManager.alertTitle)
                .frame(width: 220, height: 50)
            
                .background(Color.white)
                .opacity(20)
                .foregroundColor(.blue)
                .cornerRadius(25)
                .font(.headline)
                .padding()
        }
    }
}

