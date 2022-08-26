//
//  ViewController.swift
//  FloatyVC
//
//  Created by Zhaojie CHEN(陳昭潔) on 2022/8/19.
//

import UIKit

public final class FloatVC: UIViewController, CAAnimationDelegate{
    public enum FabDirection {
        case left
        case right
    }
    struct ViewModel{
        var fabDirection: FabDirection = .left
        var btnLeftOrRightSpace: CGFloat = 30
        var btnBottom: CGFloat = -40
        var btnPadding: CGFloat = 5
        var btnSize: CGFloat = 50
        var lblTextSize: Double = 20
    }
    private var vm = ViewModel()
    private var isExpand: Bool = false
    private var views: [UIView] = []
    private var btns: [UIButton] = []
    private var lbls: [UILabel] = []
    private var bottomAnchors: [NSLayoutConstraint] = []
    private let customMaskView: UIView = UIView()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public convenience init(fabDirection: FabDirection = .left, btnLeftOrRightSpace: CGFloat = 30, btnBottom: CGFloat = -40, btnPadding: CGFloat = 5, btnSize: CGFloat = 50, lblTextSize: Double = 20){
        self.init()
        vm.fabDirection = fabDirection
        vm.btnLeftOrRightSpace = btnLeftOrRightSpace
        vm.btnBottom = btnBottom
        vm.btnPadding = btnPadding
        vm.btnSize = btnSize
        vm.lblTextSize = lblTextSize
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        modalPresentationStyle = .overFullScreen
        initialMask()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard isExpand == false else { return }
        expand()
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: view) else { return }
        guard !btns[0].frame.contains(location) else { return }
        collapse()
    }
    
    public func createFAB(image: UIImage, title: String? = nil, btnColor: UIColor, lblColor: UIColor = .black, target: Selector? = nil, atVC: Any? = nil){
        let index = views.count
        createView(index: index)
        createLabel(index: index, color: lblColor, title: title ?? "")
        createButton(image: image, index: index, color: btnColor,target: target, atVC: atVC)
    }
        
    public func collapseFAB(){
        guard isExpand == true else { return }
        collapse()
    }
    
    private func createView(index: Int){
        let myView: UIView = UIView()
        views.insert(myView, at: index)
        let vi = views[index]

        if index != 0 {
            view.insertSubview(vi, belowSubview: views[index-1])
        }else{
            view.insertSubview(vi, at: 1)
        }
        vi.translatesAutoresizingMaskIntoConstraints = false
        let bottomConstraint: NSLayoutConstraint = NSLayoutConstraint()
        bottomAnchors.insert(bottomConstraint, at: index)
        bottomAnchors[index] = vi.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: vm.btnBottom)
        NSLayoutConstraint.activate([vi.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0),
                                     vi.heightAnchor.constraint(equalToConstant: vm.btnSize),
                                     vi.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
                                     bottomAnchors[index]])
    }
    
    private func createButton(image: UIImage, index: Int, color: UIColor, target: Selector?, atVC: Any?){
        let button: UIButton = UIButton()
        btns.insert(button, at: index)
        let bi = btns[index]
        let vi = views[index]
        bi.setImage(image, for: .normal)
        bi.layer.cornerRadius = 25
        bi.backgroundColor = color
        
        vi.addSubview(bi)
        bi.translatesAutoresizingMaskIntoConstraints = false
        var lead: CGFloat = 0
        if vm.fabDirection == .left{
            lead = vm.btnLeftOrRightSpace
        }else{
            lead = UIScreen.main.bounds.size.width-vm.btnLeftOrRightSpace-vm.btnSize
        }
        NSLayoutConstraint.activate([bi.widthAnchor.constraint(equalToConstant: vm.btnSize),
                                     bi.heightAnchor.constraint(equalToConstant: vm.btnSize),
                                     bi.leadingAnchor.constraint(equalTo: vi.leadingAnchor, constant: lead),
                                     bi.bottomAnchor.constraint(equalTo: vi.bottomAnchor, constant: 0)])
        if index == 0 {
            btns[0].addTarget(self, action: #selector(collapse), for: UIControl.Event.touchUpInside)
        }
        guard target != nil else { return }
        bi.addTarget(atVC, action: target ?? Selector(String()), for: UIControl.Event.touchUpInside)
    }
    
    private func createLabel(index: Int, color: UIColor, title: String){
        let label: UILabel = UILabel()
        lbls.insert(label, at: index)
        let li = lbls[index]
        let vi = views[index]
        li.text = title
        li.textColor = color
        li.font = UIFont.systemFont(ofSize: vm.lblTextSize)
        li.isHidden = true
        
        vi.addSubview(li)
        li.translatesAutoresizingMaskIntoConstraints = false
        var lblLeading: CGFloat = 55
        if vm.fabDirection == .left{
            lblLeading = vm.btnSize+vm.btnLeftOrRightSpace+5
            li.textAlignment = .left
        }else{
            lblLeading = -5-vm.btnLeftOrRightSpace
            li.textAlignment = .right
        }
        NSLayoutConstraint.activate([li.centerYAnchor.constraint(equalTo: vi.centerYAnchor, constant: 0),
                                     li.widthAnchor.constraint(equalTo: vi.widthAnchor, constant: -vm.btnSize),
                                     li.leadingAnchor.constraint(equalTo: vi.leadingAnchor, constant: lblLeading)])
    }

    private func initialMask(){
        customMaskView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.insertSubview(customMaskView, at: 0)
        customMaskView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([customMaskView.widthAnchor.constraint(equalTo: view.widthAnchor),
                                     customMaskView.heightAnchor.constraint(equalTo: view.heightAnchor),
                                     customMaskView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     customMaskView.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
    }
    
    @objc private func expand(){
        let v0 = views[0]
        if vm.fabDirection == .left {
            animationRotate(duration: 0.3, toValue: Double.pi, repeatCount: 1, btn:btns[0]) //順時針轉
        }else{
            animationRotate(duration: 0.3, toValue: Double.pi, repeatCount: -1, btn:btns[0]) //順時針轉
        }
        
        for i in 1 ..< views.count{ //顯示字、把button展開
            lbls[i].isHidden = false
            bottomAnchors[i].constant = bottomAnchors[i].constant-CGFloat(i)*(btns[0].frame.width+vm.btnPadding)
            let from = [v0.frame.midX,v0.frame.midY]
            let to = [v0.frame.midX,v0.frame.midY-CGFloat(i)*(btns[0].frame.width+vm.btnPadding)]
            animationPosition(duration: 0.3, fromValue: from, toValue: to, index: i)
        }
        isExpand = !isExpand
    }
    
    @objc private func collapse(){
        let v0 = views[0]
        if vm.fabDirection == .left {
            animationRotate(duration: 0.3, toValue: 0, repeatCount: -1, btn:btns[0]) //逆時針轉
        }else{
            animationRotate(duration: 0.3, toValue: 0, repeatCount: 1, btn:btns[0]) //逆時針轉
        }
        
        for i in 1 ..< views.count{ //把button收回、隱藏字
            bottomAnchors[i].constant = vm.btnBottom
            let from = [v0.frame.midX,v0.frame.midY-CGFloat(i)*(btns[0].frame.width+vm.btnPadding)]
            let to = [v0.frame.midX,v0.frame.midY]
            animationPosition(duration: 0.3, fromValue: from, toValue: to, index: i)
            lbls[i].isHidden = true
        }
        isExpand = !isExpand
    }
    
    private func animationRotate(duration: Double, toValue: Double, repeatCount: Float, btn: UIButton){ //旋轉動畫
        let animRotate = CABasicAnimation(keyPath: "transform.rotation")
        animRotate.delegate = self
        animRotate.duration = duration //動畫速度
        animRotate.isRemovedOnCompletion = false //結束時不回復原樣
        animRotate.fillMode = CAMediaTimingFillMode.forwards //讓layer停在toValue
        animRotate.toValue = toValue //設定動畫結束值
        animRotate.repeatCount = repeatCount //旋轉次數（正1為順時針一圈，負為逆時針）
        btn.imageView?.layer.add(animRotate, forKey: nil)
    }
    
    private func animationPosition(duration: Double, fromValue: [CGFloat], toValue: [CGFloat], index: Int){ //位移動畫
        let animPosition = CABasicAnimation(keyPath: "position")
        animPosition.delegate = self
        animPosition.duration = duration
        animPosition.isRemovedOnCompletion = false
        animPosition.fillMode = CAMediaTimingFillMode.forwards
        animPosition.fromValue = fromValue
        animPosition.toValue = toValue
        animPosition.setValue("animPosition", forKey: "id")
        views[index].layer.add(animPosition, forKey: nil)
    }
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard isExpand == false else { return }
        guard let key = anim.value(forKey: "id") as? String else { return }
        guard key == "animPosition" else { return }
        self.dismiss(animated: false)
    }
}
