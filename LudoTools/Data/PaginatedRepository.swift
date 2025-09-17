//
//  GamesRepository.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 08/09/25.
//

import Combine

actor PaginatedRequestable<Params: Hashable, Response: PaginatedResponse> {

    private let request: (Params, PageInfo) async -> Result<Response, NetworkError>

    init(request: @escaping (Params, PageInfo) async -> Result<Response, NetworkError>) {
        self.request = request
    }

    private var subjectCacheMap: [Params: CurrentValueSubject<[Response.Item], Never>] = [:]

    private var currentPageForQuery: [Params: Int] = [:]

    private var totalItemsForQuery: [Params: Int] = [:]

    private var taskQueue: [Params: Task<Void, Never>?] = [:]

    private func dataSubject(_ searchText: Params) -> CurrentValueSubject<[Response.Item], Never> {
        let it = subjectCacheMap[searchText, default: CurrentValueSubject<[Response.Item], Never>([])]
        subjectCacheMap[searchText] = it
        return it
    }

    nonisolated func dataPublisher(_ params: Params) -> AnyPublisher<[Response.Item], Never> {
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

    func loadMore(_ params: Params) async -> Result<Bool, Never> {
        guard shouldLoadMore(params) else { return .success(false) }
        if let task = taskQueue[params] {
            await task?.value
        } else {
            fetch(params)
            await taskQueue[params]??.value

        }
        return .success(shouldLoadMore(params))
    }

    private func shouldLoadMore(_ params: Params) -> Bool {
        let count = self.dataSubject(params).value.count
        let totalItems = self.totalItemsForQuery[params] ?? 0
        let notReachedTotalItems = totalItems > count || totalItems == 0
        return notReachedTotalItems
    }

    private func fetch(_ params: Params) {
        taskQueue[params] = Task {
            guard self.shouldLoadMore(params) else {
                return
            }
            let page = self.currentPageForQuery[params, default: 0] + 1
            let response = await self.request(
                params,
                .init(page: page)
            )
            if case .success(let success) = response {
                self.currentPageForQuery[params] = page
                self.totalItemsForQuery[params] = success.total
                self.dataSubject(params).value += success.content
                Logger.debug("Count content added \(success.content.count) \(params)")
            }
            taskQueue[params] = nil
        }
    }
}
