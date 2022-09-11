//
//  MainScreen.swift
//  C1C (iOS)
//
//  Created by Henry Bryan Gasga on 6/28/22.
//

import SwiftUI

class ObjectSingleton : ObservableObject {
    static let shared = ObjectSingleton()
    @Published var movetohome = false
    @Published var closeBooking = false
    
    private init() { }
}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}

struct MainScreen: View {
    @ObservedObject var getProfile = FirebaseGetProfile()
    let config = URLSessionConfiguration.ephemeral
    init() {
        config.waitsForConnectivity = true
        config.allowsCellularAccess = true
    }
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                Color(.black).edgesIgnoringSafeArea(.all)
                VStack {
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 350.0, height: 350.0)
                    Spacer()
                    VStack {
                        NavigationLink(destination: MyRecordsView()) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 30.0)
                                    .fill(Color(hex: 0x062434))
                                Text("My Records")
                                    .foregroundColor(.white)
                            }
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                        }
                        NavigationLink(destination: SearchCoachView()) {//SearchCoachView()
                            ZStack {
                                RoundedRectangle(cornerRadius: 30.0)
                                    .fill(Color(hex: 0x062434))
                                Text("Search Coach")
                                    .foregroundColor(.white)
                            }
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                        }
//                        .simultaneousGesture(TapGesture().onEnded{
//                            getProfile.book(coachId: "thisCoachId", name: "Henry", email: "henry.dev09@gmail.com", number: "09088950793", date: "10/09/1988", note: "thisNote")
//                        })
                    }
                }
                
            }
        }
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}


