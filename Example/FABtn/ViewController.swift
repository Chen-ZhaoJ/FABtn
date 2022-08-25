//
//  ViewController.swift
//  FABtn
//
//  Created by Chen-ZhaoJ on 08/24/2022.
//  Copyright (c) 2022 Chen-ZhaoJ. All rights reserved.
//

import UIKit
import FABtn

class ViewController: UIViewController {

    let floatVC = FloatVC(fabDirection: .left, btnLeftOrRightSpace: 30, btnBottom: -30, buttonSize: 50, lblTextColor: UIColor.systemYellow)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGray2
        layout()
        testLable()
        createFloatVC()
    }
    
    func createFloatVC(){
        floatVC.createFAB(image: UIImage(), color: .black)
        floatVC.createFAB(image: UIImage(), title: "collapse1", color: .yellow, target: #selector(sendMessage(_:)), atVC: self)
        floatVC.createFAB(image: UIImage(), title: "no collapse", color: .yellow, target: #selector(none(_:)) , atVC: self)
    }
    
    lazy var button: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(), for: .normal)
        btn.layer.cornerRadius = 25
        btn.backgroundColor = .yellow
        btn.addTarget(self, action: #selector(showFloatVC(_:)), for: .touchUpInside)
        return btn
    }()
    
    func layout(){
        self.view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([button.widthAnchor.constraint(equalToConstant: 50),
                                     button.heightAnchor.constraint(equalToConstant: 50),
                                     button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
                                     button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30)])
    }
    
    func testLable(){
        let testlable:UILabel = UILabel()
        testlable.text = "測試測試測試"
        testlable.textColor = .systemYellow
        view.addSubview(testlable)
        testlable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([testlable.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     testlable.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController {
    @IBAction func showFloatVC(_ sender: UIButton){
        present(floatVC, animated: false)
    }
    
    @IBAction func sendMessage (_ sender: UIButton){
        print("one Button Clicked")
        floatVC.collapseFAB()
    }

    @IBAction func none (_ sender: UIButton){
        print("three Button Clicked")
    }
}
