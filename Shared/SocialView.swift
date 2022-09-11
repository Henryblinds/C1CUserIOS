//
//  SocialView.swift
//  C1C (iOS)
//
//  Created by Henry Bryan Gasga on 6/30/22.
//

import SwiftUI

struct SocialView: View {
    var coachModel:CoachModel
    @ObservedObject var getProfile = FirebaseGetProfile()
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Text("\(coachModel.name) Social Media")
                    .foregroundColor(.white)
                    .font(.title3)
                List {
                    ForEach(getProfile.cSocials) { loc in
                        Text(loc.name)
                            .foregroundColor(.white)
                            .font(.title3)
                    }
                }
            }
        }
        .onAppear {
            getProfile.getSocial(coachId: coachModel.coachId)
        }
    }
}

struct SocialView_Previews: PreviewProvider {
    static var previews: some View {
        SocialView(coachModel: CoachModel())
    }
}
