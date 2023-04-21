//
//  JaiJinendraVC.swift
//  Jain-Contacts
//
//  Created by Deepak Jain on 29/01/19.
//  Copyright © 2019 Deepak Jain. All rights reserved.
//

import UIKit
import AVFoundation

class JaiJinendraVC: UIViewController {

    @IBOutlet weak var ImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let jeremyGif = UIImage.gifImageWithName(name: "jaijinendra")
        self.ImageView.image = jeremyGif
        self.ImageView.transform = CGAffineTransform.init(scaleX: 0.001, y: 0.001)
        
        let utterance = AVSpeechUtterance(string: "Jai Jinendra")
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        utterance.volume = 1.0
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            self.showJaiJinendraPopup(isShow: true, completion: { (isFinish) in})
        }
    }
    
    
    func showJaiJinendraPopup(isShow:Bool,completion:@escaping (Bool)->Void) {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
            self.ImageView.transform = CGAffineTransform.identity
            self.view.backgroundColor = UIColor.black.withAlphaComponent((isShow ? 0.8:0))
        }) { (isFinish) in
            if isShow == false {
                self.willMove(toParent: nil)
                self.view.removeFromSuperview()
                self.removeFromParent()
            }
            completion(isFinish)
        }
    }
    
    
    

    
    @IBAction func dismisPress(_ sender: UIButton) {
        //self.dismiss(animated: true, completion: nil)
        self.ImageView.transform = CGAffineTransform.identity
        UIView.animate(withDuration: 0.3, animations: {
            self.ImageView.transform = CGAffineTransform.init(scaleX: 0.001, y: 0.001)
            //            self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
        }) { (sucess) in
            self.willMove(toParent: nil)
            self.view.removeFromSuperview()
            self.removeFromParent()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
