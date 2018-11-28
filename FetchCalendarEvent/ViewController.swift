//
//  ViewController.swift
//  FetchCalendarEvent
//
//  Created by Fumiya Tanaka on 2018/11/26.
//  Copyright © 2018 Fumiya Tanaka. All rights reserved.
//

import UIKit
import EventKit

class ViewController: UIViewController {
    
    @IBOutlet var table: UITableView!
    
    var eventStore = EKEventStore()
    let calendar = Calendar.current
    var eventArray: [EKEvent] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        checkAuth()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getEventsInOneYear()
    }
    
    func checkAuth() {
        //現在のアクセス権限の状態を取得
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        
        if status == .authorized { // もし権限がすでにあったら
            print("アクセスできます！！")
        }else if status == .notDetermined {
            // アクセス権限のアラートを送る。
            eventStore.requestAccess(to: EKEntityType.event) { (granted, error) in
                if granted { // 許可されたら
                    print("アクセス可能になりました。")
                }else { // 拒否されたら
                    print("アクセスが拒否されました。")
                }
            }
        }
    }
    
    func getEventsInOneYear() {
        
        var componentsOneYearDelay = DateComponents()
        componentsOneYearDelay.year = 1 // 今の時刻から1年進めるので1を代入
        let startDate = Date()
        let endDate = calendar.date(byAdding: componentsOneYearDelay, to: Date())! // 一年後の日付が`Date`型で簡単に作成できた。　Date()は現在の日付を表す。
        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
        eventArray = eventStore.events(matching: predicate)
        
        table.reloadData()
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = table.dequeueReusableCell(withIdentifier: "Cell") as! CalendarTableViewCell
        cell.event = eventArray[indexPath.row]
        
        return cell
    }
}
