//
//  ViewController.swift
//  SampleApp-UIKit
//
//  Copyright © 2022 Jumio Corporation. All rights reserved.
//

import UIKit
import Jumio

class ViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var dataCenterSegmentControl: UISegmentedControl!
    @IBOutlet weak var tokenTextField: UITextField!
    @IBOutlet weak var customUIButton: CustomButton!
    @IBOutlet weak var defaultUIButton: CustomButton!
    
    // MARK: - Private properties
    fileprivate lazy var defaultUI = DefaultUI()
    var jumioViewController: Jumio.ViewController?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tokenTextField.delegate = self
        
        dataCenterSegmentControl.tintColor = .systemBlue
        dataCenterSegmentControl.removeAllSegments()
        for segment in Segment.all() {
            dataCenterSegmentControl.insertSegment(withTitle: segment.rawValue, at: segment.index, animated: false)
        }
        dataCenterSegmentControl.selectedSegmentIndex = Segment.US.index
        
        customUIButton.design = .positive
        defaultUIButton.design = .positive
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Segue.customUI.rawValue:
            guard let customUI = segue.destination as? CustomUINavigationController,
                  let token = tokenTextField.text,
                  let segment = Segment.from(index: dataCenterSegmentControl.selectedSegmentIndex) else { return }
            customUI.customUIDelegate = self
            // Starting customUI here with one time token and corresponding data center
            customUI.start(with: token, dataCenter: segment.dataCenter)
        case Segue.result.rawValue:
            guard let resultController = segue.destination as? ResultViewController,
                  let result = sender as? Jumio.Result else { return }
            resultController.result = result
        default:
            return
        }
    }
    
    // MARK: - IBActions
    @IBAction func startCustomUI() {
        performSegue(withIdentifier: Segue.customUI.rawValue, sender: nil)
    }

    @IBAction func startJumio() {
        guard let token = tokenTextField.text,
              let segment = Segment.from(index: dataCenterSegmentControl.selectedSegmentIndex) else { return }
        defaultUI.delegate = self
        defaultUI.start(with: token, dataCenter: segment.dataCenter)
        
        guard let jumioVC = defaultUI.viewController else { return }
        jumioViewController = jumioVC
        jumioVC.modalPresentationStyle = .fullScreen
        present(jumioVC, animated: true)
    }
}

// MARK: - UITextField
extension ViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        tokenTextField.resignFirstResponder()
    }
}

// MARK: - DefaultUI.Delegate
extension ViewController: DefaultUI.Delegate {
    func defaultUIDidFinish(with result: Jumio.Result) {
        jumioViewController?.dismiss(animated: true, completion: { [weak self] in
            self?.defaultUI.clean()
            self?.jumioViewController = nil
            self?.performSegue(withIdentifier: Segue.result.rawValue, sender: result)
        })
    }
}

// MARK: - CustomUI.Delegate
extension ViewController: CustomUINavigationController.Delegate {
    func customUIDidFinish(with result: Jumio.Result) {
        performSegue(withIdentifier: Segue.result.rawValue, sender: result)
    }
}

// MARK: - Segment
extension ViewController {
    fileprivate enum Segment: String {
        case US
        case EU
        case SG
        
        static func from(index: Int) -> Segment? {
            switch index {
            case Segment.US.index: return .US
            case Segment.EU.index: return .EU
            case Segment.SG.index: return .SG
            default: return nil
            }
        }
        
        static func all() -> [Segment] {
            return [.US, .EU, .SG]
        }
        
        var dataCenter: Jumio.DataCenter {
            switch self {
            case .EU: return .EU
            case .US: return .US
            case .SG: return .SG
            }
        }
        
        var index: Int {
            switch self {
            case .US: return 0
            case .EU: return 1
            case .SG: return 2
            }
        }
    }
}

// MARK: - Segue
extension ViewController {
    fileprivate enum Segue: String {
        case customUI = "showCustomUI"
        case result = "showResult"
    }
}
