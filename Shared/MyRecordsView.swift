//
//  MyRecordsView.swift
//  C1C (iOS)
//
//  Created by Henry Bryan Gasga on 7/16/22.
//

import SwiftUI

struct MyRecordsView: View {
    @ObservedObject var firebaseManager = FirebaseManager()
    @State var search: String = ""
    @State var showList: Bool = false
    var searchResults: [RecordModel] {
            if search.isEmpty {
                return [RecordModel]()
            } else {
                let myBooks = self.firebaseManager.booking.filter { booked in
                    booked.email.contains(search)
                }
                var records = [RecordModel]()
                
                for booked in myBooks {
                    for coach in self.firebaseManager.coaches {
                        if booked.coachId == coach.coachId {
                            records.append(RecordModel(
                                coach: coach, booking: booked
                            ))
                        }
                    }
                }
                
                return records
            }
        }
    var body: some View {
        let binding = Binding<String>(get: {
                    self.search
                }, set: {
                    self.search = $0
                })
        ScrollView {
            ZStack(alignment: .top) {
                Color(.black).edgesIgnoringSafeArea(.all)
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 30.0)
                            .fill(Color(hex: 0x062434))
                        TextField("Email Here..", text: binding)
                            .foregroundColor(.white)
                            .padding()
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                    Spacer()
                    if showList {
                        List {
                            ForEach(searchResults) { record in
                                NavigationLink(destination: CoachDetailsView(cm: record.coach!)) {
                                    ZStack(alignment: .leading) {
                                        RoundedRectangle(cornerRadius: 20.0)
                                            .fill(Color(hex: 0x062434))
                                        VStack(alignment: .leading) {
                                            Text(record.coach!.name)
                                                .foregroundColor(.white)
                                                .font(.title)
                                            if record.coach!.type == "Both" {
                                                Text("In-Person, Online")
                                                    .foregroundColor(.white.opacity(0.7))
                                                    .font(.title3)
                                            } else {
                                                Text(record.coach!.type)
                                                    .foregroundColor(.white.opacity(0.7))
                                                    .font(.title3)
                                            }
                                            
                                            Text("Rate Per session:")
                                                .foregroundColor(.white.opacity(0.7))
                                                .font(.title3)
                                            Text("P\(record.coach!.rate)")
                                                .foregroundColor(.white)
                                                .font(.title3)
                                        }
                                        .padding(EdgeInsets(top: 0, leading: 13, bottom: 0, trailing: 13))
                                    }
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 120)
                                }
                            }
                        }
                    }
                }
            }
        }
        .onAppear(perform: {
            firebaseManager.getRecords()
        })
    }
}

struct MyRecordsView_Previews: PreviewProvider {
    static var previews: some View {
        MyRecordsView()
    }
}
