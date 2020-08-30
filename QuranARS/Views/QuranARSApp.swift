// https://github.com/m760622/QuranARSApp
//  QuranARSApp.swift
//  QuranARS
// m7606225@gmail.com
//  Created by Mohammed Abunada on 2020-08-30.
// https://github.com/m760622

import SwiftUI

@main
struct QuranARSApp: App {
    
    var body: some Scene {
        WindowGroup {
            PlayerView()
                .onAppear {
                    dataFn()
                }
        }
    }
}
