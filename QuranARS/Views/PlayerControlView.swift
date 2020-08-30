// https://github.com/m760622/QuranARSApp
//  PlayerControlView.swift
//  QuranARS
// m7606225@gmail.com
//  Created by Mohammed Abunada on 2020-08-30.
// https://github.com/m760622

import SwiftUI

struct PlayerControlView: View {
    @ObservedObject var soundObservObj: ObservObj = .shared
    @State var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var audioTimeSlider: some View {
        ZStack(alignment: .leading) {
            Capsule().fill(Color.blue.opacity(0.2)).frame(height: 8)
            Capsule().fill(Color.red).frame(width: soundObservObj.width, height: 8)
                .gesture(DragGesture()
                            .onChanged({ (value) in
                                let x = value.location.x
                                soundObservObj.width = x
                            })
                            .onEnded({ (value) in
                                let x = value.location.x
                                let screen = UIScreen.main.bounds.width - 30
                                let percent = x / screen
                                soundObservObj.audioPlayer.currentTime = Double(percent) * soundObservObj.audioPlayer.duration
                            }))
        }//ZStack
        .padding(.top)
    }//audioTimeSlider
    
    var timeView: some View {
        HStack(spacing: UIScreen.main.bounds.width * 0.65 ) {
            if soundObservObj.audioPlayer != nil {
                Text(integerToTimeFn(timeIn: Int(soundObservObj.audioPlayer.currentTime)))
                Text(integerToTimeFn(timeIn: Int(soundObservObj.audioPlayer.duration)))
            }
        }
    }//timeView
    
    var playButtons: some View {
        HStack(spacing: UIScreen.main.bounds.width / 5 - 30){
            Button(action: soundObservObj.backwardFn ) {
                Image(systemName: "backward.fill").font(.title)
                    .foregroundColor(.gray)
            }
            Button(action: {
                soundObservObj.audioPlayer.currentTime -= 15
            }) {
                Image(systemName: "gobackward.15").font(.title)
                    .foregroundColor(.primary)
            }
            
            Button(action: soundObservObj.playPauseFn ) {
                Image(systemName: soundObservObj.playing && !soundObservObj.finish ? "pause.fill" : "play.fill")
                    .font(.title)
                    .foregroundColor(.green)
            }
            
            Button(action: {
                let increase = soundObservObj.audioPlayer.currentTime + 15
                if increase < soundObservObj.audioPlayer.duration{
                    soundObservObj.audioPlayer.currentTime = increase
                }
            }) {
                Image(systemName: "goforward.15").font(.title)
                    .foregroundColor(.primary)
            }
            Button(action: soundObservObj.forwardFn) {
                Image(systemName: "forward.fill").font(.title)
                    .foregroundColor(.gray)
            }
        }//HStack
        .padding(.top,15)
        .foregroundColor(.black)
    }//playButtons
    
    var repeatButtons: some View {
        HStack(spacing: UIScreen.main.bounds.width / 5 - 30){
            Button(action: {
                soundObservObj.RepeatAll.toggle()
                soundObservObj.Repeat.toggle()
            }) {
                Image(systemName: "repeat").font(.title)
                    .foregroundColor(soundObservObj.RepeatAll ? .red: .gray)
            }
            Button(action: {
                soundObservObj.Repeat.toggle()
                soundObservObj.RepeatAll.toggle()
                
            }) {
                Image(systemName: "repeat.1").font(.title)
                    .foregroundColor(soundObservObj.Repeat ? .red: .gray)
            }
        }//HStack
    }//repeatButtons
    
    func integerToTimeFn(timeIn:Int) -> String{
        let timeDefMInt:Int = timeIn / 60
        let timeDefSInt:Int = timeIn % 60
        var timeHSt:String = "\(timeDefMInt)"
        var timeMSt:String = "\(timeDefSInt)"
        if timeHSt.count == 1{timeHSt = "0\(timeDefMInt)"}
        if timeMSt.count == 1{timeMSt = "0\(timeMSt)"}
        let timeMS:String = "\(timeHSt):\(timeMSt)"
        return timeMS
    }//integerToTimeFn
    
    
    var body: some View {
        VStack{
            audioTimeSlider
            timeView
            playButtons
            repeatButtons
        }//VStack
    }//body
    
}//PlayerControlView

struct PlayerControlView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PlayerControlView()
            PlayerControlView()
                .preferredColorScheme(.dark)
        }
    }
}
