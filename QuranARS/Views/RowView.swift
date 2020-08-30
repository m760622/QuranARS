// https://github.com/m760622/QuranARSApp
//  RowView.swift
//  QuranARS
// m7606225@gmail.com
//  Created by Mohammed Abunada on 2020-08-30.
// https://github.com/m760622

import SwiftUI

struct RowView : View {
    var mediaRow : MediaStruct
    var index: Int
    @ObservedObject var observObj: ObservObj = .shared
    var body: some View{
        VStack{
            VStack{
                Button("\(mediaRow.title) \(mediaRow.titleAr)", action: {
                    observObj.current = index
                    observObj.ChangeSongs()
                    observObj.playing = true
                })
                .multilineTextAlignment(.center)
                .frame(width: observObj.screenWidth, height: 30)
                .background(Color.blue.opacity(0.5))
                .foregroundColor(.white)
                .clipShape(Capsule())
            }//VStack
            .cornerRadius(15)
        }//VStack
    }//body
}//RowView
struct RowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RowView(mediaRow: mediaList[0], index: 0)
            RowView(mediaRow: mediaList[0], index: 0)
                .preferredColorScheme(.dark)
        }
    }
}
