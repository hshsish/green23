
import SwiftUI

struct SubscriptionsView: View {
    var body: some View {
        VStack{
            
            
            
            Text("PHOTOCAP Plus+")
                .font(.custom("MontserratRoman-Bold", size: 20))
                .padding()
            
            Spacer()
            
            Text("unclock ...")
                .padding()
            
            Text("unclock ...")
                .padding()
            
            Text("unclock ...")
                .padding()
            
            Spacer()
            
            Button {
                
            } label: {
                Text("Join Photocap Plus")
            }   .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.blue)
                .accentColor(.white)
                .cornerRadius(5)
                .padding( .bottom, 80)
                .padding([.leading, .trailing], 10)
            
        }
    }
}

struct SubscriptionsView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionsView()
    }
}
