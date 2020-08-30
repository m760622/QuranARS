//
//  modulView.swift
//  QuranARS
//
//  Created by Mohammed Abunada on 2020-07-28.
//https://medium.com/better-programming/the-best-way-to-use-environment-objects-in-swiftui-d9a88b1e253f

import SwiftUI
import Combine
import AVKit

class ObservObj: ObservableObject {
    private init() { }
    
    static let shared = ObservObj()
    var artWork : Data = .init(count: 0)
    @Published var title = ""
    @Published var subTitle = ""
    var audioPlayer : AVAudioPlayer!
    @Published var current:Int = 0
    @Published var fileName:String = ""
    @Published var Repeat = true
    @Published var RepeatAll = false
    @Published var playing = false
    @Published var finish = false
    @State var del = AVdelegate()
    @Published var width : CGFloat = 0
    let screenWidth: CGFloat = UIScreen.main.bounds.width * 0.75
    let screenHeight: CGFloat = UIScreen.main.bounds.height - 40
    
    func getData(){
        let asset = AVAsset(url: audioPlayer.url!)
        
        for i in asset.commonMetadata{
            //            print(" i ",i.commonKey?.rawValue)
            switch i.commonKey?.rawValue {
            case "albumName":
                subTitle = i.value as! String
                print("00000  subTitle ",subTitle)
//            case "artist":
//                let artist = i.value as! String
//                print("00000  artist ",artist)
            case "title":
                title = i.value as! String
                print("00002  title ",title)
            case "artwork":
                artWork = i.value as! Data
                print("00003  artWork ",artWork)
                
            default:
                print("00001 i ",i.commonKey?.rawValue as Any)
            }//switch
        }//for
    }//getData
    
    func ChangeSongs(){
        print("009 ChangeSongs globalVal.current ",current, " fileName ",mediaList[current].fileName)
        if let url = Bundle.main.path(forResource: mediaList[current].fileName, ofType: ""){
            //            if let url = Bundle.main.path(forResource: mediaList[current].fileName, ofType: "mp3"){
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: [AVAudioSession.CategoryOptions.mixWithOthers])
                //self.player?.stop()
                audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: url))
            } catch {
                print("click sound fail")// couldn't load file :(
            }
            
            audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: url))
        }//if let url
        
        audioPlayer.delegate = del
        artWork = .init(count: 0)
        getData()
        playFn()
        print("3333 ChangeSongs audioPlayer.duration ",audioPlayer.duration, " currentTime ",audioPlayer.currentTime)
    }//ChangeSongs
    
    
    
    func playFn(){
        //        try! AVAudioSession.sharedInstance().setActive(true)
        audioPlayer.prepareToPlay()
        audioPlayer.play()
        playing = true
        //            print("2 curre playing ",playing , " finish ",finish  )
    }//playFn
    
    func pauseFn(){
        //            try! AVAudioSession.sharedInstance().setActive(false)
        audioPlayer.pause()
        playing = false
        //            print("1 curre playing ",playing , " finish ",finish  )
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
    
    // called when user drags slider to change song time
    func rewindTime(to seconds: Double) {
        let timeCM = CMTime(seconds: seconds, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        //        audioPlayer?.seek(to: timeCM)
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

//var mediaList : [MediaStruct]!


var mediaList = [
    MediaStruct(idInt: 0, fileName: "078-annaba", title: "078-annaba", titleAr: " سورة النبأ")
]

func getItemData(fileNameIn : String) -> String{
    var itemArtWork : Data = .init(count: 0)
    var itemTitle = "title"
    var itemAlbumName = "itemAlbumName"
    var itemTrack = "Track"
    
    //        var itemAudioPlayer : AVAudioPlayer!
    let url = Bundle.main.path(forResource: fileNameIn, ofType: "")
    //    let url = Bundle.main.path(forResource: fileNameIn, ofType: String?)
    let itemAudioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: url!))
    print("0000  \(url!)")
    
    let asset = AVAsset(url: itemAudioPlayer.url!)
    for i in asset.commonMetadata{
        //        print("00000 i ",i.commonKey?.rawValue, " value ",i.value)
        switch i.commonKey?.rawValue {
        case "albumName":
            itemAlbumName = i.value as! String
            print("00000  itemAlbumName ",itemAlbumName)
        case "artist":
            let artist = i.value as! String
            print("00000  artist ",artist)
        case "title":
            itemTitle = i.value as! String
            print("00002  itemTitle ",itemTitle)
        case "track":
            itemTrack = i.value as! String
            print("000022  itemTrack ",itemTrack)
        case "artwork":
            itemArtWork = i.value as! Data
            print("00003  itemArtWork ",itemArtWork)

        default:
            print("00001 i ",i.commonKey?.rawValue as Any)
        }//switch
        
    }//for
    return itemTitle //itemAlbumName //itemTitle
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
                //                let title = "test" // getItemData(fileNameIn: item)
                i += 1
                let titleAr = getItemData(fileNameIn: item)
                
                //                let str = "078-annaba.mp3"
                let idIntArray = item.components(separatedBy: "-")
                let fileNameArray = idIntArray[1].components(separatedBy: ".")
                
                let idInt:String = "\(idIntArray[0])"
                let fileName:String = "\(fileNameArray[0])"
                //    print("00005  idInt ",idInt, " fileName ",fileName)
                print("00005  idInt ",idInt, " fileName ",fileName)
                
                
                let mItem:MediaStruct = MediaStruct(idInt: i, fileName: item, title:  "\(fileName) - \(idInt)", titleAr: titleAr)
                print("009 1 item ",item," titleAr ",titleAr)
                mediaList.append(mItem)
                //                i += 1
                print("009 2 Found \(item) i \(i)")
            }
        }
        
        mediaList.sort { $0.fileName < $1.fileName }
        print("009 3 mediaList \(mediaList.count) ")
        
    } catch {
        // failed to read directory – bad permissions, perhaps?
        print("failed to read directory – bad permissions, perhaps?")
    }
    
}//dataFn



/*
 
 func prepareAudio(){
 do {
 try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: [AVAudioSession.CategoryOptions.mixWithOthers])
 //self.player?.stop()
 //            self.player = try AVAudioPlayer(contentsOf: url!)
 //            self.player?.play()
 } catch {
 print("click sound fail")// couldn't load file :(
 }
 
 
 do {
 try AVAudioSession.sharedInstance().setCategory(
 AVAudioSession.Category.playback,
 mode: AVAudioSession.Mode.default,
 options: [
 AVAudioSession.CategoryOptions.duckOthers
 ]
 )
 }
 */
/*
 
 
 //        setCurrentAudioPath()
 do {
 //keep alive audio at background
 try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
 } catch _ {
 }
 do {
 try AVAudioSession.sharedInstance().setActive(true)
 } catch _ {
 }
 mp3name.text = UserDefaults.standard.string(forKey: "songNameArUD")
 
 UIApplication.shared.beginReceivingRemoteControlEvents()
 audioPlayer = try? AVAudioPlayer(contentsOf: currentAudioPath)
 audioPlayer.delegate = self
 audioLength = audioPlayer.duration
 playerProgressSlider.maximumValue = CFloat(audioPlayer.duration)
 playerProgressSlider.minimumValue = 0.0
 playerProgressSlider.value = 0.0
 audioPlayer.prepareToPlay()
 showTotalSongLength()
 progressTimerLabel.text = "00:00"
 }
 */


/*
 var mediaList = [
 MediaStruct(idInt: 0, fileName: "078-annaba", title: "078-annaba", titleAr: " سورة النبأ"),
 //    MediaStruct(idInt: 1, fileName: "079-annaziat", title: "079-annaziat", titleAr: " سورة النازعات"),
 //    MediaStruct(idInt: 2, fileName: "080-abasa", title: "080-abasa", titleAr: " سورة عبس"),
 //    MediaStruct(idInt: 3, fileName: "081-attakwir", title: "081-attakwir", titleAr: " سورة التكوير"),
 //    MediaStruct(idInt: 4, fileName: "082-alinfitar", title: "082-alinfitar", titleAr: " سورة الانفطار"),
 //    MediaStruct(idInt: 5, fileName: "083-almoutaffifin", title: "083-almoutaffifin", titleAr: " سورة المطففين"),
 //    MediaStruct(idInt: 6, fileName: "084-alinshiqaq", title: "084-alinshiqaq", titleAr: " سورة الانشقاق"),
 //    MediaStruct(idInt: 7, fileName: "085-albourouj", title: "085-albourouj", titleAr: " سورة البروج"),
 //    MediaStruct(idInt: 8, fileName: "086-attariq", title: "086-attariq", titleAr: " سورة الطارق"),
 //    MediaStruct(idInt: 9, fileName: "087-alala", title: "087-alala", titleAr: " سورة الأعلى"),
 //    MediaStruct(idInt: 10, fileName: "088-alghashiya", title: "088-alghashiya", titleAr: " سورة الغاشية"),
 //    MediaStruct(idInt: 11, fileName: "089-alfajr", title: "089-alfajr", titleAr: " سورة الفجر"),
 //    MediaStruct(idInt: 12, fileName: "090-albalad", title: "090-albalad", titleAr: " سورة البلد"),
 //    MediaStruct(idInt: 13, fileName: "091-ashshams", title: "091-ashshams", titleAr: " سورة الشمس"),
 //    MediaStruct(idInt: 14, fileName: "092-allayl", title: "092-allayl", titleAr: " سورة الليل"),
 //    MediaStruct(idInt: 15, fileName: "093-addhuha", title: "093-addhuha", titleAr: " سورة الضحى"),
 //    MediaStruct(idInt: 16, fileName: "094-ashsharh", title: "094-ashsharh", titleAr: " سورة الشرح")
 //            MediaStruct(idInt: 3, fileName: "Quran", title: "Quran", titleAr: "Quran")
 ]//mediaList
 
 */

