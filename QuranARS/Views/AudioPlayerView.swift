// https://github.com/m760622/QuranARSApp
//  AudioPlayerView.swift
//  QuranARS
// m7606225@gmail.com
//  Created by Mohammed Abunada on 2020-08-30.
// https://github.com/m760622

import SwiftUI
import AVKit

struct AudioPlayerView : View {
    @ObservedObject var soundObservObj: ObservObj = .shared
    @State var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    var body : some View{
        VStack(spacing: 15){
            Text("Abdul Rashid Ali Sufi عبد الرشيد علي صوفي")
                .font(.headline)
                .foregroundColor(.blue)
                .multilineTextAlignment(.trailing)
            
            Text(soundObservObj.title  + soundObservObj.titleAr)
                .font(.headline)
                .multilineTextAlignment(.trailing)
            
            List(mediaList, id:\.self) { mediaItem in
                let index = mediaList.firstIndex(of: mediaItem)
                RowView(mediaRow: mediaItem, index: index!)
            }//List
            PlayerControlView()
        }//VStack
        .padding()
        
        .onReceive(timer) { (_) in
            if soundObservObj.audioPlayer.isPlaying{
                let screen = UIScreen.main.bounds.width - 30
                let value = soundObservObj.audioPlayer.currentTime / soundObservObj.audioPlayer.duration
                soundObservObj.width = screen * CGFloat(value)
                if Int(soundObservObj.audioPlayer.currentTime) == Int(soundObservObj.audioPlayer.duration) && soundObservObj.RepeatAll {
                    soundObservObj.forwardFn()
                }
                if soundObservObj.Repeat {
                    soundObservObj.audioPlayer.numberOfLoops = -1 //Repeat loop
                }
            }//if soundObservObj.audioPlayer.isPlaying
            
        }//onReceive
        .onAppear {
            UITableView.appearance().separatorColor = .clear
            UITableView.appearance().showsVerticalScrollIndicator = false
            if let url = Bundle.main.path(forResource: mediaList[0].fileName, ofType: ""){
                do {
                    try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: [AVAudioSession.CategoryOptions.mixWithOthers])
                    soundObservObj.audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: url))
                } catch {
                    print("click sound fail")// couldn't load file :(
                }
            }//if let url
            soundObservObj.audioPlayer.delegate = soundObservObj.del
            soundObservObj.artWork = .init(count: 0)
            soundObservObj.getData()
            NotificationCenter.default.addObserver(forName: NSNotification.Name("Finish"), object: nil, queue: .main) { (_) in
                soundObservObj.finish = true
            }
        }//onAppear
    }//body
    
}//AudioPlayerView

struct AudioPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        AudioPlayerView()
    }
}
