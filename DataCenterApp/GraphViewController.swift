//
//  GraphViewController.swift
//  DataCenterApp
//
//  Created by Michael Fulton Jr. on 3/20/16.
//  Copyright © 2016 Michael Fulton Jr. All rights reserved.
//

import UIKit
import Charts

class GraphViewController: UIViewController {
    @IBOutlet weak var savedView: UIView!

    @IBAction func saveChart(sender: UIBarButtonItem) {
        self.graphView.saveToCameraRoll()
        self.savedView.hidden = false
        if savedView.alpha == 1.0 {
            UIView.animateWithDuration(1.5, delay: 0, options: .CurveLinear  , animations: { self.savedView.alpha = 0}, completion: {if $0 {
            self.savedView.hidden = true
                self.savedView.alpha = 1.0}})
        }
    }
    @IBOutlet weak var graphView: LineChartView!
    var data: ChartData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        graphView.xAxis.labelPosition = .Bottom
        graphView.animate(xAxisDuration: 0.5, yAxisDuration: 0.5, easingOption: .EaseInBounce)
        graphView.data = data
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
