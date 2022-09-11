//
//  SuccessBookView.swift
//  C1C (iOS)
//
//  Created by Henry Bryan Gasga on 7/8/22.
//

import SwiftUI

struct SuccessBookView: View {
    var bookModel:BookingModel
    var coachModel:CoachModel
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var body: some View {
        ScrollView {
            ZStack(alignment: .topLeading) {
                VStack(alignment: .center, spacing: 10) {
                    Text("Booking Successful")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                    
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 20.0)
                            .fill(Color(hex: 0x062434))
                        VStack(alignment: .leading,spacing: 5) {
                            Text(coachModel.name)
                                .foregroundColor(.white)
                                .font(.largeTitle)
                            Text(coachModel.type)
                                .foregroundColor(.white.opacity(0.7))
                                .font(.title3)
                            Text("Rate Per session:")
                                .foregroundColor(.white.opacity(0.7))
                                .font(.title3)
                            Text("P\(coachModel.rate)")
                                .foregroundColor(.white)
                                .font(.title3)
                        }
                        .padding()
                    }
                    .padding()
                    
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 20.0)
                            .fill(Color(hex: 0x062434))
                        VStack(alignment: .leading,spacing: 5) {
                            Text("Name:")
                                .foregroundColor(.white.opacity(0.7))
                                .font(.title3)
                            Text(bookModel.name)
                                .foregroundColor(.white)
                                .font(.title3)
                            Text("Email:")
                                .foregroundColor(.white.opacity(0.7))
                                .font(.title3)
                            Text(bookModel.email)
                                .foregroundColor(.white)
                                .font(.title3)
                            Text("Number:")
                                .foregroundColor(.white.opacity(0.7))
                                .font(.title3)
                            Text(bookModel.number)
                                .foregroundColor(.white)
                                .font(.title3)
                            Text("Date Booked:")
                                .foregroundColor(.white.opacity(0.7))
                                .font(.title3)
                            Text(bookModel.date)
                                .foregroundColor(.white)
                                .font(.title3)
                            
                        }
                        .padding()
                    }
                    .padding()
                    ZStack {
                        RoundedRectangle(cornerRadius: 30.0)
                            .fill(Color(hex: 0x062434))
                        Text("Done")
                            .foregroundColor(.white)
                            .padding(EdgeInsets(top: 13, leading: 13, bottom: 13, trailing: 13))
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                    .simultaneousGesture(TapGesture().onEnded{
                        self.mode.wrappedValue.dismiss()
                    })
                    .padding()
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct SuccessBookView_Previews: PreviewProvider {
    static var previews: some View {
        SuccessBookView(bookModel: BookingModel(), coachModel: CoachModel())
    }
}
