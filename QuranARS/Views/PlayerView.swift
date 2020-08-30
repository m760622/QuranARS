// https://github.com/m760622/QuranARSApp
//  PlayerView.swift
//  QuranARS
// m7606225@gmail.com
//  Created by Mohammed Abunada on 2020-08-30.
// https://github.com/m760622

import SwiftUI

struct PlayerView: View {
    var body: some View {
        NavigationView{
            AudioPlayerView()
                .navigationBarTitle(Text("Quran Kareem القرآن الكريم"), displayMode: .inline)
        }//NavigationView
    }//body
}//PlayerView

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView()
    }
}
