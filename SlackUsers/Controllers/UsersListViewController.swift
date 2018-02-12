//
//  UsersListViewController.swift
//  SlackUsers
//
//  Created by Angad Manchanda on 2/11/18.
//  Copyright © 2018 Angad Manchanda. All rights reserved.
//

import UIKit

class UsersListViewController : UITableViewController {
    private let slackUserListRequestService = SlackUserListRequestService()
    private var slackMembers = [SlackMember]()
    private var slackMember : SlackMember!
    private var activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Slack Members"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.lightGray

        setupActivityIndicatorView()
        loadSlackMembers()
    }
}

// MARK:- Private Helpers
private extension UsersListViewController {
    func setupActivityIndicatorView() {
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        tableView?.backgroundView = activityIndicatorView
        
        let horizontalConstraint = NSLayoutConstraint(item: activityIndicatorView,
                                                      attribute: .centerX,
                                                      relatedBy: .equal,
                                                      toItem: tableView,
                                                      attribute: .centerX,
                                                      multiplier: 1,
                                                      constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: activityIndicatorView,
                                                    attribute: .centerY,
                                                    relatedBy: .equal,
                                                    toItem: tableView,
                                                    attribute: .centerY,
                                                    multiplier: 1,
                                                    constant: 0)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint])
    }
    
    func loadSlackMembers() {
        slackUserListRequestService.getUsersList { (members, errorMessage) in
            self.activityIndicatorView.stopAnimating()
            if members != nil || members!.count > 0 {
                self.slackMembers = members!
                self.tableView.reloadData()
            }
        }
    }
}

// MARK: - Data Source Methods
extension UsersListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.slackMembers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserListCell", for: indexPath) as UITableViewCell
        slackMember = self.slackMembers[indexPath.row]
        cell.textLabel?.text = slackMember.realName
        return cell
    }
}

//MARK:- Delegate Methods
extension UsersListViewController {
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
}
