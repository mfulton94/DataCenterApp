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
    var dataArray: [DataNow] = []
    var selectedComponent: String!
    var power = Power()
    var powerArray:[String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "sectionHeader", bundle: nil)
        dataTableView.registerNib(nib, forHeaderFooterViewReuseIdentifier: "sectionHeader")
       

       
        
        
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
    
    /*
     "CHWS (Chilled Water Supply)": 44,
     "CHWR (Chilled Water Returned)": 53,
     "CWS (Condenser Water Supply)": 79,
     "CWR (Condeser Water Returned)": 89,
     
     */
    
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
                var value: Double!
                switch selectedComponent {
                    case "Chiller":
                        value = power.data[indexPath.row]["Compressor Energy Usage kW"]
                    
                    case "Chilled Water Pump":
                        value = power.data[indexPath.row]["Chilled Water Pump kW"]
                    
                    case "Cold Water Pump":
                        value = power.data[indexPath.row]["Condenser Water Pump kW"]
                    
                    case "Cooling Tower":
                        value = power.data[indexPath.row]["Power of Cooling Tower kW"]
                default:
                    print("hello")
                }
                let dataEntry = ChartDataEntry(value: value, xIndex:index)
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
            
            if let time = dataArray[indexPath.row].time {
            cell.timeLabel.text = time
                print(time)
                
            }
            var value: Double!
            switch selectedComponent {
            case "Chiller":
                value = power.data[indexPath.row]["Compressor Energy Usage kW"]
                
            case "Chilled Water Pump":
                value = power.data[indexPath.row]["Chilled Water Pump kW"]
                
                
            case "Cold Water Pump":
                value = power.data[indexPath.row]["Condenser Water Pump kW"]
                
            case "Cooling Tower":
                value = power.data[indexPath.row]["Power of Cooling Tower kW"]
            default:
                print("hello")
            }

            
            cell.valueLabel.text = "\(value)"
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
