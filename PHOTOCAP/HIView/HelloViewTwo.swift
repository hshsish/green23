
import SwiftUI

struct HelloViewTwo: View {
    
    @State var readyToNavigate : Bool = false
    @State var datamodel : DataModel
    @ObservedObject  var dataManager : DataManager
    @State private var image: UIImage?
    
    var body: some View {
        VStack{
            
            VStack(alignment: .leading){
                Text("photocap")
                    .font(.custom("MontserratRoman-Bold", size: 35))
                    .multilineTextAlignment(.leading)
                    .padding(.top, 70)
                    .padding(.leading, 10)
                
                Spacer()
                
                Text("• Select a photo from your gallery. \n\n• We will generate 10 descriptions based on the content of the photo.")
                    .multilineTextAlignment(.leading)
                    .padding([.leading, .bottom], 10)
                    .padding(.bottom, 20)
                    .font(.custom("MontserratRoman-Regular", size: 25))
            }
            
            VStack(alignment: .center){
                
                Image("alonewithdog")
                    .resizable()
                    .frame(width: 341, height: 228)
                    .cornerRadius(15)
                    .padding(.top, 30)
                
                Text("Collecting moments together like seashells on the seashore 🐚✨")
                    .font(.custom("MontserratRoman-Regular", size: 15))
                    .frame(width: 343.0,height: 40)
                    .multilineTextAlignment(.leading)
                
                    .padding(.bottom, 30)
                
                NavigationLink(destination: ContentView(cards: Card(id: 0, image: UIImage(), title: ""), datamodel: DataModel(favourites: [], history: [], isFirstLaunch: Bool())),
                               isActive: $readyToNavigate) {
                    EmptyView()
                }
                
                Spacer()
                Button {
                    readyToNavigate = true
                    dataManager.data.isFirstLaunch = false
                    dataManager.saveDataModelToUserDefaults(dataManager.data)
                    
                } label: {
                    HStack{
                        Text("Next")
                            .font(.custom("MontserratRoman-Bold", size: 20))
                        
                        Image(systemName: "arrow.right")
                        
                            .font(.custom("MontserratRoman-Bold", size: 20))
                    }         .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
                .frame(height: 50)
                .background(Color.blue)
                .accentColor(.white)
                .cornerRadius(5)
                .padding( .bottom, 80)
                .padding([.leading, .trailing], 10)
                
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationBarBackButtonHidden()
    }
}

struct HelloViewTwo_Previews: PreviewProvider {
    static var previews: some View {
        HelloViewTwo(datamodel: DataModel(favourites: [], history: [], isFirstLaunch: Bool()), dataManager: DataManager())
    }
}

