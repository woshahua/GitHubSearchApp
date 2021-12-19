//
//  DispatchQueue+Debouncer.swift
//  GitHubSearchApp
//
//  Created by Hang Gao on 2021/12/17.
//
import Foundation

extension DispatchQueue {
    func debounce(delay: DispatchTimeInterval) -> (_ action: @escaping () -> Void) -> Void {
        var lastFireTime: DispatchTime = .now()

        return { [weak self, delay] action in
            let deadline: DispatchTime = .now() + delay
            lastFireTime = .now()
            self?.asyncAfter(deadline: deadline) { [delay] in
                let now: DispatchTime = .now()
                let when: DispatchTime = lastFireTime + delay
                if now < when { return }
                lastFireTime = .now()
                action()
            }
        }
    }
}
