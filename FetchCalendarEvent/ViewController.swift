//
//  ViewController.swift
//  FetchCalendarEvent
//
//  Created by Fumiya Tanaka on 2018/11/26.
//  Copyright © 2018 Fumiya Tanaka. All rights reserved.
//

import UIKit
import EventKit

class ViewController: UIViewController, UITableViewDataSource {
    
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
        getEventsInOneMonth()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "Cell") as! CalendarTableViewCell

        cell.event = eventArray[indexPath.row]
        
        return cell
    }
    
    func checkAuth() {
        
        //現在のアクセス権限の状態を取得
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        
        if status == .authorized {
            
            print("アクセスできます！！")
        }else if status == .notDetermined {
            
            eventStore.requestAccess(to: EKEntityType.event) { (granted, error) in
                if granted {
                    print("アクセス可能になりました。")
                }else {
                    print("アクセスが拒否されました。")
                }
            }
        }
    }

    func getEventsInOneMonth() {
        
        var componentsOneMonthLater = DateComponents()
        
        componentsOneMonthLater.year = 1
        
        let startDate = Date()
        
        let endDate = calendar.date(byAdding: componentsOneMonthLater, to: Date())!
        
        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
        
        eventArray = eventStore.events(matching: predicate)
        
        table.reloadData()
    }
    
}

