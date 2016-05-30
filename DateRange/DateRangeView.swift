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

protocol DateRangeDelegate {
    // Använder formatet yyyyMM för att definiera start och slut. MM är 1...12
    func dateSelected(start start: Int, end: Int)
}

class DateRangeView: UIView {

    var delegate: DateRangeDelegate! = nil

    private var startYear = 2010
    private var endYear = 2016

    private var scrollView: UIScrollView!
    private var selectedRangeView: UIView!
    private var todayButton: UIButton!

    private var startOffset: Int = 0

    private var selectedStart: Int = 0
    private var selectedEnd: Int = 0

    private let monthButtonWidth: CGFloat = 78
    private let buttonHeight: CGFloat = 48
    private let yearButtonWidth: CGFloat = 48
    private let selectedHeight: CGFloat = 72

    private let yPosition: CGFloat = -10

    private let todayRadius: CGFloat = 15

    private var months = [Int: CGFloat]()
    private let monthNames: [String] = ["Jan", "Feb", "Mar", "Apr", "Maj", "Jun", "Jul", "Aug", "Sep", "Okt", "Nov", "Dec"]

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = UIColor.whiteColor()
        scrollView = UIScrollView(frame: CGRectMake(0, 0, frame.width, frame.height))
        scrollView.showsHorizontalScrollIndicator = false
        selectedRangeView = UIView(frame: CGRectZero)
        selectedRangeView.backgroundColor = UIColor(205, 227, 240)
        selectedRangeView.layer.cornerRadius = selectedHeight / 4;
        scrollView.addSubview(selectedRangeView)

        todayButton = UIButton(frame: CGRectZero)
        todayButton.backgroundColor = UIColor.whiteColor()
        todayButton.layer.cornerRadius = todayRadius
        todayButton.layer.borderColor = UIColor(19, 114, 181).CGColor;
        todayButton.layer.borderWidth = 1;
        todayButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Light", size: 10)
        todayButton.setTitleColor(UIColor(19, 114, 181), forState: .Normal)
        todayButton.setTitle("Idag", forState: UIControlState.Normal)
        todayButton.addTarget(self, action: #selector(DateRangeView.btnPressed(_:)), forControlEvents: .TouchUpInside)
        todayButton.tag = today()
        scrollView.addSubview(todayButton)

        addSubview(scrollView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        layoutScrollView()
    }

    private func layoutScrollView() {

        self.frame = CGRectMake(0, 0, superview!.frame.width, superview!.frame.height)
        scrollView.frame = CGRectMake(0, 0, self.frame.width, self.frame.height)
        var xPosition: CGFloat = monthButtonWidth

        for currentYear in startYear...endYear {
            let btn: UIButton = UIButton(frame: CGRectMake(xPosition, yPosition, yearButtonWidth, buttonHeight))
            xPosition += (yearButtonWidth + (monthButtonWidth - yearButtonWidth) / 2)
            btn.backgroundColor = UIColor.headerBackgroundColor()
            btn.layer.cornerRadius = yearButtonWidth / 2;

            btn.titleLabel!.font = UIFont(name: "HelveticaNeue-Light", size: 14)
            btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            btn.titleLabel!.textColor = UIColor.whiteColor()
            btn.setTitle("\(currentYear)", forState: UIControlState.Normal)
            btn.addTarget(self, action: #selector(DateRangeView.btnPressed(_:)), forControlEvents: .TouchUpInside)
            btn.tag = currentYear * 100

            scrollView.addSubview(btn)

            for month in 1 ... 12 {
                self.scrollView.addSubview(createMonthButton(currentYear, month: month, xPosition: xPosition))
                let key = currentYear * 100 + month
                months[key] = xPosition
                xPosition += monthButtonWidth
            }
        }

        let scrollSize = CGSizeMake(xPosition + monthButtonWidth, frame.height)
        scrollView.contentSize = scrollSize

        // Today button
        let thisMonthsOffset = offset(yearMonth: 201605)
        self.todayButton.frame = CGRectMake(thisMonthsOffset + monthButtonWidth / 2 - todayRadius, 30, todayRadius * 2, todayRadius * 2)

        if (startOffset != 0) {
            setContentOffset(yearMonth: startOffset)
            startOffset = 0
        }
    }

    private func createMonthButton(year: Int, month: Int, xPosition: CGFloat) -> UIButton {
        let btn: UIButton = UIButton(frame: CGRectMake(xPosition, yPosition, monthButtonWidth, buttonHeight))
        btn.titleLabel!.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        btn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        btn.setTitle(monthNames[month - 1], forState: UIControlState.Normal)
        btn.addTarget(self, action: #selector(DateRangeView.btnPressed(_:)), forControlEvents: .TouchUpInside)
        btn.tag = year * 100 + month
        return btn
    }

    func btnPressed(sender: UIButton!) {

        let selected = sender?.tag

        if (selected! % 100 == 0) {
            selectedStart = selected! + 1
            selectedEnd = selected! + 12
        } else {
            if (selected >= selectedStart && selected <= selectedEnd || selectedStart == 0) {
                if (selectedStart == selectedEnd && selectedStart != 0) {
                    selectedStart = 0
                    selectedEnd = 0
                } else {
                    selectedStart = selected!
                    selectedEnd = selected!
                }
            } else {
                if (selected > selectedEnd) {
                    selectedEnd = selected!
                } else {
                    selectedStart = selected!
                }
            }
        }
        var selectedFrame = CGRectZero
        if (selectedStart != 0) {
            let xPosition = months[selectedStart]!
            let width = months[selectedEnd]! + monthButtonWidth - xPosition
            selectedFrame = CGRectMake(xPosition, yPosition - 24, width, selectedHeight)
        }
        selectedRangeView.frame = selectedFrame
        delegate!.dateSelected(start: selectedStart, end: selectedEnd)
    }

    func setContentOffset(year year: Int, month: Int) {
        let offset = year * 100 + month
        setContentOffset(yearMonth: offset)
    }

    private func setContentOffset(yearMonth yearMonth: Int) {
        var xPosition = offset(yearMonth: yearMonth)
        if xPosition != 0 {
            xPosition = xPosition - frame.width / 2 + monthButtonWidth
            self.scrollView.setContentOffset(CGPointMake(CGFloat(xPosition), 0), animated: false)
        } else {
            self.startOffset = yearMonth
        }
    }

    private func offset(yearMonth yearMonth: Int) -> CGFloat {
        var resultOffset: CGFloat = 0
        if let x = months[yearMonth] {
            resultOffset = x
        }
        return resultOffset
    }

    private func today() -> Int {
        let flags: NSCalendarUnit = [.Day, .Month, .Year]
        let components = NSCalendar.currentCalendar().components(flags, fromDate: NSDate())
        return components.year * 100 + components.month
    }
}
