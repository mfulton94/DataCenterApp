//
//  DetailViewController.swift
//  DataCenterApp
//
//  Created by Michael Fulton Jr. on 3/20/16.
//  Copyright © 2016 Michael Fulton Jr. All rights reserved.
//

import UIKit
import Charts

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
    @IBOutlet weak var dataTableView: UITableView!
    var dataArray: [Data!] = []
    var selectedComponent: String!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "sectionHeader", bundle: nil)
        dataTableView.registerNib(nib, forHeaderFooterViewReuseIdentifier: "sectionHeader")
        var data: Data! = Data()

        for i in 1..<12 {
            data.time = "\(i):15 am"
            data.value = Double(arc4random_uniform(400))
            dataArray.append(data)
        }
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.title = self.selectedComponent
        self.navigationController?.navigationBar.tintColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1.0)]
     
    }
    override func viewWillDisappear(animated: Bool) {
   
    
    }

    override func viewDidDisappear(animated: Bool) {
        

    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return dataArray.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("graphCell", forIndexPath: indexPath) as! GraphTableViewCell
            cell.graphView.noDataText = "No Results"
            var dataEntries: [ChartDataEntry] = []
            var dataPoints: [String?]? = []
            cell.graphView.xAxis.labelPosition = .Bottom
            cell.graphView.animate(xAxisDuration: 0.5, yAxisDuration: 0.5, easingOption: .EaseInBounce)
            var index = 0
            for data in dataArray {
                let dataEntry = ChartDataEntry(value: data.value, xIndex:index)
                dataEntries.append(dataEntry)
                dataPoints?.append(data.time)
                index += 1;
            }
            
            let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "Data Center Values")
            let lineChartData = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)
            cell.graphView.data = lineChartData
            

            return cell
            
        } else {
             let cell = tableView.dequeueReusableCellWithIdentifier("dataCell", forIndexPath: indexPath) as! dataTableViewCell
            cell.timeLabel.text = dataArray[indexPath.row].time
            cell.valueLabel.text = "\(dataArray[indexPath.row].value)"
            return cell
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let index = dataTableView.indexPathForSelectedRow
        let cell = dataTableView.cellForRowAtIndexPath(index!) as! GraphTableViewCell
        (segue.destinationViewController as! GraphViewController).data = cell.graphView.data
        
    }
    

    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 210.0
        }
 
        return 44
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let cell = tableView.dequeueReusableHeaderFooterViewWithIdentifier("sectionHeader") as! dataSectionHeader
        
            return cell
        }
        return UIView()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    
    
}
