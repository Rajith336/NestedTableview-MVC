//
//  DistrictCell.swift
//  NestedTableviewTask
//
//  Created by Amshuhu  on 20/05/21.
//

import UIKit

class DistrictCell: UITableViewCell,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tblDistrict: UITableView!
    var districtList: [DistrictList] = []
    var parentsection = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
        self.tblDistrict.tableFooterView = UIView()
        tblDistrict.isScrollEnabled = false
        tblDistrict.allowsSelection = false
        
        if let modData = UserDefaults.standard.object(forKey: "statemodel") as? Data {
            let decoder = JSONDecoder()
            if let model = try? decoder.decode([StateList].self, from: modData) {
                guard model.count > tblDistrict.tag else { return }
                self.districtList = model[tblDistrict.tag].districtList ?? []
                self.tblDistrict.reloadData()
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return districtList[section].areaList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AreaCell", for: indexPath) as! AreaCell
        cell.tblArea.tag = indexPath.section
        cell.areaList = districtList[indexPath.section].areaList ?? []
        cell.overallParentsection = tableView.tag
        cell.tblArea.reloadData()
        cell.backgroundColor = .yellow
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (districtList[indexPath.section].isExpanded ?? false) {
            var totalheight = 0
            for area in districtList[indexPath.section].areaList ?? []{
                if area.isExpanded ?? false {
                    totalheight += ((area.shopList?.count ?? 0 ) * 50) + 50
                } else{
                    totalheight += 50
                }
                
            }
            
            return CGFloat(totalheight)
        } else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let vw = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width-45, height: 50))
        lbl.text = districtList[section].districtName ?? ""
        let im = UIImageView(frame: CGRect(x: tableView.frame.width-45, y:0 , width: 25, height: 50))
        
        im.image = UIImage(named: "angle")
        if (districtList[section].isExpanded ?? false) {
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
        return districtList.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    @objc func sectiontapped(_ sender:UIButton){
        print(sender.tag)
        if let modData = UserDefaults.standard.object(forKey: "statemodel") as? Data {
            let decoder = JSONDecoder()
            if var model = try? decoder.decode([StateList].self, from: modData) {
                // print(model)
                let encoder = JSONEncoder()
                if  districtList[sender.tag].isExpanded != nil{
                    districtList[sender.tag].isExpanded?.toggle()
                    
                } else{
                    districtList[sender.tag].isExpanded = true
                    
                }
                if model[tblDistrict.tag].districtList?[sender.tag].isExpanded != nil {
                    model[tblDistrict.tag].districtList?[sender.tag].isExpanded?.toggle()
                } else{
                    model[tblDistrict.tag].districtList?[sender.tag].isExpanded = true
                }
                
                
                if let encoded = try? encoder.encode(model) {
                    let defaults = UserDefaults.standard
                    defaults.set(encoded, forKey: "statemodel")
                }
                tblDistrict.reloadData()
                NotificationCenter.default.post(name: Notification.Name("reload"), object: nil, userInfo: nil)
            }}
        
    }
    
    
}
