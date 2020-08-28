import Foundation

extension Date {
    static func make(year: Int = 0, month: Int = 0, day: Int = 0, hour: Int = 0, minute: Int = 0) -> Date? {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        components.timeZone = TimeZone.current

        return Calendar.current.date(from: components)
    }
}
