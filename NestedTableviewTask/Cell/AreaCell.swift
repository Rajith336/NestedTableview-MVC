//
//  AreaCell.swift
//  NestedTableviewTask
//
//  Created by Amshuhu  on 20/05/21.
//

import UIKit

class AreaCell: UITableViewCell,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var tblArea: UITableView!
    var areaList: [AreaList] = []
    var overallParentsection = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
        self.tblArea.tableFooterView = UIView()
        tblArea.isScrollEnabled = false
        tblArea.allowsSelection = false
        if let modData = UserDefaults.standard.object(forKey: "statemodel") as? Data {
            let decoder = JSONDecoder()
            if var model = try? decoder.decode([StateList].self, from: modData) {
                guard model.count > overallParentsection else { return }
                
                guard model[overallParentsection].districtList?.count ?? 0 > tblArea.tag else { return }
                
                self.areaList = model[overallParentsection].districtList?[tblArea.tag].areaList ?? []
                self.tblArea.reloadData()
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return areaList[section].shopList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShopCell", for: indexPath) as! ShopCell
        
        cell.lblShopName.text = areaList[indexPath.section].shopList?[indexPath.row]
        cell.backgroundColor = .green
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (areaList[indexPath.section].isExpanded ?? false) {
            return 50
        } else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let vw = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width-65, height: 50))
        lbl.text = areaList[section].areaName ?? ""
        let im = UIImageView(frame: CGRect(x: tableView.frame.width-65, y:0 , width: 25, height: 50))
        
        im.image = UIImage(named: "angle")
        if (areaList[section].isExpanded ?? false) {
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
        return areaList.count
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
                if  areaList[sender.tag].isExpanded != nil{
                    areaList[sender.tag].isExpanded?.toggle()
                    
                } else{
                    areaList[sender.tag].isExpanded = true
                    
                }
                if model[overallParentsection].districtList?[tblArea.tag].areaList?[sender.tag].isExpanded != nil {
                    model[overallParentsection].districtList?[tblArea.tag].areaList?[sender.tag].isExpanded?.toggle()
                } else{
                    model[overallParentsection].districtList?[tblArea.tag].areaList?[sender.tag].isExpanded = true
                }
                
                
                if let encoded = try? encoder.encode(model) {
                    let defaults = UserDefaults.standard
                    defaults.set(encoded, forKey: "statemodel")
                }
                NotificationCenter.default.post(name: Notification.Name("reload"), object: nil, userInfo: nil)
                self.tblArea.reloadData()
                
                
            }}
    }
    
    
}


