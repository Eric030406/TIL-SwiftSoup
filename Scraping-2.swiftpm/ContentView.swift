import SwiftUI
import SwiftSoup

class Scraping: ObservableObject {
    @Published var arr: [String] = []
    
     func fetchURL() {
        let koreaUrlAddress = "https://mql5.com/ko/economic-calendar/south-korea"
        let usaUrlAddress = "https://mql5.com/ko/economic-calendar/united-states"
        let euUrlAddress = "https://mql5.com/ko/economic-calendar/european-union"
        let japanUrlAddress = "https://mql5.com/ko/economic-calendar/japan"
        let chinaUrlAddress = "https://mql5.com/ko/economic-calendar/china"
        let germanyUrlAddress = "https://mql5.com/ko/economic-calendar/germany"
        let ukUrlAddress = "https://mql5.com/ko/economic-calendar/united-kingdom"
        
        
        guard let url = URL(string: usaUrlAddress) else { return }
        if let html = try? String(contentsOf: url, encoding: .utf8) {
            do {
                let datePattern: String = "(?<year>[0-9]{4})[.](?<month>[0-9]{2})[.](?<date>[0-9]{2})"
                let regex = try? NSRegularExpression(pattern: datePattern, options: [])
                var remove = false
                var count = 0
                let doc: Document = try SwiftSoup.parse(html)
                    let calendar3: Elements = try doc.select("div.ec-table__item").select("div")
                    let calendar2: Elements = try doc.select("#economicCalendarTable").select("a")                    
                    let title: Elements = try doc.select("#economicCalendarTable").select("div")
                    let event = try calendar3.text()
                    var arr2 = event.components(separatedBy: ", ")
                    for var index in 0..<arr2.count {
                        if remove {
                            remove = false
                        } 
                        index-=count
                        if index >= arr2.startIndex && index < arr2.endIndex {
                            if arr2[index].contains("예측:") || arr2[index].contains("USD") || arr2[index].contains("실제:") {
                                arr2.remove(at: index)
                                remove = true
                                count+=1
                            }
                        }

                            if let result = regex?.matches(in: arr2[index], options: [], range: NSRange(location: 0, length: arr2[index].count)) {
                                let rexStrings = result.compactMap { (element) -> String in
                                    let yearRange = Range(element.range(withName: "year"), in: arr2[index])!
                                    let monthRange = Range(element.range(withName: "month"), in: arr2[index])!
                                    let dateRange = Range(element.range(withName: "date"), in: arr2[index])!
                                    
                                    return "\(arr2[index][yearRange]).\(arr2[index][monthRange]).\(arr2[index][dateRange])"
                                } 
                                if !rexStrings.isEmpty {
                                    arr2[index] = rexStrings[0]
                                }
                                print(rexStrings)
                            }
                        
                    }
                    self.arr = arr2      

            }
            catch let error {
                print(error)
            }
        }
    }
}

struct ContentView: View {
    @StateObject var scraping = Scraping()
    
    var body: some View {
        Text("scraping")
            .padding()
            .onAppear {
                scraping.fetchURL()
            }
        List {
            ForEach(scraping.arr, id: \.self) { scrap in
                Text(scrap)
            }   
        }
    }
}
