//
//  CalendarViewController.swift
//  DiaryApp
//
//  Created by Admin on 28.07.2020.
//  Copyright © 2020 Anton Dobrynin. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController {

    @IBOutlet weak var calendar: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var monthLbl: UILabel!
    
    
    let dataManager = DataManager()
    
    var tasks: [TasksModel] = []
        
    var currentMonth = String()
    var calendarVars = CalendarVars()
    
    var numberOfEmptyBox = Int()
    var nextNumberOfEmptyBox = Int()
    var previousNumberOfEmptyBox = 0
    var direction = 0
    var positionIndex = 0
    var leapYearCounter = 2
    var dayCounter = 0
    var highlightdate = -1
    var choosedDate = ""
    
    var timeStart = ""
    var timeEnd = ""
    var timeDay = ""
    var timeMonth = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        calendar.dataSource = self
        calendar.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupCalendary()
        
        let data = dataManager.getData(from: "tasks")

        if let data = data {
            for item in data {
               let newTask = TasksModel(id: item.id, name: item.name
                   , description: item.description, date_start: item.date_start, date_finish: item.date_finish)
               self.tasks.append(newTask)
           }
        }
    }
    
    func setupCalendary() {
        if weekday == 0 {
            weekday = 7
        }
        currentMonth = calendarVars.months[month]
        monthLbl.text = "\(currentMonth) \(year)"
        getStartDateDayPosition()
        calendar.reloadData()
    }
    
    
    @IBAction func nextMonthBtnTapped(_ sender: UIButton) {
        highlightdate = -1

        switch currentMonth {
            case "Декабрь":
                month = 0
                year += 1
                direction = 1
                
                if leapYearCounter < 5 {
                    leapYearCounter += 1
                }
                
                if leapYearCounter == 4 {
                    calendarVars.daysInMonth[1] = 29
                }
                
                if leapYearCounter == 5 {
                    leapYearCounter = 1
                    calendarVars.daysInMonth[1] = 28
                }
                
                getStartDateDayPosition()
                currentMonth = calendarVars.months[month]
                monthLbl.text = "\(currentMonth) \(year)"
                calendar.reloadData()

            default:
                direction = 1
                getStartDateDayPosition()
                month += 1
                currentMonth = calendarVars.months[month]
                monthLbl.text = "\(currentMonth) \(year)"
                calendar.reloadData()
        }
    }
    
    @IBAction func prevMonthBtnTapped(_ sender: UIButton) {
        highlightdate = -1
        switch currentMonth {
            case "Январь":
                month = 11
                year -= 1
                direction = -1
                
                if leapYearCounter > 0 {
                    leapYearCounter -= 1
                }
                
                if leapYearCounter == 0 {
                    calendarVars.daysInMonth[1] = 29
                    leapYearCounter = 4
                } else {
                    calendarVars.daysInMonth[1] = 28
                }
                
                
                getStartDateDayPosition()
                currentMonth = calendarVars.months[month]
                monthLbl.text = "\(currentMonth) \(year)"
                calendar.reloadData()
            default:
                month -= 1
                direction = -1
                
                getStartDateDayPosition()
                currentMonth = calendarVars.months[month]
                monthLbl.text = "\(currentMonth) \(year)"
                calendar.reloadData()
        }
    }
    
    
    func getStartDateDayPosition() {
           switch direction {
           case 0:
            numberOfEmptyBox = weekday
            dayCounter = day
            while dayCounter > 0 {
                numberOfEmptyBox = numberOfEmptyBox - 1
                dayCounter = dayCounter - 1
                if numberOfEmptyBox == 0 {
                    numberOfEmptyBox = 7
                }
            }
            if numberOfEmptyBox == 7 {
                numberOfEmptyBox = 0
            }
            positionIndex = numberOfEmptyBox
        case 1...:
            nextNumberOfEmptyBox = (positionIndex + calendarVars.daysInMonth[month]) % 7
            positionIndex = nextNumberOfEmptyBox
        case -1:
            previousNumberOfEmptyBox = (7 - (calendarVars.daysInMonth[month] - positionIndex) % 7)
            if previousNumberOfEmptyBox == 7 {
                previousNumberOfEmptyBox = 0
            }
            positionIndex = previousNumberOfEmptyBox
        default:
            fatalError()
        }
    }
    
    func fatalError() {
        print("error")
    }
    
    func updateTableView(with month: String, date: String) {
        let timeDateHourStart = NSDate(timeIntervalSince1970: TimeInterval(Double(tasks[0].date_start!)!))
        let dateTimePeriodFormatterHourStart = DateFormatter()
        dateTimePeriodFormatterHourStart.dateFormat = "hh"
        dateTimePeriodFormatterHourStart.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let dateStringHourStart = dateTimePeriodFormatterHourStart.string(from: timeDateHourStart as Date)
        
//        let timeDateHourEnd = NSDate(timeIntervalSince1970: TimeInterval(tasks[0].date_start!))
//        let dateTimePeriodFormatterHourEnd = DateFormatter()
//        dateTimePeriodFormatterHourEnd.dateFormat = "hh"
//        dateTimePeriodFormatterHourEnd.timeZone = NSTimeZone(name: "UTC") as TimeZone?
//        let dateStringHourEnd = dateTimePeriodFormatterHourEnd.string(from: timeDateHourEnd as Date)
        
        if month == date {
            timeStart = dateStringHourStart
//            timeEnd = dateStringHourEnd
        } else {
            timeStart = ""
//            timeEnd = ""
        }
        tableView.reloadData()
    }
    
}

// MARK: UICollectionViewDelegate
extension CalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        highlightdate = indexPath.row
        
        choosedDate = "\(indexPath.row - positionIndex + 1) \(currentMonth) \(year)"
        updateTableView(with: choosedDate, date: timeMonth)
        collectionView.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch direction {
        case 0:
            return calendarVars.daysInMonth[month] + numberOfEmptyBox
        case 1...:
            return calendarVars.daysInMonth[month] + nextNumberOfEmptyBox
        case -1:
            return calendarVars.daysInMonth[month] + previousNumberOfEmptyBox
        default:
            fatalError()
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Calendar", for: indexPath) as! DateCollectionViewCell
        cell.backgroundColor = .clear
        cell.dateLbl.textColor = .black
        cell.circle.isHidden = true
        
        if cell.isHidden {
            cell.isHidden = false
        }
        
        
        switch direction {
        case 0:
            cell.dateLbl.text = "\(indexPath.row + 1 - numberOfEmptyBox)"
        case 1:
            cell.dateLbl.text = "\(indexPath.row + 1 - nextNumberOfEmptyBox)"
        case -1:
            cell.dateLbl.text = "\(indexPath.row + 1 - previousNumberOfEmptyBox)"
        default:
            fatalError()
        }
        
        if Int(cell.dateLbl.text!)! < 1 {
            cell.isHidden = true
        }
        
        switch indexPath.row {
        case 5,6,12,13,19,20,26,27,33,34:
            if Int(cell.dateLbl.text!)! > 0 {
                cell.dateLbl.textColor = .lightGray
            }
        default:
            break
        }
        
        let timestamp = Double(tasks[0].date_start!)!
        let timeDateMonth = NSDate(timeIntervalSince1970: TimeInterval(timestamp))
        let dateTimePeriodFormatterMonth = DateFormatter()
        dateTimePeriodFormatterMonth.dateFormat = "MM"
        dateTimePeriodFormatterMonth.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        dateTimePeriodFormatterMonth.locale = Locale(identifier: "ru_RU")
        let dateStringMonth = dateTimePeriodFormatterMonth.string(from: timeDateMonth as Date)
        
        
        let timeDateFull = NSDate(timeIntervalSince1970: TimeInterval(timestamp))
        let dateTimePeriodFormatterFull = DateFormatter()
        dateTimePeriodFormatterFull.dateFormat = "dd MM yyyy"
        dateTimePeriodFormatterFull.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        dateTimePeriodFormatterFull.locale = Locale(identifier: "ru_RU")
        let dateStringFull = dateTimePeriodFormatterFull.string(from: timeDateFull as Date)
        
        
        let timeDateDay = NSDate(timeIntervalSince1970: TimeInterval(timestamp))
        let dateTimePeriodFormatterDay = DateFormatter()
        dateTimePeriodFormatterDay.dateFormat = "dd"
        dateTimePeriodFormatterDay.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        dateTimePeriodFormatterDay.locale = Locale(identifier: "ru_RU")
        let dateStringDay = dateTimePeriodFormatterDay.string(from: timeDateDay as Date)
        
//        print(dateStringMonth)
        timeMonth = dateStringFull
        
        let calendar = Calendar.current
        if currentMonth == calendarVars.months[calendar.component(.month, from: date) - 1] {
            if indexPath.row - 1 == day {
                cell.circle.isHidden = false
                cell.drawCircle()
            }
        }
                
        if dateStringMonth == currentMonth {
            if indexPath.row == Int(dateStringDay) {
                cell.backgroundColor = .blue
            }
        }
                
        if highlightdate == indexPath.row {
            cell.dateLbl.textColor = .red
        }
        
        return cell
    }
}

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 25
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! DateTableViewCell
        var row = indexPath.row
        
        var post = "AM"
        if row > 12 {
            row = row - 12
            post = "PM"
        }
        
        if row == 0 {
            row = 12
            post = "AM"
        }
        let x = String(format: "%2ld", row)
        
        if row == Int(timeStart) {
            cell.backgroundColor = .red
            cell.textLbl?.text = x + " " + post
            cell.nameTask?.isHidden = false
            cell.nameTask?.textColor = .white
            cell.nameTask?.text = "\(tasks[0].name!), время: \(timeStart)"
        } else {
            cell.nameTask?.isHidden = true
            cell.backgroundColor = .clear
            cell.textLbl?.text = x + " " + post + " " + String(repeating: "\u{2500}", count: 20)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //  тут нужно по нажатию открывать новый контроллер с задачей.
        // - время
        // - название
        // - дата
        //  описание
    }

}


