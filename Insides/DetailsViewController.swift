//
//  DetailsViewController.swift
//  Insides
//
//  Created by Hamas Hassan on 1/31/21.
//  Copyright © 2021 Hamas Hassan. All rights reserved.
//

import Charts
import UIKit

class DetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    var barChart =  BarChartView()
    
    var scrollView = UIScrollView()
    
    let screenHeight = UIScreen.main.bounds.height
    let scrollViewContentHeight = 1200 as CGFloat
    
    let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "DetailsCell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        
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
    
    
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section Title \(section)"
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsCell", for: indexPath)
        
        cell.textLabel?.text = "Hello World: \(indexPath.section) | row : \(indexPath.row)"
        
        return cell
    }
    
    func configureBarChart(){
        
        barChart.frame = CGRect(x:10,y:0,width: self.view.frame.size.width-40,
                                height: self.view.frame.size.width/1.5)
        
        barChart.backgroundColor = UIColor(named: "itemColor")
        
        barChart.fitBars = true
        barChart.layer.cornerRadius = 200
        barChart.legend.enabled = false
        barChart.rightAxis.enabled = false
        barChart.xAxis.labelPosition = .bottom
        barChart.leftAxis.labelTextColor = .red
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        barChart.leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: formatter)
        barChart.leftAxis.axisMinimum = 0
        barChart.xAxis.drawGridLinesEnabled = false
        
        var entries = [BarChartDataEntry]()
        
        for x in 0..<10 {
            entries.append(BarChartDataEntry(x: Double(x), y: Double(x)))
        }
        
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
        stackView.distribution = .fillProportionally
        stackView.spacing = 20
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        scrollView.addSubview(stackView)
        
        
        NSLayoutConstraint.activate([
            barChart.topAnchor.constraint(equalTo: stackView.topAnchor,constant: 20),
            barChart.leftAnchor.constraint(equalTo: stackView.leftAnchor,constant: 0),
            barChart.rightAnchor.constraint(equalTo: stackView.rightAnchor,constant: 0),
            barChart.bottomAnchor.constraint(equalTo: tableView.topAnchor),
            //                 barChart.widthAnchor.constraint(equalToConstant:  self.view.frame.size.width-40),
            //                 barChart.heightAnchor.constraint(equalToConstant: self.view.frame.size.width/1.5),
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
            stackView.widthAnchor.constraint(equalToConstant: scrollView.contentSize.width),
            stackView.heightAnchor.constraint(equalToConstant: scrollView.contentSize.height)
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
        present(vc,animated: true)
    }
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            navigationController?.setNavigationBarHidden(true, animated: true)
            
        }
    }
}

