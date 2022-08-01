//
//  MediTrackHomePageViewController.swift
//  MediTrack
//
//  Created by Manjunath on 27/07/22.
//

import UIKit
import CoreData
import UserNotifications

enum _Day: String {
    case morning
    case afternoon
    case evening
}

class MediTrackHomePageViewController: UIViewController {
    
    //MARK: - IBOutlet variables
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var medicineTakenButton: UIButton!
    
    //MARK: - Private properties
    private var score = 0
    private var isMorningTaken = false, isAfternoonTaken = false, isEveningTaken = false
    private var daysArray: [Day]?
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserPermission()
        updateDateForMonth()
        updateLatestValue()
        makeLocalNotification()
    }
    
    //MARK: - IBAction methods
    @IBAction func medicineTakenButtonTapped(_ sender: Any) {
        switch getDay() {
        case .morning :
            if !isMorningTaken {
                score = score + 30
                isMorningTaken = true
                saveDay()
            }
        case .afternoon :
            if !isAfternoonTaken {
                score = score + 30
                isAfternoonTaken = true
                saveDay()
            }
        case .evening :
            if !isEveningTaken {
                score = score + 40
                isEveningTaken = true
                saveDay()
            }
        }
        scoreLabel.text = String(score)
        
    }
    
    @IBAction func historyButtonTapped(_ sender: Any) {
        guard let historyViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HistoryViewController") as? HistoryViewController else {
            return
        }
        updateLatestValue()
        historyViewController.daysArray = getSortedDays()
        self.navigationController?.pushViewController(historyViewController, animated: false)
    }
    
    //MARK: - Private Methods
    private func makeLocalNotification() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        var dateComponents = DateComponents()
        if !isMorningTaken {
            dateComponents.hour = 11
            requestLocalNotification(dateComponents: dateComponents, msg: "morning within 11 am", identifier: "MorningNotification")
        }
        if !isAfternoonTaken {
            dateComponents.hour = 14
            requestLocalNotification(dateComponents: dateComponents, msg: "afternoon within 2 pm", identifier: "AfternoonNotification")
        }
        if !isEveningTaken {
            dateComponents.hour = 20
            requestLocalNotification(dateComponents: dateComponents, msg: "evening within 8 pm ", identifier: "EveningNotification")
        }
    }
    
    private func requestLocalNotification(dateComponents: DateComponents, msg: String, identifier: String ){
        let content = UNMutableNotificationContent()
        content.title = "Hey!, you should had taken the tablet this" + msg
        content.subtitle = "Missed it?"
        content.body = "Look at me!"
        content.sound = UNNotificationSound.default
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    private func getUserPermission(){
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if !granted {
                print("Permission Denied")
            }
        }
    }
    
    private func updateLatestValue() {
        daysArray = fetchDays()
        let currentDay = daysArray?.filter({$0.date == getDate().date}).first
        greetingLabel.text = getGreeting()
        if let day = currentDay, let scoreStr = day.score, let scoreInt = Int(scoreStr) {
            scoreLabel.text = day.score
            score = scoreInt
            isMorningTaken = day.morningTime != nil ? true : false
            isAfternoonTaken = day.afternoonTime != nil ? true : false
            isEveningTaken = day.eveningTime != nil ? true : false
        } else {
            score = 0
            scoreLabel.text = "0"
            isMorningTaken = false
            isEveningTaken = false
            isAfternoonTaken = false
        }
    }
    
    private func getDate(day: Date = Date()) -> (date: String, time: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.string(from: day)
        dateFormatter.timeStyle = .short
        let time = dateFormatter.string(from: day)
        return (date, time)
    }
    
    private func saveDay() {
        let days = daysArray?.filter({$0.date == getDate().date})
        if let day = days?.first {
            day.score = String(score)
            updateTimes(day)
        } else {
            let newDay = Day(context: self.context)
            newDay.score = String(score)
            newDay.date = getDate().date
            updateTimes(newDay)
        }
        saveContext()
    }
    
    private func updateTimes(_ day: Day){
        switch getDay() {
        case .morning :
            day.morningTime = getDate().time
        case .afternoon :
            day.afternoonTime = getDate().time
        case .evening :
            day.eveningTime = getDate().time
        }
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    private func getGreeting() -> String {
        var greetingText = ""
        switch getDay() {
        case .morning :
            greetingText = "Good Morning"
        case .afternoon :
            greetingText = "Good Afternoon"
        case .evening :
            greetingText = "Good Evening"
        }
        return greetingText
    }
    
    private func fetchDays() -> [Day]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Day")
        request.returnsObjectsAsFaults = false
        do {
            daysArray = try context.fetch(request) as? [Day]
        } catch {
            print("Failed")
        }
        return daysArray
    }
    
    private func getDay() -> _Day {
        let hour = Calendar.current.component(.hour, from: Date())
        
        let NEW_DAY = 0
        let NOON = 12
        let SUNSET = 16
        
        switch hour {
        case NEW_DAY..<NOON:
            return _Day.morning
        case NOON..<SUNSET:
            return _Day.afternoon
        default:
            return _Day.evening
        }
    }
    
    private func getSortedDays() -> [Day] {
        guard let days = daysArray else { return []}
        return days.sorted(){$0.date ?? "" > $1.date ?? ""}
    }
    
    private func updateDateForMonth() {
        let allDatesOfMon = Date().getAllDays()
        let fetchedDays = fetchDays()
        for date in allDatesOfMon{
            let date = getDate(day: date).date
            if let day = fetchedDays?.filter({$0.date == date}),
               day.count == 0 {
                let newDay = Day(context: self.context)
                newDay.date = date
                saveContext()
            }
        }
    }
}

//MARK: - Extension of date
extension Date {
    mutating func addDays(n: Int) {
        let cal = Calendar.current
        self = cal.date(byAdding: .day, value: n, to: self)!
    }
    
    func firstDayOfTheMonth() -> Date {
        return Calendar.current.date(from:
                                        Calendar.current.dateComponents([.year,.month], from: self))!
    }
    
    func getAllDays() -> [Date]{
        var days = [Date]()
        let curDay = Calendar.current.component(.day, from: self)
        var fstDay = firstDayOfTheMonth()
        for _ in 1...curDay{
            days.append(fstDay)
            fstDay.addDays(n: 1)
        }
        return days
    }
}

