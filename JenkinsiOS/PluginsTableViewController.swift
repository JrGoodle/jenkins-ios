//
//  PluginsTableViewController.swift
//  JenkinsiOS
//
//  Created by Robert on 12.10.16.
//  Copyright © 2016 MobiLab Solutions. All rights reserved.
//

import UIKit

class PluginsTableViewController: UITableViewController {

    var account: Account?
    var pluginList: PluginList?{
        didSet{
            guard let pluginList = pluginList
                else { return }
            
            pluginData = pluginList.plugins.map({ (plugin) -> [(String, String, UIColor)] in
                return data(for: plugin)
            })
        }
    }
    
    var pluginData: [[(String, String, UIColor)]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addRefreshControl(action: #selector(performRequest))
        title = "Plugins"
        performRequest()
    }

    @objc private func performRequest(){
        
        guard let account = account
            else { return }
        
        NetworkManager.manager.getPlugins(userRequest: UserRequest.userRequestForPlugins(account: account)) { (pluginList, error) in
            
            DispatchQueue.main.async {
                if let error = error{
                    self.displayNetworkError(error: error, onReturnWithTextFields: { (returnData) in
                        self.account?.username = returnData["username"]!
                        self.account?.password = returnData["password"]!
                        
                        self.performRequest()
                    })
                }
                self.pluginList = pluginList
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        }
    }

    private func data(for plugin: Plugin) -> [(String, String, UIColor)]{
        var data = [
            ("Name", plugin.longName ?? plugin.shortName, UIColor.clear),
            ("Active", "\(plugin.active)", UIColor.clear),
            ("Has Update", "\((plugin.hasUpdate).textify())", UIColor.clear),
            ("Enabled", "\((plugin.enabled).textify())", UIColor.clear),
            ("Version", "\((plugin.version).textify())", UIColor.clear),
            ("Supports Dynamic Load", "\((plugin.supportsDynamicLoad).textify())", UIColor.clear)
        ]
        
        if plugin.dependencies.count > 0{
            data.append(("Dependencies", "", UIColor.groupTableViewBackground))
        }
        
        for dependency in plugin.dependencies{
            data.append(("", "\(dependency.shortName) at v\(dependency.version)", UIColor.groupTableViewBackground))
        }
        
        return data
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return pluginList?.plugins.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pluginData[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.pluginCell, for: indexPath)
        
        cell.textLabel?.text = pluginData[indexPath.section][indexPath.row].0
        cell.detailTextLabel?.text = pluginData[indexPath.section][indexPath.row].1
        cell.backgroundColor = pluginData[indexPath.section][indexPath.row].2
        
        if pluginData[indexPath.section][indexPath.row].2 == UIColor.groupTableViewBackground {
            let attributedString = NSAttributedString(string: pluginData[indexPath.section][indexPath.row].0, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 17)])
            cell.textLabel?.attributedText = attributedString
        }
        
        return cell
    }
 
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return pluginList?.plugins[section].longName ?? pluginList?.plugins[section].shortName
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}