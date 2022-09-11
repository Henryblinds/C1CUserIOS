//
//  RatingView.swift
//  C1C (iOS)
//
//  Created by Henry Bryan Gasga on 6/30/22.
//

import SwiftUI

struct RatingView: View {
    var coachModel:CoachModel
    @ObservedObject var getProfile = FirebaseGetProfile()
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Text("\(coachModel.name) Rate and Review")
                    .foregroundColor(.white)
                    .font(.title3)
                List {
                    ForEach(getProfile.cRatings) { loc in
                        HStack {
                            Text("From:")
                                .foregroundColor(.white)
                                .font(.title3)
                            Text(loc.name)
                                .foregroundColor(.white)
                                .font(.title3)
                        }
                        HStack {
                            Text("Rate:")
                                .foregroundColor(.white)
                                .font(.title3)
                            Text("\(loc.rate)/5")
                                .foregroundColor(.white)
                                .font(.title3)
                        }
                        Text(loc.review)
                            .foregroundColor(.white)
                            .font(.title3)
                    }
                }
            }
        }
        .onAppear {
            getProfile.getRating(coachId: coachModel.coachId)
        }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(coachModel: CoachModel())
    }
}
