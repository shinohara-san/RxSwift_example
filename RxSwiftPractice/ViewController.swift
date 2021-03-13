//
//  ViewController.swift
//  RxSwiftPractice
//
//  Created by Yuki Shinohara on 2021/03/13.
//  https://open8tech.hatenablog.com/entry/2019/04/03/111100

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet weak var myButton: UIButton!
    @IBOutlet weak var myLabel: UILabel!
    
    private let count: BehaviorRelay<Int> = BehaviorRelay(value: 0) //イベントの検知に加えイベントの発生もできる便利なラッパーのひとつ
    private let disposeBag: DisposeBag = DisposeBag() //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindButtonToValue()
        bindCountToText()
    }
    
    // 1.の処理
    private func bindButtonToValue() {
        myButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                        self?.increment()})
            .disposed(by: disposeBag)
        //1. myButtonがタップされたら通知を出す(myButtonはObservableってことだろう)
        //2. 通知を受け取ったObserver(ViewController)はsubscribeを実行、引数onNext内部の処理(increment関数)を実行する
        //3. 上記の購読を.disposedで破棄
    }
    
    private func increment() {
        count.accept(count.value + 1)
    }
    
    // 2.の処理
    private func bindCountToText() {
        count.asObservable()
            .subscribe(onNext: { [weak self] count in
                        self?.myLabel.text = String(count) }) // この購読自体がDisposable。それを47で破棄
            .disposed(by: disposeBag)
        //1. count.asObservableが変化、変化後の値 == Observableな値(数)を返す。Observable<Int>を返す。
        //2. それを監視しているVC(Observer)がsubscribeの引数onNextで処理を実行
        //3. このcountが1のObservableな値で、それを文字列化し、myLabelのtextとして代入
        //4. 2の購読を破棄
        
//        同じ意味
//        count.asObservable()
//                .map{ String($0) } //流れてきた値(変化した値)をmap内部でString型に加工
//                .bind(to: myLabel.rx.text) //それをmyLabel.textに結びつけてる
//                .disposed(by: disposeBag) //購読を破棄
    }
}

//Observable: 監視される。変化したら通知を行う。Streamとも呼ぶ。
//Observer: 監視する。通知を受ける。

//.subscribe(): 監視する側が通知を受けた時の挙動。購読。onNextのクロージャ内に挙動を書く。
//DisposeBag: 購読を破棄。メモリーリーク回避。

