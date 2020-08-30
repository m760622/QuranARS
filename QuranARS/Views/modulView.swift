// https://github.com/m760622/QuranARSApp
//  modulView.swift
//  QuranARS
// m7606225@gmail.com
//  Created by Mohammed Abunada on 2020-08-30.
// https://github.com/m760622

import SwiftUI
import Combine
import AVKit

class ObservObj: ObservableObject {
    private init() { }
    
    static let shared = ObservObj()
    var audioPlayer : AVAudioPlayer!
    var artWork : Data = .init(count: 0)
    @State var del = AVdelegate()
    @Published var title = ""
    @Published var titleAr = ""
    @Published var artist = ""
    @Published var albumName = ""
    @Published var current:Int = 0
    @Published var fileName:String = ""
    @Published var Repeat = true
    @Published var RepeatAll = false
    @Published var playing = false
    @Published var finish = false
    @Published var width : CGFloat = 0
    let screenWidth: CGFloat = UIScreen.main.bounds.width * 0.75
    let screenHeight: CGFloat = UIScreen.main.bounds.height - 40
    
    func getData(){
        let asset = AVAsset(url: audioPlayer.url!)
        for i in asset.commonMetadata{
            switch i.commonKey?.rawValue {
            case "title":
                titleAr = i.value as! String
            case "artist":
                artist = i.value as! String
            case "albumName":
                albumName = i.value as! String
            case "artwork":
                artWork = i.value as! Data
            default:
                print("00001 i ",i.commonKey?.rawValue as Any)
            }//switch
        }//for
    }//getData
    
    func ChangeSongs(){
        if let url = Bundle.main.path(forResource: mediaList[current].fileName, ofType: ""){
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: [AVAudioSession.CategoryOptions.mixWithOthers])
                audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: url))
            } catch {
                print("click sound fail")// couldn't load file :(
            }
            audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: url))
            title = mediaList[current].title
        }//if let url
        
        audioPlayer.delegate = del
        artWork = .init(count: 0)
        getData()
        playFn()
    }//ChangeSongs
    
    func playFn(){
        audioPlayer.prepareToPlay()
        audioPlayer.play()
        playing = true
    }//playFn
    
    func pauseFn(){
        audioPlayer.pause()
        playing = false
    }//pauseFn
    
    func playPauseFn(){
        if audioPlayer.isPlaying{
            pauseFn()
        }
        else{
            if finish{
                audioPlayer.currentTime = 0
                width = 0
                finish = false
            }
            playFn()
        }
    }//playPauseFn
    
    func backwardFn(){
        if current > 0{
            current -= 1
            ChangeSongs()
        }else{
            current = mediaList.count - 1
            ChangeSongs()
        }
    }//backwardFn
    
    func forwardFn(){ //Next
        if mediaList.count - 1 != current{
            current += 1
            ChangeSongs()
        }else{
            current = 0
            ChangeSongs()
        }
    }//forwardFn
    
    var audioLength: Double = 0.0
    @Published var currentTimeInSeconds: Double = 0.0
    var currentTimeInSecondsPass: AnyPublisher<Double, Never>  {
        return $currentTimeInSeconds
            .eraseToAnyPublisher()
    }
    private var timeObserverToken: Any?
    
    @Published var sliderVolume: Float = 0.5 {
        willSet {
            audioPlayer?.volume = sliderVolume
            print(newValue)
        }
    }
    
    func getAudioLength(url: URL) -> Double {
        let asset = AVURLAsset(url: url, options: nil)
        let audioDuration = asset.duration
        return CMTimeGetSeconds(audioDuration)
    }
    
    func playAudio() {
        audioPlayer?.volume = 0.5
        audioPlayer?.play()
    }
    
    func pauseAudio() {
        audioPlayer?.pause()
    }
    
    func setVolume(volume: Float) {
        audioPlayer?.volume = volume
    }
    
}//ObservObj

class AVdelegate : NSObject,AVAudioPlayerDelegate{
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name("Finish"), object: nil)
    }
}//AVdelegate

struct MediaStruct: Identifiable, Hashable {
    let id = UUID()
    let idInt:Int
    let fileName: String
    let title: String
    let titleAr: String
}//MediaStruct

var mediaList = [
    MediaStruct(idInt: 0, fileName: "078-annaba", title: "annaba - 078 - ", titleAr: " سورة النبأ")
]

func getItemData(fileNameIn : String) -> String{
    var itemTitle = "title"
    let url = Bundle.main.path(forResource: fileNameIn, ofType: "")
    let itemAudioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: url!))
    let asset = AVAsset(url: itemAudioPlayer.url!)
    for i in asset.commonMetadata{
        if i.commonKey?.rawValue == "title" {
            itemTitle = i.value as! String
        }
    }//for
    return itemTitle
}//getItemData

func dataFn(){
    let fm = FileManager.default
    let path = Bundle.main.resourcePath!
    
    mediaList.removeAll()
    do {
        let items = try fm.contentsOfDirectory(atPath: path)
        var i: Int = 1
        for item in items {
            if ( item.contains("mp3")) {
                i += 1
                let titleAr = getItemData(fileNameIn: item)
                let idIntArray = item.components(separatedBy: "-")
                let fileNameArray = idIntArray[1].components(separatedBy: ".")
                let idInt:String = "\(idIntArray[0])"
                let fileName:String = "\(fileNameArray[0])"
                let mItem:MediaStruct = MediaStruct(idInt: i, fileName: item, title:  "\(fileName) - \(idInt) - ", titleAr: titleAr)
                mediaList.append(mItem)
            }
        }//for item
        
        mediaList.sort { $0.fileName < $1.fileName }
    } catch {
        // failed to read directory – bad permissions, perhaps?
        print("failed to read directory – bad permissions, perhaps?")
    }
}//dataFn
