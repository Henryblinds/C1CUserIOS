//
//  LocationView.swift
//  C1C (iOS)
//
//  Created by Henry Bryan Gasga on 6/30/22.
//

import SwiftUI

struct LocationView: View {
    var coachModel:CoachModel
    @ObservedObject var getProfile = FirebaseGetProfile()
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Text("\(coachModel.name) Location's")
                    .foregroundColor(.white)
                    .font(.title3)
                List {
                    ForEach(getProfile.clocations) { loc in
                        Text(loc.name)
                            .foregroundColor(.white)
                            .font(.title3)
                    }
                }
            }
        }
        .onAppear {
            getProfile.getLocation(coachId: coachModel.coachId)
        }
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView(coachModel: CoachModel())
    }
}
