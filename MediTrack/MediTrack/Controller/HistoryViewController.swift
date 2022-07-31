//
//  HistoryViewController.swift
//  MediTrack
//
//  Created by Manjunath on 27/07/22.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController {
    
    //MARK: - IBOutlet Variables
    @IBOutlet weak var historyTableView: UITableView!
    
    //MARK: - Public Variables
    var daysArray: [Day]?
    var firstDay: Int = 0
    
    //MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        historyTableView.rowHeight = UITableView.automaticDimension
        historyTableView.estimatedRowHeight = 130
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //MARK: - IBAction methods
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    //MARK: - Private methods
    private func updateTimeLabel(cell: HistoryTableViewCell, row: Int){
        if daysArray?[row].morningTime != nil {
            cell.morningTimeLabel.text = daysArray?[row].morningTime
            cell.morningView.isHidden = false
        }else {
            cell.morningView.isHidden = true
        }
        if daysArray?[row].afternoonTime != nil {
            cell.afternoonTimeLabel.text = daysArray?[row].afternoonTime
            cell.afternoonView.isHidden = false
        }else {
            cell.afternoonView.isHidden = true
        }
        if daysArray?[row].eveningTime != nil {
            cell.eveningTimeLabel.text = daysArray?[row].eveningTime
            cell.eveningView.isHidden = false
        }else {
            cell.eveningView.isHidden = true
        }
    }
}

//MARK: - UITableViewDataSource methods
extension HistoryViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daysArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  morningTime = daysArray?[indexPath.row].morningTime
        let afternoonTime = daysArray?[indexPath.row].afternoonTime
        let eveningTime = daysArray?[indexPath.row].eveningTime
        if morningTime == nil, afternoonTime == nil, eveningTime == nil {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoMedicineTakenTableViewCell", for: indexPath) as! NoMedicineTakenTableViewCell
            cell.dateLabel.text = daysArray?[indexPath.row].date
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath) as! HistoryTableViewCell
            cell.scroreLabel.text = daysArray?[indexPath.row].score
            cell.dateLabel.text = daysArray?[indexPath.row].date
            updateTimeLabel(cell: cell, row: indexPath.row)
            return cell
        }
    }
}

