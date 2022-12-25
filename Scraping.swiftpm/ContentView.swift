import SwiftUI
import SwiftSoup

struct ContentView: View {

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
                let doc: Document = try SwiftSoup.parse(html)
                for i in 1..<90 {
                    let title: Elements = try doc.select("#economicCalendarTable > div:nth-child(\(i))")
                    let event = try title.text()
                    let arr = event.split(separator: ", ")
                    print(arr)
                }

            }
            
            catch let error {
                print(error)
            }
        }
    }
    
    var body: some View {
        Text("scraping")
            .onAppear {
                fetchURL()
                
            }
        
    }
}
