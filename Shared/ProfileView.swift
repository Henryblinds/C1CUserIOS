//
//  ProfileView.swift
//  C1C (iOS)
//
//  Created by Henry Bryan Gasga on 6/30/22.
//

import SwiftUI

struct ProfileView: View {
    var coachModel:CoachModel
    @ObservedObject var getProfile = FirebaseGetProfile()
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Text("\(coachModel.name) Profile's")
                    .foregroundColor(.white)
                    .font(.title3)
                Text("\(self.getProfile.cprofiles.count) count")
                    .foregroundColor(.white)
                    .font(.title3)
                List {
                    ForEach(self.getProfile.cprofiles){ profile in
                        Text(profile.name)
                            .foregroundColor(.white)
                            .font(.title3)
                    }
                }
            }
        }
        .onAppear {
            self.getProfile.getProfile(coachId: coachModel.coachId)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(coachModel: CoachModel())
    }
}
