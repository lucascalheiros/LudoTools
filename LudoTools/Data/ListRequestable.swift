//
//  ListRequestable.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 08/09/25.
//

import Combine

actor ListRequestable<Params: Hashable, Response> {

    private let request: (Params, PageInfo) async -> Result<[Response], NetworkError>

    init(request: @escaping (Params, PageInfo) async -> Result<[Response], NetworkError>) {
        self.request = request
    }

    private var subjectCacheMap: [Params: CurrentValueSubject<[Response], Never>] = [:]

    private var currentPageForQuery: [Params: Int] = [:]

    private var totalItemsForQuery: [Params: Int] = [:]

    private var taskQueue: [Params: Task<Void, Never>?] = [:]

    private func dataSubject(_ searchText: Params) -> CurrentValueSubject<[Response], Never> {
        let it = subjectCacheMap[searchText, default: CurrentValueSubject<[Response], Never>([])]
        subjectCacheMap[searchText] = it
        return it
    }

    nonisolated func dataPublisher(_ params: Params) -> AnyPublisher<[Response], Never> {
        Deferred {
            Future { promise in
                Task {
                    let games = await self.dataSubject(params)
                    promise(.success(games))
                }
            }
        }
        .flatMap { $0 }
        .eraseToAnyPublisher()
    }

    func loadMore(_ params: Params) async {
        if let task = taskQueue[params] {
            await task?.value
        } else {
            fetch(params)
            await taskQueue[params]??.value
        }
    }

    private func fetch(_ params: Params) {
        taskQueue[params] = Task {
            let page = self.currentPageForQuery[params, default: 0] + 1
            let response = await self.request(
                params,
                .init(page: page)
            )
            if case .success(let success) = response {
                self.currentPageForQuery[params] = page
                self.dataSubject(params).value += success
                Logger.debug("Count content added \(success.count) \(params)")
            }
            taskQueue[params] = nil
        }
    }
}
