//
//  CoachDetailsView.swift
//  C1C (iOS)
//
//  Created by Henry Bryan Gasga on 6/30/22.
//

import SwiftUI
import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseDatabase

struct CoachProfileModel: Identifiable, Hashable {
    var id: UUID = UUID()
    var cprofileId: String = ""
    var name: String = ""
}

struct CoachLocModel:Identifiable {
    var id: UUID = UUID()
    var cpLocId: String = ""
    var name: String = ""
}

struct CoachSocModel:Identifiable {
    var id: UUID = UUID()
    var cpSocId: String = ""
    var name: String = ""
}

struct RatingModel:Identifiable {
    var id: UUID = UUID()
    var rateId: String = ""
    var coachId: String = ""
    var name: String = ""
    var rate: String = ""
    var review: String = ""
    var dateBook: String = ""
}

struct BookingModel:Identifiable {
    var id: UUID = UUID()
    var bookId: String = ""
    var coachId: String = ""
    var name: String = ""
    var email: String = ""
    var number: String = ""
    var date: String = ""
    var notes: String = ""
}

struct BookingData {
    var bookId: NSString = ""
    var coachId: NSString = ""
    var name: NSString = ""
    var email: NSString = ""
    var number: NSString = ""
    var date: NSString = ""
    var notes: NSString = ""
}

struct RecordModel:Identifiable {
    var id: UUID = UUID()
    var coach: CoachModel? = nil
    var booking: BookingModel? = nil
}

extension List {
    var profileId: String {
        "profileId"
    }
}

class FirebaseGetProfile : ObservableObject {
    @Published var ref: DatabaseReference! = Database.database().reference()
    @Published var cprofiles = [CoachProfileModel]()
    @Published var clocations = [CoachLocModel]()
    @Published var cSocials = [CoachSocModel]()
    @Published var cRatings = [RatingModel]()
    @Published var cBooking = [BookingData]()
    @Published var cId: String = ""
    
//    init() {
//        getProfile(coachId: cId)
//    }
    
    
    
    func book(coachId: String, name: String,email: String, number: String, date: String, note: String) {
        
        let refBook = self.ref.child("booking").childByAutoId()
        let key = refBook.key
        let newModel = BookingData(
            bookId: getOptionVal(mystr:key!) as NSString, coachId: coachId as NSString, name: name as NSString, email: email as NSString, number: number as NSString, date: date as NSString, notes: note as NSString
        )
        let dict = [
            "name": name,
            "bookId": getOptionVal(mystr:key!),
            "coachId": coachId,
            "email": email,
            "number": number,
            "date": date,
            "notes": note
        ]
        var dict2 = [Any]()
        
        self.ref.child("booking").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                for child in snapshot.children.allObjects as! [DataSnapshot] {
                    guard let restDict = child.value as? [String: Any] else { continue }
                    let name2 = restDict["name"] as? String
                    let bookId2 = restDict["bookId"] as? String
                    let coachId2 = restDict["coachId"] as? String
                    let email2 = restDict["email"] as? String
                    let number2 = restDict["number"] as? String
                    let date2 = restDict["date"] as? String
                    let dnotes2 = restDict["notes"] as? String
                    let dict23 = [
                        "name": name2,
                        "bookId": bookId2,
                        "coachId": coachId2,
                        "email": email2,
                        "number": number2,
                        "date": date2,
                        "notes": dnotes2
                    ] as [String : Any]
                    dict2.append(dict23)
                }
                dict2.append(dict)
                self.ref.child("booking").setValue(dict2)

            } else {
                dict2.append(dict)
                self.ref.child("booking").setValue(dict2)
            }

        })
    }
    
    func getProfile(coachId: String) {
        self.cprofiles.removeAll()
        self.ref.child("coachprofile/\(coachId)").observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                guard let restDict = child.value as? [String: Any] else { continue }
                let name = restDict["name"] as? String
                let cprofileId = restDict["cprofileId"] as? String
//                print(getOptionVal(mystr:name))
                self.cprofiles.append(CoachProfileModel(
                    cprofileId: getOptionVal(mystr:cprofileId), name: getOptionVal(mystr:name)
                ))
            }
        })
    }
    
    func getLocation(coachId: String) {
        self.ref.child("coachlocation/\(coachId)").observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                guard let restDict = child.value as? [String: Any] else { continue }
                let name = restDict["name"] as? String
                let cpLocId = restDict["cpLocId"] as? String
                self.clocations.append(CoachLocModel(
                    cpLocId: getOptionVal(mystr:cpLocId), name: getOptionVal(mystr:name)
                ))
            }
        })
    }
    
    func getSocial(coachId: String) {
        self.ref.child("coachsocial/\(coachId)").observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                guard let restDict = child.value as? [String: Any] else { continue }
                let name = restDict["name"] as? String
                let cpSocId = restDict["cpSocId"] as? String
                self.cSocials.append(CoachSocModel(
                    cpSocId: getOptionVal(mystr:cpSocId), name: getOptionVal(mystr:name)
                ))
            }
        })
    }
    
    func getRating(coachId: String) {
        self.ref.child("rating/\(coachId)").observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                guard let restDict = child.value as? [String: Any] else { continue }
                let name = restDict["name"] as? String
                let rateId = restDict["rateId"] as? String
                let coachId = restDict["coachId"] as? String
                let rate = restDict["rate"] as? String
                let review = restDict["review"] as? String
                let dateBook = restDict["dateBook"] as? String
                self.cRatings.append(RatingModel(
                    rateId: getOptionVal(mystr:rateId), coachId: getOptionVal(mystr:coachId), name: getOptionVal(mystr:name), rate: getOptionVal(mystr:rate), review: getOptionVal(mystr:review), dateBook: getOptionVal(mystr:dateBook)
                ))
            }
        })
    }
}

struct CoachDetailsView: View {
    var coachModel:CoachModel
    @ObservedObject var getProfile = FirebaseGetProfile()
    @ObservedObject var firebaseManager = FirebaseManager()
    @StateObject var closeBook = ObjectSingleton.shared
    var coachProfiles: [CoachProfileModel] {
            getProfile.getProfile(coachId: coachModel.coachId)
            return self.getProfile.cprofiles
        }
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    init(cm: CoachModel) {
        self.coachModel = cm
        
    }
    
    var body: some View {
        ScrollView {
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 20.0)
                    .fill(Color(hex: 0x062434))
                VStack(alignment: .leading,spacing: 0) {
                    VStack(alignment: .leading,spacing: 0) {
                        Text(coachModel.name)
                            .foregroundColor(.white)
                            .font(.largeTitle)
                        Text(coachModel.type)
                            .foregroundColor(.white.opacity(0.7))
                            .font(.title3)
                        Text("Email:")
                            .foregroundColor(.white.opacity(0.7))
                            .font(.title3)
                        Text(coachModel.email)
                            .foregroundColor(.white)
                            .font(.title3)
                        Text("Number:")
                            .foregroundColor(.white.opacity(0.7))
                            .font(.title3)
                        Text(coachModel.number)
                            .foregroundColor(.white)
                            .font(.title3)
                        Text("Rate Per session:")
                            .foregroundColor(.white.opacity(0.7))
                            .font(.title3)
                        Text("P\(coachModel.rate)")
                            .foregroundColor(.white)
                            .font(.title3)
                        Text("Profile:")
                            .foregroundColor(.white.opacity(0.7))
                            .font(.title3)
                        NavigationLink(destination: ProfileView(coachModel: self.coachModel)) {
                            Text("View Profile")
                                .foregroundColor(.blue)
                                .font(.title3)
                        }
                    }
                    VStack(alignment: .leading,spacing: 0) {
                        List {
                            ForEach(getProfile.cprofiles) { test in
//                                Text("waaaa")
                            }
//                            ForEach(0..<3){ index in
//                                Text("waaaa")
//                            }
                        }.onAppear(perform: {
                            self.getProfile.getProfile(coachId: coachModel.coachId)
                        })
                    }
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Location:")
                            .foregroundColor(.white.opacity(0.7))
                            .font(.title3)
                        NavigationLink(destination: LocationView(coachModel: self.coachModel)) {
                            Text("View Location")
                                .foregroundColor(.blue)
                                .font(.title3)
                        }
                        Text("Social Media:")
                            .foregroundColor(.white.opacity(0.7))
                            .font(.title3)
                        NavigationLink(destination: SocialView(coachModel: self.coachModel)) {
                            Text("View Social Media")
                                .foregroundColor(.blue)
                                .font(.title3)
                        }
                        Text("Rating and Review:")
                            .foregroundColor(.white.opacity(0.7))
                            .font(.title3)
                        NavigationLink(destination: RatingView(coachModel: self.coachModel)) {
                            Text("View Rating and Review")
                                .foregroundColor(.blue)
                                .font(.title3)
                        }
                    }

                }
                .padding(EdgeInsets(top: 13, leading: 13, bottom:13, trailing: 13))
            }
            
            NavigationLink(destination: BookView(coachModel: self.coachModel)) {
                ZStack {
                    RoundedRectangle(cornerRadius: 30.0)
                        .fill(Color(hex: 0x062434))
                    Text("Book Coach")
                        .foregroundColor(.white)
                        .padding(EdgeInsets(top: 13, leading: 13, bottom: 13, trailing: 13))
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
            }
            .simultaneousGesture(TapGesture().onEnded{
                self.closeBook.closeBooking = false
            })
        }
        .onAppear(perform: {
            if self.closeBook.closeBooking {
                self.mode.wrappedValue.dismiss()
            }
        })
    }
}

struct CoachDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        CoachDetailsView(cm: CoachModel())
    }
}
