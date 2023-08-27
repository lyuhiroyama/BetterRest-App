//
//  ContentView.swift
//  BetterRest
//
//  Created by Lyu Hiroyama on 2023/08/26.
//
import CoreML
import SwiftUI

struct ContentView: View {
    
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    @State private var waterAmount = 1
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    var sleepResults: String {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.hour ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let bedTime = wakeUp - prediction.actualSleep //Renamed 'sleepTime' to name 'bedTime'
            return "Your ideal bedtime is:        " + bedTime.formatted(date: .omitted, time: .shortened)
        } catch {
            return "There waas an error"
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Text("When do you want to wake up?")
                        .font(.headline)
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                Section {
                    Text("Desired amount of sleep")
                        .font(.headline)
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                }
                Section {
                    Text("Daily coffee intake")
                        .font(.headline)
                    Stepper(coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups", value: $coffeeAmount, in: 1...20)
                }
                Section {
                    Text("Daily water intake")
                        .font(.headline)
                    Picker("Amount of cups", selection: $waterAmount) {
                        ForEach(0..<51) {
                            Text($0, format: .number)
                        }
                    }
                }
                Text(sleepResults)
                    .font(.headline)
                
            }
            .navigationTitle("BetterRest")

            
            }
    }
    

    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
