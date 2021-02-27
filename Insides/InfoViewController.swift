//
//  InfoViewController.swift
//  Insides
//
//  Created by Hamas Hassan on 2/25/21.
//  Copyright © 2021 Hamas Hassan. All rights reserved.

import Charts
import UIKit
import FirebaseAuth
import FirebaseDatabase

struct Objects2 {
    var sectionName: String!
    var sectionObjects: [AnyObject]!
}

class InfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    var dateList = [Objects2]()
    
    var barChart =  BarChartView()
    
    var scrollView = UIScrollView()
    
    var counterId : String = ""
    
    let screenHeight = UIScreen.main.bounds.height
    let scrollViewContentHeight = 1200 as CGFloat
    
    var ref = Database.database().reference()
    
    let userID = Auth.auth().currentUser?.uid
    
    var listData = [String]()
    var sectionData = [String]()
    
    let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "DetailsCell")
        return table
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        
        self.fetchData()
        //        self.fetchDataFromDate()
        
        scrollView.frame = view.bounds
        scrollView.backgroundColor = UIColor.init(named: "backgroundColor")
        scrollView.autoresizingMask = .flexibleHeight
        scrollView.contentSize =  CGSize(width: self.view.frame.size.width,
                                         height: self.view.frame.size.height)
        scrollView.delegate = self
        scrollView.isScrollEnabled = false
        scrollView.bounces = false
        tableView.bounces = false
        
        //        NSLayoutConstraint.activate([
        //            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        //            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
        //            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
        //            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        //        ])
        
        
        //        tableView.heightAnchor.constraint(equalToConstant: self.view.frame.height-64)
        
        
        
        //        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate   = self
        tableView.isEditing = true
        
        
        setNavigationBar()
        configueStackView()
        
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        tableView.frame.size = tableView.contentSize
        
        NSLayoutConstraint.activate([
            tableView.heightAnchor.constraint(equalToConstant: tableView.frame.height),
        ])
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("DELETE")
        }
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let data = dateList[section].sectionName
        
        return data
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dateList.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dateList[section].sectionObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsCell", for: indexPath)
        
        print("dateList\(dateList)")
        
        let data = self.dateList[indexPath.section].sectionObjects.reversed()[indexPath.row]
        
        //            .sorted().reversed()[indexPath.row]
        
        print("hehe",data)
        
        cell.textLabel?.text = "\(data["date"] as! String), \(data["counter_name"] as! String)"
        
        return cell
    }
    
    func configureBarChart(){
        
        barChart.frame = CGRect(x:10,y:0,width: self.view.frame.size.width-200,
                                height: self.view.frame.size.width)
        
        barChart.backgroundColor = UIColor(named: "itemColor")
        let labels = ["Value 1", "Value 2", "Value 3"]
        barChart.fitBars = true
        barChart.layer.cornerRadius = 200
        barChart.legend.enabled = false
        barChart.rightAxis.enabled = false
        barChart.xAxis.labelPosition = .bottom
        barChart.xAxis.drawLabelsEnabled = true
        barChart.leftAxis.labelTextColor = .red
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        barChart.leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: formatter)
        barChart.leftAxis.axisMinimum = 0
        barChart.xAxis.drawGridLinesEnabled = false
        barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values:labels)
        //        barChart.xAxis.granularity = 1
        
        var entries = [BarChartDataEntry]()
        
        print("entries \(dateList.count)")
        
        for x in dateList {
            entries.append(BarChartDataEntry(x: Double(x.sectionObjects.count), y: Double(x.sectionObjects.count)))
        }
        
        
        //        for x in 0..<10 {
        //                 entries.append(BarChartDataEntry(x: Double(x), y: Double(x+20)))
        //             }
        
        
        
        
        let set = BarChartDataSet(entries:entries)
        //        set.colors = ChartColorTemplates.joyful()
        set.colors = [NSUIColor.systemBlue]
        set.barBorderColor = .red
        
        let data = BarChartData(dataSet: set)
        data.barWidth = Double(0.5)
        
        barChart.data = data
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Disabling horizontal scrolling
        scrollView.contentOffset.x = 0.0
        
        print(scrollView.contentOffset.y)
    }
    
    
    
    func configueStackView(){
        
        configureBarChart()
        
        
        
        
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGreen
        imageView.image = UIImage(systemName: "bell")
        imageView.contentMode = .scaleAspectFit
        //        imageView.widthAnchor.constraint(equalToConstant: view.frame.size.width).isActive = true
        //        imageView.heightAnchor.constraint(equalToConstant: view.frame.size.height/3).isActive = true
        //
        let label = UILabel()
        label.text = "Hello World"
        label.textAlignment = .center
        //        label.widthAnchor.constraint(equalToConstant: view.frame.size.width).isActive = true
        //        label.heightAnchor.constraint(equalToConstant: 100).isActive = true
        //
        let stackView = UIStackView(arrangedSubviews: [barChart,tableView])
        stackView.frame = scrollView.bounds
        stackView.backgroundColor = .black
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        
        //        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        scrollView.addSubview(stackView)
        
        
        NSLayoutConstraint.activate([
            barChart.topAnchor.constraint(equalTo: stackView.topAnchor,constant: 20),
            barChart.leftAnchor.constraint(equalTo: stackView.leftAnchor,constant: 0),
            barChart.rightAnchor.constraint(equalTo: stackView.rightAnchor,constant: 0),
            barChart.bottomAnchor.constraint(equalTo: tableView.topAnchor),
            //                             barChart.widthAnchor.constraint(equalToConstant:  self.view.frame.size.width/2),
            //                             barChart.heightAnchor.constraint(equalToConstant: self.view.frame.size.height/3),
        ])
        //
        //        NSLayoutConstraint.activate([
        //            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        //            stackView.leftAnchor.constraint(equalTo: view.leftAnchor),
        //            stackView.rightAnchor.constraint(equalTo: view.rightAnchor),
        //            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        //        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            //            stackView.widthAnchor.constraint(equalToConstant: scrollView.contentSize.width),
            //            stackView.heightAnchor.constraint(equalToConstant: scrollView.contentSize.height)
        ])
        
        //        NSLayoutConstraint.activate([
        //            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true,
        //            stackView.leftAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true,
        //            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        //            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        //        ])
        
        
        
        
        
        // Set the width of the stack view to the width of the scroll view for vertical scrolling
        //        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        
        
        
        //        stackView.arrangedSubviews(label)
        //
        //        view.addSubview(stackView)
        //        stackView.frame = view.bounds
        //        stackView.axis = .vertical
        //        stackView.distribution = .fillEqually
        //        stackView.spacing = 20
        //        stackView.backgroundColor = .red
        
        //        setStackViewConstraints()
    }
    
    //    func setStackViewConstraints(){
    //        stackView.translatesAutoresizingMaskIntoConstraints = false
    //        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 20).isActive = true
    //         stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
    //        stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 20).isActive = true
    //        stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 20).isActive = true
    //
    ////        stackView.addArrangedSubview(tableView)
    //
    //    }
    
    func setNavigationBar(){
        
        title = "Today"
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.backgroundColor = UIColor.init(named: "backgroundColor")
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.layoutIfNeeded()
        
        let dateIcon = UIImage(named: "date")?.withRenderingMode(.alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: dateIcon, style: .plain, target: self, action: #selector(onBackPress))
        
    }
    
    
    @objc func onBackPress() {
        let vc = storyboard?.instantiateViewController(identifier: "CalendarScreen") as! CalendarViewController
        
        vc.modalPresentationStyle = .formSheet
        vc.onSave = { (date) -> Void in
            print("callback")
            print(date)
            self.fetchDataFromDate(date: date)
            let dateForatter = DateFormatter()
            dateForatter.dateStyle = .medium
            dateForatter.timeStyle = .none
//            let mytitle = dateForatter.string(from: date)
            self.title =  dateForatter.string(from: date)
        }
        
        present(vc,animated: true)
    }
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            navigationController?.setNavigationBarHidden(true, animated: true)
            
        }
    }
    
    func fetchData(){
        ref.child("users").child(userID!).child("allCounters").observe(.value, with: { (snapshot) in
            
            if let snapShot = snapshot.children.allObjects as? [DataSnapshot]{
                
                for snap in snapShot {
                    
                    if let mainObj = snap.value as? [String: AnyObject]{
                        print("mainObj \(mainObj)")
                        print("inside \(snap.value)")
                        let date = mainObj["date"] as? String
                        
                        var newlist = [AnyObject]()
                        
                        for m in mainObj {
                            print("mf\(m.value["counter_name"])")
                            
//                            let myCounter = [
//                                "key": m.key,
//                                "counter"
//
//                            ]
                            
                            newlist.append(m.value)
                        }
                        
                        
                        let section = "\(snap.key) [\(mainObj.count)]"
                        self.dateList.append(Objects2(sectionName: section, sectionObjects: newlist))
                        
                        self.tableView.reloadData()
                    }
                }
                self.configureBarChart()
            }
        })
    }
    
    func fetchDataFromDate(date:Date){

        let myDate = date
        let selectedDate = myDate.getFormattedDatee(format: "dd-MM-yyyy")
        print("formate \(selectedDate)")



         ref.child("users").child(userID!).child("allCounters").observe(.value, with: { (snapshot) in
            print("hi")
            if let snapShot = snapshot.children.allObjects as?
                [DataSnapshot]{

                var newlist = [AnyObject]()

                for snap in snapShot {
                    newlist.append(snap.value as AnyObject)
                }

                let section = "\(selectedDate) [\(newlist.count)]"

                self.dateList.removeAll()

                self.dateList.append(Objects2(sectionName: section, sectionObjects: newlist))

                self.tableView.reloadData()

                self.configureBarChart()
            }
        })
    }
    
}

//   ref.child("users").child(userID!).child("counters").child("243CE1FA-8CD4-4E5A-922C-5AF6821ECDF9").child("countersData")
extension Date {
    func getFormattedDatee(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}
