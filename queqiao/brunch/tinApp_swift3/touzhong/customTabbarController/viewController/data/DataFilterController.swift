//
//  DataFilterController.swift
//  touzhong
//
//  Created by zerlinda on 16/9/1.
//  Copyright © 2016年 zerlinda. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}


public enum AdvanceType:String{
    case invest,merge,exit,institution,enterprise,personage
}

class DataFilterController: CommonFilterController,UITableViewDataSource,UITableViewDelegate{
    
    var tableView:UITableView!
    var dataArr:[FilterViewModel] = [FilterViewModel]()
    var selectDic:[String:Any]? = [String:Any]()
    var  advanceT:AdvanceType?{
        didSet{
            fillData()
            filtSelectShowDic()
            tableView?.reloadData()
        }
    }
    var getFiltData: ((_ dic:[String:AnyObject])->())?
    var rememberFiltData: ((_ dic:[String:AnyObject])->())?
    var categoryModel:FilterViewModel = FilterViewModel()
    var fundModel:FilterViewModel = FilterViewModel()
    var timeModel:FilterViewModel = FilterViewModel()
    var roundsModel:FilterViewModel = FilterViewModel()
    var areaModel:FilterViewModel = FilterViewModel()
    var timeStrModel:FilterViewModel = FilterViewModel()
    var insTypeModel:FilterViewModel = FilterViewModel()
    var capitalFromsModel:FilterViewModel = FilterViewModel()
    var isOpenModel:FilterViewModel = FilterViewModel()
    var selectShowDic:[String:AnyObject]? = [String:AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
//    override func viewWillLayoutSubviews(){
//        super.viewWillLayoutSubviews()
//        
//    }
    override func createModule() {
        super.createModule()
        createTableView()
    }
    //MARK:取消或者完成
    override func btnAction(_ btn:UIButton){
        if btn.tag == 100 {
            for model in dataArr {
                model.selectArr = NSMutableArray()
            }
            selectDic = [String:Any]()
            rememberFiltData?(SafeUnwarp(selectShowDic, holderForNull: [String:AnyObject]())) //把选择的搜索内容发给dataviewController
            tableView.reloadData()
        }else{
            getData()
            getSelectShowDic()//把选择的show记下来
            getFiltData!(selectDic! as [String:AnyObject])
            rememberFiltData?(SafeUnwarp(selectShowDic, holderForNull: [String:AnyObject]())) //把选择的搜索内容发给dataviewController
            self.tapAction()
        }
    }
    //MARK:initdata
    
    func fillData(){
        self.dataArr = [FilterViewModel]()
        if self.advanceT == .invest {
            self.dataArr.append(fillCategoryModel())
            self.dataArr.append(fillRoundsModel())
            self.dataArr.append(fillTimeModel())
            self.dataArr.append(fillAreaModel())
            self.dataArr.append(fillFundModel())
        }
        if self.advanceT == .merge{
            self.dataArr.append(fillCategoryModel())
            self.dataArr.append(fillTimeModel())
            self.dataArr.append(fillAreaModel())
            self.dataArr.append(fillFundModel())
        }
        if self.advanceT == .exit{
            self.dataArr.append(fillCategoryModel())
            self.dataArr.append(fillTimeModel())
            self.dataArr.append(fillAreaModel())
            self.dataArr.append(fillFundModel())
        }
        if self.advanceT == .institution{
            self.dataArr.append(fillCategoryModel())
            self.dataArr.append(fillInsTypeModel())
            self.dataArr.append(fillCapitalSourceModel())
            self.dataArr.append(fillIsOpenModel())
        }
        if self.advanceT == .enterprise{
            self.dataArr.append(fillAreaModel())
            self.dataArr.append(fillCategoryModel())
            self.dataArr.append(fillRoundsModel())
        }
    }
    
    func fillCategoryModel()->FilterViewModel{
        categoryModel = FilterViewModel()
        categoryModel.showDic = ["全部":"","互联网服务":"00021","广告营销":"00022","电子商务":"00023","文体娱乐":"00024","金融":"00025","通信设备":"00026","移动互联网":"00027","游戏":"00028","工具软件":"00029","智能硬件":"00030","环保能源":"00031","化工制造":"00032","建筑建材":"00033","汽车交通":"00034","快递物流":"00043","农林牧渔":"00035","医疗健康":"00036","生活服务":"00037","教育":"00038","旅游":"00039","房地产":"00040"]
        categoryModel.showArray = ["全部","互联网服务","广告营销","电子商务","文体娱乐","金融","通信设备","移动互联网","游戏","工具软件","智能硬件","环保能源","化工制造","建筑建材","汽车交通","快递物流","农林牧渔","医疗健康","生活服务","教育","旅游","房地产"]
        categoryModel.categoryName = "行业"
        categoryModel.selectArr = ["全部"]
        return categoryModel
        
    }

    func fillRoundsModel()->FilterViewModel{
        
        roundsModel.showDic = ["全部":"","Angel":"0","Series A":"1","Series B":"2","Series C":"3","Series D":"4","Series E":"6","PIPE":"7","Growth":"8","Buyout":"9"]
        roundsModel.showArray = ["全部","Angel","Series A","Series B","Series C","Series D","Series E","PIPE","Growth","Buyout"]
        roundsModel.categoryName = "轮次"
        roundsModel.selectArr = ["全部"]
        return roundsModel
    }
    
    func fillAreaModel()->FilterViewModel{
        
        areaModel.showDic = ["全部":"","北京":"北京","上海":"上海","天津":"天津","广东":"广东","浙江":"浙江","江苏":"江苏","山东":"山东","福建":"福建"]
        areaModel.categoryName = "地区"
        areaModel.showArray = ["全部","北京","上海","天津","广东","浙江","江苏","山东","福建"]
        areaModel.selectArr = ["全部"]
        return areaModel
        
    }
    
    func fillTimeModel()->FilterViewModel{
        
        let systemTimeStr = Tools.getSystemTime()
        let  yearsStr = Tools.getYears(timeStr: systemTimeStr)
        let yearsInt = Tools.stringToInt(string: yearsStr)
        var showDic = ["不限":""]
        var showArr = ["不限"]
        for i in 2010...yearsInt{
            let dic = ["\(i)":"\(i)"]
            showDic.append(dic)
            showArr.append("\(i)")
        }
        timeModel.showDic = showDic
            //["不限":"","2010":"2010","2011":"2011","2012":"2012","2013":"2013","2014":"2014","2015":"2015","2016":"2016"]
        timeModel.showArray = showArr
            //["不限","2010","2011","2012","2013","2014","2015","2016"]
        timeModel.categoryName = "时间"
        return timeModel
        
    }
    
    func fillFundModel()->FilterViewModel{
        fundModel.moneyDic = ["全部":["-1","-1"],"<500万":["0","500"],"500~3000万":["500","3000"],"3000~9999万":["3000","9999"],"1~5亿":["10000","50000"],"5~10亿":["50000","100000"],"10亿+":["100000",""]]
        fundModel.showArray = ["全部","<500万","500~3000万","3000~9999万","1~5亿","5~10亿","10亿+"]
        fundModel.categoryName = "资金"
        fundModel.singleSelect = true
        fundModel.selectArr = ["全部"]
        return fundModel
    }
    
    func fillInsTypeModel()->FilterViewModel{
        
        insTypeModel.showDic = ["全部":"","VC":"1","PE":"2","VC/PE":"3","战略投资者":"4","券商直投":"8"]
        insTypeModel.showArray = ["全部","VC","PE","VC/PE","战略投资者","券商直投"]
        insTypeModel.categoryName = "机构类型"
        insTypeModel.selectArr = ["全部"]
        return insTypeModel
    }
    
    func fillCapitalSourceModel()->FilterViewModel{
        capitalFromsModel.showDic = ["全部":"","中资":"1","外资":"2","中/外资":"3","TL":"4"]
        capitalFromsModel.showArray = ["全部","中资","外资","中/外资","TL"]
        capitalFromsModel.categoryName = "资本来源"
        capitalFromsModel.selectArr = ["全部"]
        return capitalFromsModel
    }
    
    func fillIsOpenModel()->FilterViewModel{
        isOpenModel.showDic = ["全部":"","是":"1","否":"0"]
        isOpenModel.showArray = ["全部","是","否"]
        isOpenModel.categoryName = "是否开放"
        isOpenModel.selectArr = ["全部"]
        return isOpenModel
    }
    
    //MARK:获取高级搜索选择的Key
    func getData(){
        selectDic = [String:Any]()
        selectDic!["category"] = self.getCategoryData()
        selectDic!["rounds"] = self.getRoundsData()
        selectDic!["time"] = self.getTimeModel()
        selectDic!["area"] = self.getAreaData()
        selectDic!["fund"] = self.getFundData()
        selectDic!["insType"] = self.getInsTypeData()
        selectDic!["capitalFroms"] = self.getCapitalFromData()
        selectDic!["isOpen"] = self.getIsOpenData()
    }
    //MARK:获取高级搜索选择的内容(为了记住容器销毁后仍能记住)
    func getSelectShowDic(){
        selectShowDic = [String:AnyObject]()
        selectShowDic?["category"] = categoryModel.selectArr
        selectShowDic?["rounds"] = roundsModel.selectArr
        selectShowDic?["timeStartIndex"] = timeModel.startIndex as AnyObject?
        selectShowDic?["timeEndIndex"] = timeModel.endIndex as AnyObject?
        selectShowDic?["area"] = areaModel.selectArr
        selectShowDic?["fund"] = fundModel.selectArr
        selectShowDic?["insType"] = insTypeModel.selectArr
        selectShowDic?["capitalFroms"] = capitalFromsModel.selectArr
        selectShowDic?["isOpen"] = isOpenModel.selectArr
    }
    /// 把上次选中存下的字典自动填充
    func filtSelectShowDic(){
        categoryModel.selectArr =  SafeUnwarp(selectShowDic?["category"] as? NSMutableArray, holderForNull: ["全部"])
        roundsModel.selectArr = SafeUnwarp(selectShowDic?["rounds"] as? NSMutableArray, holderForNull: ["全部"])
        timeModel.selectArr = SafeUnwarp(selectShowDic?["time"] as? NSMutableArray, holderForNull: ["全部"])
        timeModel.endIndex = SafeUnwarp(selectShowDic?["timeEndIndex"] as! Int?, holderForNull: 0)
        timeModel.startIndex = SafeUnwarp(selectShowDic?["timeStartIndex"] as! Int?, holderForNull: 0)
        areaModel.selectArr = SafeUnwarp(selectShowDic?["area"] as? NSMutableArray, holderForNull: ["全部"])
        fundModel.selectArr = SafeUnwarp(selectShowDic?["fund"] as? NSMutableArray, holderForNull: ["全部"])
        insTypeModel.selectArr = SafeUnwarp(selectShowDic?["insType"] as? NSMutableArray, holderForNull: ["全部"])
        capitalFromsModel.selectArr = SafeUnwarp(selectShowDic?["capitalFroms"] as? NSMutableArray, holderForNull: ["全部"])
        isOpenModel.selectArr = SafeUnwarp(selectShowDic?["isOpen"] as? NSMutableArray, holderForNull: ["全部"])
    }
    
    func getCategoryData()->[String]{
        var arr:[String] = [String]()
        for str in categoryModel.selectArr{
            let value = categoryModel.showDic[str as! String]
            if  value != nil && value?.characters.count>0 {
                arr.append(value!)
            }
        }
        return arr
    }
    
    func getRoundsData()->[String]{
        var arr:[String] = [String]()
        for str in roundsModel.selectArr{
            let value = roundsModel.showDic[str as! String]
            if value != nil && value?.characters.count>0  {
                arr.append(value!)
            }
        }
        return arr
    }
    
    func getFundData()->[String]{
        var arr:[String] = [String]()
        for str in fundModel.selectArr{
            let value = fundModel.moneyDic![str as! String]
            if value != nil {
                arr = value!
            }else{
                arr = ["",""]
            }
        }
        return arr
    }
    
    func getAreaData()->[String]{
        var arr:[String] = [String]()
        for str in areaModel.selectArr{
            let value = areaModel.showDic[str as! String]
            if value != nil && value?.characters.count>0  {
                arr.append(value!)
            }
        }
        return arr
    }
    
    func getTimeModel()->[String]{
        var arr:[String] = [String]()
        if timeModel.showArray.count != 0 {
            let startKey = timeModel.showArray[timeModel.startIndex!]
            let endKey = timeModel.showArray[timeModel.endIndex!]
            arr.append(SafeUnwarp(timeModel.showDic[startKey], holderForNull: ""))
            arr.append(SafeUnwarp(timeModel.showDic[endKey], holderForNull: ""))
        }
        
        return arr
    }
    
    func getInsTypeData()->[String]{
        var arr:[String] = [String]()
        for str in insTypeModel.selectArr{
            let value = insTypeModel.showDic[str as! String]
            if value != nil && value?.characters.count>0  {
                arr.append(value!)
            }
        }
        return arr
    }
    
    func getCapitalFromData()->[String]{
        var arr:[String] = [String]()
        for str in capitalFromsModel.selectArr{
            let value = capitalFromsModel.showDic[str as! String]
            if value != nil && value?.characters.count>0  {
                arr.append(value!)
            }
        }
        return arr
    }
    
    func getIsOpenData()->[String]{
        var arr:[String] = [String]()
        for str in isOpenModel.selectArr{
            let value = isOpenModel.showDic[str as! String]
            if value != nil && value?.characters.count>0  {
                arr.append(value!)
            }
        }
        return arr
    }
    
    /**
     初始化tableView
     
     - author: zerlinda
     - date: 16-09-01 11:09:42
     */
    func createTableView(){
        tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        self.mainView.addSubview(tableView)
        tableView.frame = CGRect(x: 0, y: 20, width: self.mainView.frame.width, height: self.view.frame.height - 70)
        
    }
    
    //MARK:UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if dataArr[indexPath.row].categoryName == "时间"{
            let cellId = "timeCellId"
            var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? ChooseTimeCell
            if cell == nil {
                cell = ChooseTimeCell(style: UITableViewCellStyle.default, reuseIdentifier: cellId)
            }
            cell!.model = dataArr[indexPath.row]
            cell!.cellWidth = self.widthProportion*self.view.bounds.size.width
            cell!.selectionStyle = UITableViewCellSelectionStyle.none
            cell!.titleArr = timeModel.showArray
            cell!.indexPath = indexPath
            cell!.reloadCell = { indexPath,startTime in
                self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            }
            return cell!
        }
        
        let cellId = "cellId"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? FilterCell
        if cell  == nil{
            cell = FilterCell(style: UITableViewCellStyle.default, reuseIdentifier: cellId)
        }
        cell!.model = dataArr[indexPath.row]
        cell!.indexPath = indexPath
        cell!.selectionStyle = UITableViewCellSelectionStyle.none
        cell!.cellWidth = self.widthProportion*self.view.bounds.size.width
        cell!.indexPath = indexPath
        cell!.reloadCell = {indexPath in
            tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataArr[indexPath.row].cellHeight!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
