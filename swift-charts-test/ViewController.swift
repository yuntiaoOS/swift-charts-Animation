//
//  ViewController.swift
//  swift-charts-test
//
//  Created by ma c on 2018/7/23.
//  Copyright © 2018年 ma c. All rights reserved.
//

import UIKit
// 屏幕宽度
let kScreenH = UIScreen.main.bounds.height
// 屏幕高度
let kScreenW = UIScreen.main.bounds.width
class ViewController: UIViewController {
    var chartViewV: ZZWChartView?
    
    override func viewDidLoad() {
        super.viewDidLoad()


        chartViewFunc()
       
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //增加假数据
        chartViewV?.addPointArrayData()

    }

    func chartViewFunc() {
        chartViewV = ZZWChartView.init(frame: CGRect(x: 0, y: 100, width: kScreenW, height: 311))
        self.view.addSubview(chartViewV!)
        chartViewV?.moveToCurrentX()
        chartViewV?.startAnimation()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}




