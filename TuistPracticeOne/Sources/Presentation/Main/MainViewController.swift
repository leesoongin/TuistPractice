//
//  MainViewController.swift
//  TuistPracticeOne
//
//  Created by 이숭인 on 5/23/24.
//

import UIKit
import Alamofire
import NetworkProvider
import Combine
import SnapKit
import Then
import CombineCocoa

final class MainViewController: UIViewController {
    var cancellables = Set<AnyCancellable>()
    private let viewModel = MainViewModel()
    
    private let button = UIButton().then {
        $0.setTitle("누르면 호출함", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        setupConstraints()
        bindRepository()
        bindAction()
    }
    
    private func setupSubviews() {
        view.addSubview(button)
    }
    
    private func setupConstraints() {
        button.snp.makeConstraints { make in
            make.width.equalTo(120)
            make.height.equalTo(36)
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    private func bindRepository() {
        viewModel.postsPublisher
            .receive(on: DispatchQueue.main)
            .sink { articles in
                print("::: Articles > \(articles)")
            }
            .store(in: &cancellables)
    }
    
    private func bindAction() {
        button.tap
            .sink { [weak self] _ in
                self?.viewModel.fetchPosts()
            }
            .store(in: &cancellables)
    }
}

extension MainViewController: PostErrorHandlerable {
    var errorPublisher: AnyPublisher<Error, Never> { viewModel.errorPublisher }
}



// 잠시 이벤트 처리위해 작성
extension UIControl {
    var tap: AnyPublisher<Void, Never> {
        controlEventPublisher(for: .touchUpInside)
            .coolDown(for: 1.0, scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
extension Publisher {
    public func coolDown<S: Scheduler>(for cooltime: S.SchedulerTimeType.Stride,
                                       scheduler: S) -> some Publisher<Self.Output, Self.Failure> {
        return self.receive(on: scheduler)
            .scan((S.SchedulerTimeType?.none, Self.Output?.none)) {
                let eventTime = scheduler.now
                let minimumTolerance = scheduler.minimumTolerance
                guard let lastSentTime = $0.0 else {
                    return (eventTime, $1)
                }

                let diff = lastSentTime.distance(to: eventTime)

                guard diff >= (cooltime - minimumTolerance) else {
                    return (lastSentTime, nil)
                }

                return (eventTime, $1)
            }
            .compactMap { $0.1 }
    }
}

