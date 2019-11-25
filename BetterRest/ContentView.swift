//
//  ContentView.swift
//  BetterRest
//
//  Created by Kamaal Farah on 23/11/2019.
//  Copyright © 2019 Kamaal. All rights reserved.
//


import SwiftUI


struct ContentView: View {
    @State private var wakeUp = defaultWakeUpTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1


    var body: some View {
        NavigationView {
            Form {
                Section {
                    StandardText(text: "When do you want to wake up?")

                    DatePicker(
                        selection: $wakeUp,
                        displayedComponents: .hourAndMinute,
                        label: {
                            Text("Please enter a time")
                        })
                    .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                }

                Section {
                    StandardText(text: "Desired amount of sleep")

                    Stepper(value: $sleepAmount, in: 4...12, step: 0.25, label: {
                        Text("\(sleepAmount, specifier: "%g") hours")
                    })
                }

                Section {
                    StandardText(text: "Daily coffee intake")

                    Stepper(value: $coffeeAmount, in: 1...20, label: {
                        if coffeeAmount < 2 { Text("1 cup") }
                        else { Text("\(coffeeAmount) cups") }
                    })
                }
                
                Section {
                    Text("Your ideal bedtime is \(calculatedBedTime)")
                        .font(.largeTitle)
                }
            }
            .navigationBarTitle("BetterRest")
        }
    }


    static var defaultWakeUpTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }


    var calculatedBedTime: String {
        let model = SleepCalculator()

        let components =  Calendar.current.dateComponents(
            [.hour, .minute],
            from: wakeUp
        )
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60

        do {
            let prediction = try model.prediction(
                wake: Double(hour + minute),
                estimatedSleep: sleepAmount,
                coffee: Double(coffeeAmount)
            )

            let sleepTime = wakeUp - prediction.actualSleep

            let formatter = DateFormatter()
            formatter.timeStyle = .short

            return formatter.string(from: sleepTime)
        } catch {
            return "Sorry, ther was a problem calculating yur bedtime."
        }
    }
}



