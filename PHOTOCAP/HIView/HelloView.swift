
import SwiftUI

struct HelloView: View {
    
    @State var readyToNavigate : Bool = false
    @EnvironmentObject var dataManager : DataManager
    
    var body: some View {
        VStack{
            ZStack{
                NavigationView {
                    VStack(alignment: .leading){
                        
                        Text("photocap")
                            .font(.custom("MontserratRoman-Bold", size: 35))
                            .multilineTextAlignment(.leading)
                            .padding(.top, 70)
                            .padding(.leading, 10)
                        
                        Spacer()
                        
                        Text("Welcome to the Instagram photo description app!\n\nEnhance your publications with our unique descriptions.\n\nLet's get started!")
                            .font(.custom("MontserratRoman-Regular", size: 25))
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity)
        
                            .padding([.leading, .trailing], 10)
                        NavigationLink(destination: HelloViewTwo(datamodel: DataModel(favourites: [], history: [], isFirstLaunch: Bool()), dataManager: dataManager)
                                       ,
                                       isActive: $readyToNavigate) {
                            EmptyView()
                        }
                        Spacer()
                        Button {
                            readyToNavigate = true
                        } label: {
                            HStack{
                                Text("Next")
                                    .font(.custom("MontserratRoman-Bold", size: 20))
                                
                                Image(systemName: "arrow.right")
                                
                                    .font(.custom("MontserratRoman-Bold", size: 20))
                            }         .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue)
                        .accentColor(.white)
                        .cornerRadius(5)
                        .padding( .bottom, 80)
                        .padding([.leading, .trailing], 10)
                    }.frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct HelloView_Previews: PreviewProvider {
    static var previews: some View {
        HelloView()
    }
}
