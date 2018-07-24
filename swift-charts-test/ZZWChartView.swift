//
//  ZZWChartView.swift
//  haoqise
//
//  Created by jcgf on 2018/3/28.
//  Copyright © 2018年 jcgf. All rights reserved.
//

import UIKit


let color_5f4576 = hexColor(hex: "5f4576")
let color_ffffff = hexColor(hex: "ffffff")
let color_a1d955 = hexColor(hex: "a1d955")

class ZZWChartView: UIView {
    
    var displayLinkTimer:CADisplayLink? = nil
    
    var chartView: LineChartView?
    var pointArray = [String]()
    
    var displayLoopCount  = 0
    
    var rx : Double = 0
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        creatChartView()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func creatChartView()  {

        chartView = LineChartView()
        chartView?.frame = self.bounds

        self.addSubview(chartView!)

        //        chartView?.gridBackgroundColor = NSUIColor(red: 30/255.0, green: 46/255.0, blue: 65/255.0, alpha: 1.0)
        //        chartView?.drawGridBackgroundEnabled = true
        let yAxis = chartView?.leftAxis
        yAxis?.labelPosition = .outsideChart
        yAxis?.axisLineWidth = 1.0
        yAxis?.labelTextColor = UIColor.black
        //左侧值的个数
        yAxis?.setLabelCount(10, force: false)
        yAxis?.axisLineColor = UIColor.getTabbarColor(0x000000, alpha: 0.2)
        yAxis?.axisLineDashPhase = 1.0
        yAxis?.drawGridLinesEnabled = true
        yAxis?.gridLineDashPhase = CGFloat(1.0)
        //yAxis.axisLineDashLengths = [CGFloat(5.0),2.5]
        //绘制 破折号
        yAxis?.gridLineDashLengths = [CGFloat(2.0),1.0]
        yAxis?.drawTopYLabelEntryEnabled = true
        yAxis?.drawZeroLineEnabled = false
        
        yAxis?.axisMinimum = 0.0
        yAxis?.axisMaximum = 100.0
        
        
        let xAxis = chartView?.xAxis
        xAxis?.labelPosition = .bottom
        xAxis?.drawLabelsEnabled = true
        //        xAxis. = "m:h"
        xAxis?.axisMinimum = 0
        xAxis?.spaceMin = 1
        xAxis?.spaceMax = 1
        xAxis?.drawGridLinesEnabled = false
        xAxis?.avoidFirstLastClippingEnabled = false
        xAxis?.granularity = 1.0
        //                xAxis.setLabelCount(8, force: false)
        
        chartView?.chartDescription?.text = ""
        chartView?.scaleYEnabled = false
        chartView?.rightAxis.enabled = false
        chartView?.drawGridBackgroundEnabled = false
        chartView?.scaleXEnabled = true
        chartView?.setScaleMinima(4.0, scaleY: 1.0)
        
        chartView?.setScaleEnabled(true)
        chartView?.dragEnabled = true
        chartView?.dragDecelerationEnabled = false
        chartView?.dragDecelerationFrictionCoef = 0
        chartView?.pinchZoomEnabled = true
        
        //        lineChartView.setVisibleXRangeMaximum(2)
        chartView?.backgroundColor = UIColor.clear
        //lineChartView.animate(xAxisDuration: 1000)
        
        chartView?.doubleTapToZoomEnabled = false
        
        //[_chartView.viewPortHandler setMaximumScaleY: 2.f];
        //[_chartView.viewPortHandler setMaximumScaleX: 2.f];



        let marker = BalloonMarker(color: UIColor(white: 180/255, alpha: 1),
                                   font: .systemFont(ofSize: 12),
                                   textColor: .white,
                                   insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
        marker.chartView = chartView
        marker.minimumSize = CGSize(width: 80, height: 40)
        chartView?.marker = marker


        let legend:Legend = (chartView?.legend)!
        legend.enabled = false


        let data = LineChartData(dataSet: nil)

        chartView?.data = data


        chartView?.animate(xAxisDuration: 1.5)

        ///假数据
        addPointArrayData()
        moveToCurrentX()
    }
    
   
    //假数据
    func addPointArrayData() {
        
        for _ in 0..<100 {

            let arcSyr = String(format: "%d", arc4random_uniform(90))
            pointArray.append(arcSyr)

        }

    }
    
    
    func stopAnimation() {
        self.displayLinkTimer?.isPaused = true
        self.displayLinkTimer?.invalidate()
        self.displayLinkTimer = nil
    }
    
    func startAnimation() {
        self.displayLinkTimer?.isPaused = false
    }
    
   func moveToCurrentX()  {
        displayLinkTimer = CADisplayLink(target: self, selector: #selector(showData))
        displayLinkTimer?.isPaused = true
        displayLinkTimer?.frameInterval = 5     //每5帧处理一次 大概 一秒60/5次
        displayLinkTimer?.add(to: RunLoop.current, forMode: .commonModes)
    
    }
    

    @objc func showData()  {
        
        self.addPoints(pointArray: pointArray)
        if displayLoopCount  < (pointArray.count - 1) {
            displayLoopCount += 1
        }
        
    }


    
    func addPoints(pointArray:[String]) {

            self.updataChartData(x: self.rx, y: Double(pointArray[displayLoopCount].hexStringToInt()))
            self.rx =  self.rx + 0.2

    }
    
    
    @objc func updataChartDataDisplayLinkTimer()  {
        
    }
    

    func updataChartData(x: Double, y: Double) {

        self.addEntry(x: x, y: y, dataSetIndex: 0)
//            self.addEntry(x: x, y: y, dataSetIndex: 1)

    }
    
    
    func addEntry(x: Double, y: Double,dataSetIndex: Double) {

            let linedata = self.chartView?.lineData

            if linedata != nil {
                var lineset = linedata?.getDataSetByIndex(0)
                if lineset == nil {
                    lineset = self.creatDataSet()
                    linedata?.addDataSet(lineset)
                }

                linedata?.addEntry(ChartDataEntry(x:x,y:y), dataSetIndex: 0)

                linedata?.notifyDataChanged()
                self.chartView?.notifyDataSetChanged()
                self.chartView?.setVisibleXRangeMaximum(4.9)

  
                self.chartView?.moveViewToX(Double((linedata?.entryCount)!) )

            }
    
        }
    
    

        func clearValuse() {
            let linedata = chartView?.lineData
            if linedata != nil {
                linedata?.clearValues()
            }
            chartView?.initialize()
        }
    
    
        func creatDataSet() -> LineChartDataSet {
           
    
            let colorspace = CGColorSpaceCreateDeviceRGB()
            let lineChartDataSet2 = LineChartDataSet(values: nil, label: "")
            //        let colorLineAfter = UIColor.getTabbarColor(0x75d1cd, alpha: 1.0)
            let colorLineAfter = color_5f4576
            lineChartDataSet2.setColor(colorLineAfter)
            lineChartDataSet2.mode = .cubicBezier
            //        lineChartDataSet2.axisDependency = .right
            lineChartDataSet2.drawCirclesEnabled = false
            lineChartDataSet2.lineWidth = 1.0
            lineChartDataSet2.circleRadius = 3.0
            lineChartDataSet2.cubicIntensity = 0.2
            lineChartDataSet2.circleColors = [colorLineAfter]
            lineChartDataSet2.drawCircleHoleEnabled = true
            lineChartDataSet2.circleHoleColor = UIColor.white
            lineChartDataSet2.circleHoleRadius = 2.0
            lineChartDataSet2.drawFilledEnabled = true
    
            let gradientColors = [color_ffffff.cgColor,
                                  color_a1d955.cgColor]
            let gradient = CGGradient(colorsSpace: colorspace, colors: gradientColors as CFArray, locations: nil)!
    
            lineChartDataSet2.fill = Fill(linearGradient: gradient, angle: 90.0)
            lineChartDataSet2.drawValuesEnabled = false
            
            lineChartDataSet2.drawHorizontalHighlightIndicatorEnabled = false
            lineChartDataSet2.drawVerticalHighlightIndicatorEnabled = false
    
            return lineChartDataSet2
            
        }
    

}

extension UIColor {
    
    //状态栏颜色
    class func statusBargroundColor() ->UIColor{
        return getTabbarColor(0x5f4576, alpha: 0.85)
        
    }
    //主色调
    class func themeBackgroundColor() -> UIColor{
        return getTabbarColor(0xa1d955, alpha: 1.0)    }
    
    class func getTabbarColor(_ valueRGB: UInt, alpha: CGFloat) ->UIColor {
        return UIColor(
            red: CGFloat((valueRGB & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((valueRGB & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(valueRGB & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}




open class BalloonMarker: MarkerImage
{
    open var color: UIColor
    open var arrowSize = CGSize(width: 15, height: 11)
    open var font: UIFont
    open var textColor: UIColor
    open var insets: UIEdgeInsets
    open var minimumSize = CGSize()
    
    fileprivate var label: String?
    fileprivate var _labelSize: CGSize = CGSize()
    fileprivate var _paragraphStyle: NSMutableParagraphStyle?
    fileprivate var _drawAttributes = [NSAttributedStringKey : AnyObject]()
    
    public init(color: UIColor, font: UIFont, textColor: UIColor, insets: UIEdgeInsets)
    {
        self.color = color
        self.font = font
        self.textColor = textColor
        self.insets = insets
        
        _paragraphStyle = NSParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle
        _paragraphStyle?.alignment = .center
        super.init()
    }
    
    open override func offsetForDrawing(atPoint point: CGPoint) -> CGPoint
    {
        var offset = self.offset
        var size = self.size
        
        if size.width == 0.0 && image != nil
        {
            size.width = image!.size.width
        }
        if size.height == 0.0 && image != nil
        {
            size.height = image!.size.height
        }
        
        let width = size.width
        let height = size.height
        let padding: CGFloat = 8.0
        
        var origin = point
        origin.x -= width / 2
        origin.y -= height
        
        if origin.x + offset.x < 0.0
        {
            offset.x = -origin.x + padding
        }
        else if let chart = chartView,
            origin.x + width + offset.x > chart.bounds.size.width
        {
            offset.x = chart.bounds.size.width - origin.x - width - padding
        }
        
        if origin.y + offset.y < 0
        {
            offset.y = height + padding;
        }
        else if let chart = chartView,
            origin.y + height + offset.y > chart.bounds.size.height
        {
            offset.y = chart.bounds.size.height - origin.y - height - padding
        }
        
        return offset
    }
    
    open override func draw(context: CGContext, point: CGPoint)
    {
        guard let label = label else { return }
        
        let offset = self.offsetForDrawing(atPoint: point)
        let size = self.size
        
        var rect = CGRect(
            origin: CGPoint(
                x: point.x + offset.x,
                y: point.y + offset.y),
            size: size)
        rect.origin.x -= size.width / 2.0
        rect.origin.y -= size.height
        
        context.saveGState()
        
        context.setFillColor(color.cgColor)
        
        if offset.y > 0
        {
            context.beginPath()
            context.move(to: CGPoint(
                x: rect.origin.x,
                y: rect.origin.y + arrowSize.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x + (rect.size.width - arrowSize.width) / 2.0,
                y: rect.origin.y + arrowSize.height))
            //arrow vertex
            context.addLine(to: CGPoint(
                x: point.x,
                y: point.y))
            context.addLine(to: CGPoint(
                x: rect.origin.x + (rect.size.width + arrowSize.width) / 2.0,
                y: rect.origin.y + arrowSize.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x + rect.size.width,
                y: rect.origin.y + arrowSize.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x + rect.size.width,
                y: rect.origin.y + rect.size.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x,
                y: rect.origin.y + rect.size.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x,
                y: rect.origin.y + arrowSize.height))
            context.fillPath()
        }
        else
        {
            context.beginPath()
            context.move(to: CGPoint(
                x: rect.origin.x,
                y: rect.origin.y))
            context.addLine(to: CGPoint(
                x: rect.origin.x + rect.size.width,
                y: rect.origin.y))
            context.addLine(to: CGPoint(
                x: rect.origin.x + rect.size.width,
                y: rect.origin.y + rect.size.height - arrowSize.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x + (rect.size.width + arrowSize.width) / 2.0,
                y: rect.origin.y + rect.size.height - arrowSize.height))
            //arrow vertex
            context.addLine(to: CGPoint(
                x: point.x,
                y: point.y))
            context.addLine(to: CGPoint(
                x: rect.origin.x + (rect.size.width - arrowSize.width) / 2.0,
                y: rect.origin.y + rect.size.height - arrowSize.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x,
                y: rect.origin.y + rect.size.height - arrowSize.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x,
                y: rect.origin.y))
            context.fillPath()
        }
        
        if offset.y > 0 {
            rect.origin.y += self.insets.top + arrowSize.height
        } else {
            rect.origin.y += self.insets.top
        }
        
        rect.size.height -= self.insets.top + self.insets.bottom
        
        UIGraphicsPushContext(context)
        
        label.draw(in: rect, withAttributes: _drawAttributes)
        
        UIGraphicsPopContext()
        
        context.restoreGState()
    }
    
    open override func refreshContent(entry: ChartDataEntry, highlight: Highlight)
    {
        setLabel(String(entry.y))
    }
    
    open func setLabel(_ newLabel: String)
    {
        label = newLabel
        
        _drawAttributes.removeAll()
        _drawAttributes[.font] = self.font
        _drawAttributes[.paragraphStyle] = _paragraphStyle
        _drawAttributes[.foregroundColor] = self.textColor
        
        _labelSize = label?.size(withAttributes: _drawAttributes) ?? CGSize.zero
        
        var size = CGSize()
        size.width = _labelSize.width + self.insets.left + self.insets.right
        size.height = _labelSize.height + self.insets.top + self.insets.bottom
        size.width = max(minimumSize.width, size.width)
        size.height = max(minimumSize.height, size.height)
        self.size = size
    }
}

