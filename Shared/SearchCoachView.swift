//
//  SearchCoachView.swift
//  C1C (iOS)
//
//  Created by Henry Bryan Gasga on 6/28/22.
//

import SwiftUI
import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseDatabase

class AppSetting: ObservableObject {
    static let shared = AppSetting()
    private init() {}

    @Published var coachId: String = ""
}

struct CoachModel: Identifiable {
    var id: UUID = UUID()
    var coachId: String = ""
    var name: String = ""
    var type: String = ""
    var email: String = ""
    var number: String = ""
    var rate: String = ""
}

extension View {
    func Print(_ vars: Any...) -> some View {
        for v in vars { print(v) }
        return EmptyView()
    }
}

class FirebaseManager : ObservableObject {
    @Published var ref: DatabaseReference! = Database.database().reference()
    @Published var coaches = [CoachModel]()
    @Published var booking = [BookingModel]()
    init() {
        makeFirebaseCall()
    }
    func makeFirebaseCall() {
        self.ref.child("coaches").observeSingleEvent(of: .value, with: { (snapshot) in

            for child in snapshot.children.allObjects as! [DataSnapshot] {
                guard let restDict = child.value as? [String: Any] else { continue }
                let username = restDict["name"] as? String
                let coachId = restDict["coachId"] as? String
                let type = restDict["type"] as? String
                let email = restDict["email"] as? String
                let number = restDict["number"] as? String
                let rate = restDict["rate"] as? String
                self.coaches.append(CoachModel(
                    coachId: getOptionVal(mystr:coachId), name: getOptionVal(mystr:username), type: getOptionVal(mystr:type), email: getOptionVal(mystr:email), number: getOptionVal(mystr:number), rate: getOptionVal(mystr:rate)
                ))
            }
        })
    }
    func getRecords() {
        self.ref.child("booking").observeSingleEvent(of: .value, with: { (snapshot) in

            for child in snapshot.children.allObjects as! [DataSnapshot] {
                guard let restDict = child.value as? [String: Any] else { continue }
                let bookId = restDict["bookId"] as? String
                let coachId = restDict["coachId"] as? String
                let name = restDict["name"] as? String
                let email = restDict["email"] as? String
                let number = restDict["number"] as? String
                let date = restDict["date"] as? String
                let notes = restDict["notes"] as? String
                self.booking.append(BookingModel(
                    bookId: getOptionVal(mystr:bookId), coachId: getOptionVal(mystr:coachId), name: getOptionVal(mystr:name), email: getOptionVal(mystr:email), number: getOptionVal(mystr:number), date: getOptionVal(mystr:date), notes: getOptionVal(mystr:notes)
                ))
            }
        })
    }
}

func getOptionVal(mystr: Optional<Any?>) -> String {
    mystr.flatMap { str in
        return str
    } as! String
}

func getOptionVal2(mystr: Optional<Any?>) -> NSString {
    mystr.flatMap { str in
        return str
    } as! NSString
}

struct SearchCoachView: View {
    @State var search: String = ""
//    @StateObject private var firebaseManager = FirebaseManager()
    @ObservedObject var firebaseManager = FirebaseManager()
    var searchResults: [CoachModel] {
            if search.isEmpty {
                return self.firebaseManager.coaches
            } else {
                return self.firebaseManager.coaches.filter { coach in
                    coach.name.contains(search)
                }
            }
        }
    var body: some View {
        let binding = Binding<String>(get: {
                    self.search
                }, set: {
                    self.search = $0
                })
        ZStack(alignment: .top) {
            Color(.black).edgesIgnoringSafeArea(.all)
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 30.0)
                        .fill(Color(hex: 0x062434))
                    TextField("Search Here..", text: binding)
                        .foregroundColor(.white)
                        .padding()
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                Spacer()
                List {
                    ForEach(searchResults) { coach in
                        NavigationLink(destination: CoachDetailsView(cm: coach)) {
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 20.0)
                                    .fill(Color(hex: 0x062434))
                                VStack(alignment: .leading) {
                                    Text(coach.name)
                                        .foregroundColor(.white)
                                        .font(.title)
                                    if coach.type == "Both" {
                                        Text("In-Person, Online")
                                            .foregroundColor(.white.opacity(0.7))
                                            .font(.title3)
                                    } else {
                                        Text(coach.type)
                                            .foregroundColor(.white.opacity(0.7))
                                            .font(.title3)
                                    }
                                    Text("Rate Per session:")
                                        .foregroundColor(.white.opacity(0.7))
                                        .font(.title3)
                                    Text("P\(coach.rate)")
                                        .foregroundColor(.white)
                                        .font(.title3)
                                }
                                .padding(EdgeInsets(top: 0, leading: 13, bottom: 0, trailing: 13))
                            }
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 120)
                        }
                    }
                }
            }.onAppear {
//                firebaseManager.makeFirebaseCall()
            }
        }
    }
}

struct SearchCoachView_Previews: PreviewProvider {
    static var previews: some View {
        SearchCoachView()
    }
}
