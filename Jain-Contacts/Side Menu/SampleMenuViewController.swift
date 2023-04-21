//
// SampleMenuViewController.swift
//
// Copyright 2017 Handsome LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import UIKit
import InteractiveSideMenu

/**
 Menu controller is responsible for creating its content and showing/hiding menu using 'menuContainerViewController' property.
 */
class SampleMenuViewController: MenuViewController, Storyboardable {

    var arrMenuItm = [SidemenuContent.s_home.rawValue,
                      SidemenuContent.s_shareLink.rawValue,
                      SidemenuContent.s_feedback.rawValue,
                      SidemenuContent.s_login.rawValue]
    @IBOutlet fileprivate weak var tableView: UITableView!
    @IBOutlet fileprivate weak var avatarImageView: UIImageView!
    @IBOutlet fileprivate weak var avatarImageViewCenterXConstraint: NSLayoutConstraint!
    private var gradientLayer = CAGradientLayer()

    private var gradientApplied: Bool = false

    override var prefersStatusBarHidden: Bool {
        return false
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if _userDefault.bool(forKey: eUserDefaultsKey.key_isLogin.rawValue) {
            self.arrMenuItm = [SidemenuContent.s_home.rawValue,
                               SidemenuContent.s_profile.rawValue,
                               SidemenuContent.s_shareLink.rawValue,
                               SidemenuContent.s_feedback.rawValue,
                               SidemenuContent.s_logout.rawValue]
        }
        
        //Register Cell
        self.tableView.register(UINib.init(nibName: "SideMenuTableCell", bundle: nil), forCellReuseIdentifier: "SideMenuTableCell")
        
        //***********************************************//
        
        // Select the initial row
        tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: UITableView.ScrollPosition.none)

        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width/2
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        avatarImageViewCenterXConstraint.constant = -(menuContainerViewController?.transitionOptions.visibleContentWidth ?? 0.0)/2

        if gradientLayer.superlayer != nil {
            gradientLayer.removeFromSuperlayer()
        }
        let topColor = UIColor(red: 16.0/255.0, green: 12.0/255.0, blue: 54.0/255.0, alpha: 1.0)
        let bottomColor = UIColor(red: 57.0/255.0, green: 33.0/255.0, blue: 61.0/255.0, alpha: 1.0)
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
        
    }

    deinit{
        print()
    }
}

extension SampleMenuViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrMenuItm.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SideMenuTableCell.self), for: indexPath) as? SideMenuTableCell else {
            preconditionFailure("Unregistered table view cell")
        }
        
        cell.lbl_Title.text = self.arrMenuItm[indexPath.row]
        
       // cell.titleLabel.text = menuContainerViewController?.contentViewControllers[indexPath.row].title ?? "Home"

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let menuContainerViewController = self.menuContainerViewController else {
            return
        }

        if self.arrMenuItm[indexPath.row] == SidemenuContent.s_shareLink.rawValue {
            
            let secondActivityItem : NSURL = NSURL(string: "http://www.google.com")!
            // If you want to put an image
            
            let activityViewController : UIActivityViewController = UIActivityViewController(
                activityItems: [secondActivityItem], applicationActivities: nil)
            
            activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            self.present(activityViewController, animated: true, completion: nil)
            
            menuContainerViewController.hideSideMenu()
        }
        else if self.arrMenuItm[indexPath.row] == SidemenuContent.s_logout.rawValue {

            let alert = UIAlertController.init(title: "", message: "Are you sure you want to logout?", preferredStyle: UIAlertController.Style.alert)

            let actionCancel = UIAlertAction.init(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            })

            let actionOK = UIAlertAction.init(title: SidemenuContent.s_logout.rawValue, style: UIAlertAction.Style.destructive, handler: { (action) in

                _userDefault.set(false, forKey: eUserDefaultsKey.key_isLogin.rawValue)
                menuContainerViewController.selectContentViewController(menuContainerViewController.contentViewControllers[0])
                menuContainerViewController.hideSideMenu()
                self.arrMenuItm = [SidemenuContent.s_home.rawValue,
                                   SidemenuContent.s_shareLink.rawValue,
                                   SidemenuContent.s_feedback.rawValue,
                                   SidemenuContent.s_login.rawValue]
                
                self.tableView.reloadData()
                NotificationCenter.default.post(name: NSNotification.Name.init(keyLocalNotification.refreshViewController.rawValue), object: nil)
                
            })

            alert.addAction(actionCancel)
            alert.addAction(actionOK)
            self.present(alert, animated: true, completion: nil)
            for textfield: UIView in (alert.textFields ?? [])! {
                let container: UIView = textfield.superview!
                let effectView: UIView = container.superview!.subviews[0]
                container.backgroundColor = UIColor.clear
                effectView.removeFromSuperview()
            }
            
            
        }
        else {
            
            var selectedIndex = indexPath.row
            
            if self.arrMenuItm[indexPath.row] == SidemenuContent.s_feedback.rawValue {
                selectedIndex = selectedIndex - 1
            }
        menuContainerViewController.selectContentViewController(menuContainerViewController.contentViewControllers[selectedIndex])
            menuContainerViewController.hideSideMenu()
        }

    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let v = UIView()
        v.backgroundColor = UIColor.clear
        return v
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.5
    }
}
