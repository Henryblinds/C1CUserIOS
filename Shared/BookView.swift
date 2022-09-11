//
//  BookView.swift
//  C1C (iOS)
//
//  Created by Henry Bryan Gasga on 6/30/22.
//

import SwiftUI

struct BookView: View {
    var coachModel:CoachModel
    @State var name: String = ""
    @State var email: String = ""
    @State var number: String = ""
    @State var note: String = ""
    @State var datebook: String = ""
    @State var showSheet:Bool = false
    @State var goaldate: Date = Date()
    @State var ShowButton: Bool = false
    @State var TextFieldVal: Bool = false
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @ObservedObject var getProfile = FirebaseGetProfile()
    @StateObject var closeBook = ObjectSingleton.shared
    let config = URLSessionConfiguration.ephemeral
    
    init (coachModel: CoachModel) {
        config.waitsForConnectivity = true
        config.allowsCellularAccess = true
        self.coachModel = coachModel
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        datebook = formatter.string(from: Date())
        UITextView.appearance().backgroundColor = .clear
    }
    
    func validate() {
        
    }
    
    var body: some View {
        let bindingName = Binding<String>(get: {
                    self.name
                }, set: {
                    self.name = $0
                    if self.name != "" && self.email != "" && self.number != "" {
                        ShowButton = true
                    } else {
                        ShowButton = false
                    }
                })
        let bindingEmail = Binding<String>(get: {
                    self.email
                }, set: {
                    self.email = $0
                    if self.name != "" && self.email != "" && self.number != "" {
                        ShowButton = true
                    } else {
                        ShowButton = false
                    }
                })
        let bindingNumber = Binding<String>(get: {
                    self.number
                }, set: {
                    self.number = $0
                    let formatter = DateFormatter()
                    formatter.dateFormat = "MM-dd-yyyy"
                    self.datebook = formatter.string(from: Date.now)
                    if self.name != "" && self.email != "" && self.number != "" {
                        ShowButton = true
                    } else {
                        ShowButton = false
                    }
                })
        ScrollView {
            ZStack(alignment: .top) {
                Color(.black).edgesIgnoringSafeArea(.all)
                VStack(alignment: .leading) {
                    Text("Book For")
                        .foregroundColor(.white).opacity(0.5)
                        .font(.body)
                    Text(coachModel.name)
                        .foregroundColor(.white)
                        .font(.largeTitle)
                    VStack(alignment: .leading) {
                        Text("Your Name")
                            .foregroundColor(.blue)
                            .font(.title3)
                        ZStack {
                            RoundedRectangle(cornerRadius: 20.0)
                                .fill(Color(hex: 0x3B9DD7))
                            TextField("", text: bindingName)
                                .foregroundColor(.white)
                                .padding()
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                        Text("Your Email")
                            .foregroundColor(.blue)
                            .font(.title3)
                        ZStack {
                            RoundedRectangle(cornerRadius: 20.0)
                                .fill(Color(hex: 0x3B9DD7))
                            TextField("", text: bindingEmail)
                                .foregroundColor(.white)
                                .padding()
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                        Text("Your Number")
                            .foregroundColor(.blue)
                            .font(.title3)
                        ZStack {
                            RoundedRectangle(cornerRadius: 20.0)
                                .fill(Color(hex: 0x3B9DD7))
                            TextField("", text: bindingNumber)
                                .foregroundColor(.white)
                                .padding()
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                        Text("Notes")
                            .foregroundColor(.blue)
                            .font(.title3)
                        ZStack {
                            RoundedRectangle(cornerRadius: 20.0)
                                .fill(Color(hex: 0x3B9DD7))
                            TextEditor(text: $note)
                                .frame(minHeight: 50.0)
                                .foregroundColor(.white)
                                .background(Color(hex: 0x3B9DD7))
                                .padding()
                                .submitLabel(.done)
                        }
                        Text("Date of Booking")
                            .foregroundColor(.blue)
                            .font(.title3)
                        ZStack {
                            DatePicker(
                                "Set Date",
                                selection: Binding<Date>(get: {self.goaldate}, set: {
                                    self.goaldate = $0
                                    let formatter = DateFormatter()
                                    formatter.dateFormat = "MM-dd-yyyy"
                                    datebook = formatter.string(from: self.goaldate)
                                    print(self.name)
                                    print(self.email)
                                    print(self.number)
                                    print(formatter.string(from: self.goaldate))
                                }),
                                displayedComponents: .date
                            )
                                .foregroundColor(.white)
                                .padding()
                        
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                        
                    }
                    if ShowButton {
                        NavigationLink(destination: SuccessBookView(bookModel: BookingModel(coachId: self.coachModel.coachId, name: self.name, email: self.email, number: self.number, date: self.datebook, notes: self.note), coachModel: self.coachModel)) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 30.0)
                                    .fill(Color(hex: 0x062434))
                                Text("Book")
                                    .foregroundColor(.white)
                            }
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
    //                        .padding(EdgeInsets(top: 13, leading: 13, bottom: 13, trailing: 13))
                        }
                        .simultaneousGesture(TapGesture().onEnded{
                            self.closeBook.closeBooking = true
                            getProfile.book(coachId: self.coachModel.coachId, name: self.name, email: self.email, number: self.number, date: self.datebook, note: self.note)
                        })
                        
                    }
                }
                .padding()
                Spacer()
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action : {
                self.mode.wrappedValue.dismiss()
            }){
                Text("Back")
                    .foregroundColor(.blue)
            })
            .onAppear(perform: {
                if self.closeBook.closeBooking {
                    self.mode.wrappedValue.dismiss()
                }
            })
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
        }
    }
}

struct BookView_Previews: PreviewProvider {
    static var previews: some View {
        BookView(coachModel: CoachModel())
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

//public extension TextField {
//    func addDoneButtonOnKeyboard() -> some View
//    {
//        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
//        doneToolbar.barStyle = .default
//        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: nil, action: nil)
//        doneToolbar.items = [flexSpace, done]
//        doneToolbar.sizeToFit()
//        return self.introspectTextField
//        {
//            text_field in
//            text_field.inputAccessoryView = doneToolbar
//            done.target = text_field
//            done.action = #selector( text_field.resignFirstResponder )
//        }
//    }
//}


