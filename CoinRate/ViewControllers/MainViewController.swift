//
//  MainViewController.swift
//  CoinRate
//
//  Created by Visarut Tippun on 1/1/21.
//

import UIKit
import RxSwift
import RxCocoa
import RxBinding
import RxBiBinding
import Then

class MainViewController: UIViewController {
    
    @IBOutlet weak var valueTextField:UITextField!
    @IBOutlet weak var assetTextField:UITextField!
    @IBOutlet weak var getRateButton:UIButton!
    @IBOutlet weak var tableView:UITableView!
    
    var viewModel = MainViewModel()
    var pickerView = UIPickerView()
    
    private let bag = DisposeBag()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getAssetList()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if self.tableView.tableFooterView == nil {
            self.tableView.tableFooterView = UIView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        self.bindViewModel()
    }
    
    func configureView() {
        self.tableView.separatorStyle = .none
        self.tableView.keyboardDismissMode = .onDrag
        self.tableView.register(cell: ExchangeRateTableViewCell.self)
        self.tableView.rx.setDelegate(self).disposed(by: self.bag)
        
        self.valueTextField.keyboardType = .numbersAndPunctuation
        self.assetTextField.inputView = self.pickerView
        
        self.getRateButton.setCornerRadius(6)
    }

    func bindViewModel() {
        self.viewModel.rateValue <~> self.valueTextField.rx.text ~ self.bag
        self.viewModel.selectedBaseAsset.map({$0?.assetId}) ~> self.assetTextField.rx.text ~ self.bag
        
        CoinManager.shared.allAssetList.bind(to: self.pickerView.rx.itemTitles) { (_, item) in
            return item.assetId
        }.disposed(by: self.bag)
        
        self.pickerView.rx.itemSelected.subscribe(onNext: { (row, _) in
            self.viewModel.selectedBaseAsset.accept(CoinManager.shared.allAssetList.value[row])
        }).disposed(by: self.bag)
        
        self.viewModel.dataSource.bind(to: self.tableView.rx.items(cellIdentifier: ExchangeRateTableViewCell.identifier(), cellType: ExchangeRateTableViewCell.self)) { (row, item, cell) in
            let baseValue = self.viewModel.currentValue.value
            cell.configure(item: item, baseValue: baseValue)
        }.disposed(by: self.bag)
        
        self.getRateButton.rx.tap.bind {
            self.view.endEditing(true)
            self.getAllExchangeRate()
        }.disposed(by: self.bag)
    }
    
    func getAssetList() {
        CoinManager.shared.getAssetList().subscribe {
            //
        } onError: { (error) in
            print(error.localizedDescription)
        }.disposed(by: self.bag)

    }

    func getAllExchangeRate() {
        self.viewModel.getAllRate().subscribe {
            //
        } onError: { (error) in
            print(error.localizedDescription)
        }.disposed(by: self.bag)
    }
    
}

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return ExchangeRateTableHeaderSectionView.loadFromNib(of: ExchangeRateTableHeaderSectionView.self).then { (view) in
            self.viewModel.dataSource.subscribe(onNext: { (rates) in
                view.baseValueLabel.isHidden = !(rates.count > 0)
                view.baseAssetLabel.isHidden = !(rates.count > 0)
            }).disposed(by: self.bag)
            self.viewModel.currentValue.map({String($0)}).bind(to: view.baseValueLabel.rx.text).disposed(by: self.bag)
            self.viewModel.currentBaseAsset.map({$0?.assetId ?? ""}).bind(to: view.baseAssetLabel.rx.text).disposed(by: self.bag)
        }
    }
    
}


