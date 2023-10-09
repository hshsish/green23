
import SwiftUI

struct UserCapView: View {
    var body: some View {
        HStack{
            Text("photocap")
                .font(.custom("MontserratRoman-Bold", size: 25))
            
            Spacer()
            
//            Button {
//
//            } label: {
//                Text("66")
//                Image(systemName: "sparkle")
//
//            } .font(.custom("MontserratRoman-Bold", size: 25))
//
//            ZStack{
//                Button {
//
//                } label: {
//                    Color.blue
//
//                        .frame(width: 36 , height: 36)
//                        .cornerRadius(30)
//                        .clipped()
//
//                }
//
//                Button {
//
//                } label: {
//                    Image("freshDoggy")
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(width: 32 , height: 32)
//                        .cornerRadius(30)
//                        .clipped()
//
//                }
//            }
        }.padding()
    }
}
struct UserCapView_Previews: PreviewProvider {
    static var previews: some View {
        UserCapView()
    }
}
