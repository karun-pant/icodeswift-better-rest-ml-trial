//
//  ContentView.swift
//  BetterRestML
//
//  Created by Pant, Karun on 05/04/20.
//  Copyright © 2020 Pant, Karun. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var wakeupTime = defalutWakeupTime
    @State private var sleepAmount: TimeInterval = 8
    @State private var coffeeAmount = 1
    
    private var sleepPrediction: String {
        let model = SleepCalculator()
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeupTime)
        let hours = (components.hour ?? 0) * 60 * 60 // in seconds
        let minutes = (components.minute ?? 0) * 60 // in seconds
        do {
            let prediction = try model.prediction(
                wake: Double(hours + minutes),
                estimatedSleep: sleepAmount,
                coffee: Double(coffeeAmount))
            let sleepTime = wakeupTime - prediction.actualSleep
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return "You should sleep by\n \(formatter.string(from: sleepTime))"
        } catch {
            return "Some Error occurred, \nbut you know early to bed..."
        }
    }
    
    private static var defalutWakeupTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("When do you wakeup")) {
                    DatePicker("Select Wakeup Time",
                               selection: $wakeupTime,
                               displayedComponents: .hourAndMinute
                    )
                    .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                }
                
                Section(header: Text("Desired amount of sleep")) {
                    Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                        Text("\(sleepAmount, specifier: "%g") hours")
                    }
                }
                
                Section(header: Text("Daily coffee intake")) {
                    Stepper(value: $coffeeAmount, in: 1...20) {
                        coffeeAmount == 1
                            ? Text("1 Cup")
                            : Text("\(coffeeAmount) Cups")
                    }
                }
                
                Section() {
                    Text(sleepPrediction).font(.largeTitle)
                }
                
            }
            .navigationBarTitle("Better Rest")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
