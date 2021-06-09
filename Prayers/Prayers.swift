//
//  Prayers.swift
//  Prayers
//
//  Created by Moahmmed Sami on 07/04/2021.
//  Copyright © 2021 Infovass. All rights reserved.
//

import WidgetKit
import SwiftUI
import SRCountdownTimer

extension FileManager {
    static func sharedContainerURL() -> URL {
        return FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: "group.qatar.calendar.house.contents"
        )!
    }
}

struct Provider: TimelineProvider {
    
//    struct SimpleEntry: TimelineEntry {
//        let date: Date
//    }
//
//    func placeholder(in context: Context) -> SimpleEntry {
//        SimpleEntry(date: Date())
//    }
//
//    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
//        let entry = SimpleEntry(date: Date())
//        completion(entry)
//    }
//
//    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
//        var entries: [SimpleEntry] = []
//
//        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
//        let currentDate = Date()
//        for hourOffset in 0 ..< 5 {
//            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
//            let entry = SimpleEntry(date: entryDate)
//            entries.append(entry)
//        }
//
//        let timeline = Timeline(entries: entries, policy: .atEnd)
//        completion(timeline)
//    }

    func placeholder(in context: Context) -> WidgetContent {
        WidgetContent(date: Date(), dayCalendarDate: "", fajr: "", shrouk: "", zuhr: "", asr: "", maghrib: "", eshaa: "")
    }

    func getSnapshot(in context: Context, completion: @escaping (WidgetContent) -> ()) {
        let entry = WidgetContent(date: Date(), dayCalendarDate: "", fajr: "", shrouk: "", zuhr: "", asr: "", maghrib: "", eshaa: "")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let currentDate = Date()
        var entries = [WidgetContent(date: currentDate, dayCalendarDate: "", fajr: "", shrouk: "", zuhr: "", asr: "", maghrib: "", eshaa: "")]//readContents()
        print(entries.count)
        // Generate a timeline by setting entry dates interval seconds apart,
        // starting from the current date.
//        let interval = 5
//        for index in 0 ..< 1 {
////            let date = "\(entries[index].date) \(entries[index].fajr) GMT+03:00".toPrayDate()!
//            entries[index] = WidgetContent(date: currentDate, dayCalendarDate: "", fajr: "", shrouk: "", zuhr: "", asr: "", maghrib: "", eshaa: "")
////            entries[index].date = Calendar.current.date(byAdding: .second,
////                                                        value: index * interval, to: currentDate)!
//        }
        
//        for hourOffset in 0 ..< 5 {
//            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
//            let entry = WidgetContent(date: entryDate, dayCalendarDate: "", fajr: "", shrouk: "", zuhr: "", asr: "", maghrib: "", eshaa: "")
//            entries.append(entry)
//        }
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    func readContents() -> [WidgetContent] {
      var contents: [WidgetContent] = []
      let archiveURL =
        FileManager.sharedContainerURL()
        .appendingPathComponent("contents.json")
      print(">>> \(archiveURL)")
      
      let decoder = JSONDecoder()
      if let codeData = try? Data(contentsOf: archiveURL) {
        do {
          contents = try decoder.decode([WidgetContent].self, from: codeData)
        } catch {
          print("Error: Can't decode contents")
        }
      }
      return contents
    }
}

struct PrayersEntryView : View {
    //let model: WidgetContent

    var body: some View {
        VStack {
            HStack(spacing: 16) {
                VStack {
                    Text("اليوم")
                        .foregroundColor(Color(#colorLiteral(red: 0.5450980392, green: 0.007843137255, blue: 0.3411764706, alpha: 1)))
                        .font(.custom("Cairo-Bold", fixedSize: 20))
                    HStack {
                        VStack {
                            Text("السنة")
                            Text("السنة")
                        }
                        VStack {
                            Text("الشهر")
                            Text("الشهر")
                        }
                        VStack {
                            Text("اليوم")
                            Text("اليوم")
                        }
                    }
                    .foregroundColor(.black)
                    .font(.custom("Cairo-Bold", fixedSize: 17))
                }
                .padding(.leading, 60)
                .layoutPriority(.infinity)
                VStack(spacing: 10) {
                    VStack {
                        Text("الفجر")
                        Text("00:60")
                    }
                    .font(.custom("Cairo-Bold", fixedSize: 14))
                    
//                    CountDown()
//                        .font(.custom("Cairo-Bold", fixedSize: 16))
//                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)

                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .center)
                .foregroundColor(.black)
            }
            HStack(alignment: .center, spacing: 16) {
                VStack {
                    Text("الفجر")
                        .foregroundColor(.black)
                    Text("الفجر")
                        .foregroundColor(Color(#colorLiteral(red: 0.5450980392, green: 0.007843137255, blue: 0.3411764706, alpha: 1)))
                }
                VStack {
                    Text("الشروق")
                        .foregroundColor(.black)
                    Text("الشروق")
                        .foregroundColor(Color(#colorLiteral(red: 0.5450980392, green: 0.007843137255, blue: 0.3411764706, alpha: 1)))
                }
                VStack {
                    Text("الظهر")
                        .foregroundColor(.black)
                    Text("الظهر")
                        .foregroundColor(Color(#colorLiteral(red: 0.5450980392, green: 0.007843137255, blue: 0.3411764706, alpha: 1)))
                }
                VStack {
                    Text("العصر")
                        .foregroundColor(.black)
                    Text("العصر")
                        .foregroundColor(Color(#colorLiteral(red: 0.5450980392, green: 0.007843137255, blue: 0.3411764706, alpha: 1)))
                }
                VStack {
                    Text("المغرب")
                        .foregroundColor(.black)
                    Text("المغرب")
                        .foregroundColor(Color(#colorLiteral(red: 0.5450980392, green: 0.007843137255, blue: 0.3411764706, alpha: 1)))
                }
                VStack {
                    Text("العشاء")
                        .foregroundColor(.black)
                    Text("العشاء")
                        .foregroundColor(Color(#colorLiteral(red: 0.5450980392, green: 0.007843137255, blue: 0.3411764706, alpha: 1)))
                }
            }
            .font(.custom("Cairo-Bold", fixedSize: 14))
    //        .lineLimit(1)
        }
    }
}

//struct PrayersEntryView : View {
//    var entry: Provider.Entry
//
//    var body: some View {
//        Text(entry.date, style: .time)
//    }
//}

@main
struct Prayers: Widget {
    let kind: String = "Prayers"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            PrayersEntryView()
        }
        .configurationDisplayName("التقويم القطري")
        .description("ويدجت خاص بتطبيق التقويم القطري")
    }
}
