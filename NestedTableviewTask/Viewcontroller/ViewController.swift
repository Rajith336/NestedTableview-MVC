//
//  ViewController.swift
//  NestedTableviewTask
//
//  Created by Amshuhu  on 20/05/21.
//

import UIKit

class ViewController: UIViewController {
    //Mark:- Initialization
    @IBOutlet weak var tblState: UITableView!
    var arrayModel:[StateList] = []
    
    
    //Mark:- ViewLifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(onNotification(notification:)), name: Notification.Name("reload"), object: nil)
        initUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    //Mark:- Button Actions
    @objc func sectiontapped(_ sender:UIButton) {
        print(sender.tag)
        let encoder = JSONEncoder()
        if  arrayModel[sender.tag].isExpanded != nil{
            arrayModel[sender.tag].isExpanded?.toggle()
        } else{
            arrayModel[sender.tag].isExpanded = true
        }
        
        if let encoded = try? encoder.encode(arrayModel) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "statemodel")
        }
        tblState.reloadData()
    }
    
    @objc func onNotification(notification:Notification) {
        DispatchQueue.main.async {
            if let modData = UserDefaults.standard.object(forKey: "statemodel") as? Data {
                let decoder = JSONDecoder()
                if let model = try? decoder.decode([StateList].self, from: modData) {
                    // print(model)
                    self.arrayModel = model
                }}
            self.tblState.reloadData()
        }
        
    }
    //Mark:- Local Methods
    func initUI(){
        tblState.tableFooterView = UIView()
        tblState.allowsSelection = false
        
        let encoder = JSONEncoder()
        if let modData = self.readLocalFile(forName: "jsonState"){
            let decoder = JSONDecoder()
            if var model = try? decoder.decode(State.self, from: modData) {
                self.arrayModel = model.stateList ?? []
                
                if let encoded = try? encoder.encode(model) {
                    let defaults = UserDefaults.standard
                    defaults.set(encoded, forKey: "statemodel")
                }
            }}
        tblState.reloadData()
        
    }
    
    private func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name,
                                                 ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return nil
    }
}

//Mark:- UITableViewDelegate
extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DistrictCell", for: indexPath) as! DistrictCell
        cell.tblDistrict.tag = indexPath.section
        cell.districtList = arrayModel[indexPath.section].districtList ?? []
        cell.tblDistrict.reloadData()
        cell.backgroundColor = .red
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var totalheight = 0
        
        for district in arrayModel[indexPath.section].districtList ?? []{
            
            if district.isExpanded ?? false {
                
                for area in district.areaList ?? []{
                    
                    if area.isExpanded ?? false {
                        totalheight += ((area.shopList?.count ?? 0 ) * 50) + 50 //shop list rows + shop list header name
                        
                    } else{
                        totalheight += 50
                        
                    }
                    
                }
                totalheight += 50 //district header height
            } else{
                totalheight += 50
            }
            
            
        }
        
        if (arrayModel[indexPath.section].isExpanded ?? false) {
            return CGFloat(totalheight)
        } else{
            return 0
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width-25, height: 50))
        lbl.text = arrayModel[section].stateName ?? ""
        let im = UIImageView(frame: CGRect(x: tableView.frame.width-25, y:0 , width: 25, height: 50))
        
        im.image =  UIImage(named: "angle")
        if (arrayModel[section].isExpanded ?? false) {
            im.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
        } else{
            im.transform = CGAffineTransform.identity
        }
        
        im.tintColor = .lightGray
        im.contentMode = .scaleAspectFit
        vw.addSubview(im)
        vw.addSubview(lbl)
        
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        btn.tag = section
        btn.addTarget(self, action: #selector(self.sectiontapped(_:)), for: .touchUpInside)
        vw.addSubview(btn)
        return vw
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayModel.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    
    
}
