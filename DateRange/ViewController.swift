//
// The MIT License (MIT)
//
// Copyright (c) 2015 Johannes Carlén, Wildberry
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import UIKit

class ViewController: UIViewController, DateRangeDelegate {
    
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var dateRangeContainerView: UIView!
    @IBOutlet weak var periodLabel: UILabel!
    
    var dateRangeView: DateRangeView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        upperView.backgroundColor = UIColor(22, 122, 182)
        dateRangeView = DateRangeView(frame: CGRectMake(0, 80, self.view.frame.width, 200))
        dateRangeView.delegate = self
        dateRangeView.setContentOffset(year: 2015, month: 3)
        
        self.view.addSubview(upperView)
        self.dateRangeContainerView.addSubview(dateRangeView)
        
        self.view.layoutIfNeeded()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dateSelected(#start: Int, end: Int) {
        println("Start: \(start) End:\(end)")
        // Format 201503
        let formatter = NSDateFormatter()
        let month1Index = (start % 100)
        let month1: String = formatter.monthSymbols[month1Index - 1] as! String
        var selectedString = "\(month1) \((start-month1Index)/100)"
        if(start != end) {
            let month2Index = (end % 100)
            let month2: String = formatter.monthSymbols[month2Index - 1] as! String
            selectedString += " - \(month2) \((end-month2Index)/100)"
        }
        self.periodLabel!.text = selectedString
    }
}

