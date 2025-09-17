//
//  TaskQueue.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 08/09/25.
//

import Combine
import Foundation

actor TaskQueue {
    private var tasks: [() async -> Void] = []
    nonisolated let isRunning = CurrentValueSubject<Bool, Never>(false)
    var runningTask: Task<Void, Never>?

    func cancel() async {
        tasks.removeAll()
    }

    func add(_ task: @escaping () async -> Void) async {
        tasks.append(task)
        if !isRunning.value {
            await runNext()
        }
    }

    private func runNext() async {
        guard !tasks.isEmpty else {
            isRunning.value = false
            return
        }

        isRunning.value = true
        let task = tasks.removeFirst()

        Task {
            await task()
            await runNext()
        }
    }
}
