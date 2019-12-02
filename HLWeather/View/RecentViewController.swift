//
//  RecentViewController.swift
//  HLWeather
//
//  Created by harry on 1/12/19.
//  Copyright © 2019 Harry. All rights reserved.
//

import UIKit

class RecentResultViewController: UITableViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
     
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let s = RecentSearch.shared.getList()[indexPath.row]
        self.dismiss(animated: true) {
            if case let vc as ViewController = UIApplication.shared.windows.first?.rootViewController {
                vc.startSearch(s)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RecentSearch.shared.getList().count
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let v = UIView(frame: CGRect(x: 0, y: 2, width: self.tableView.bounds.width, height: 36))
        let ba = UIButton(type: .system)
        ba.setTitle("Clear", for: .normal)
        ba.frame = CGRect(x: self.tableView.bounds.width / 8, y: 0, width: self.tableView.bounds.width / 4, height: 34)
        ba.addTarget(self, action: #selector(clearVC), for: .touchUpInside)
        let bb = UIButton(type: .system)
        bb.setTitle("Close", for: .normal)
        bb.frame = CGRect(x: self.tableView.bounds.width / 2, y: 0, width: self.tableView.bounds.width / 4, height: 34)
        bb.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
        self.customizeButton(bb)
        self.customizeButton(ba)
        v.addSubview(ba)
        v.addSubview(bb)
        return v
    }
    
    @objc func closeVC() {
        self.dismiss(animated: true) {
        }
    }
    
    @objc func clearVC() {
        RecentSearch.shared.removeAll()
        self.tableView.reloadData()
    }

    func customizeButton(_ b: UIButton) {
        b.layer.borderWidth = 0.5
        b.layer.cornerRadius = 5.0
        b.layer.borderColor = UIColor.clear.cgColor
        b.layer.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = RecentSearch.shared.getList()[indexPath.row]
        return cell
    }
}
