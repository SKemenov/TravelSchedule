//
//  NetworkService.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 19.04.2024.
//

import Foundation
import OpenAPIURLSession


final class NetworkService {
    let serverURL: URL
    let client: Client

    init() {
        do {
            serverURL = try Servers.server1()
        } catch {
            preconditionFailure("Cannot obtain server URL")
        }
        client = Client(
            serverURL: serverURL,
            transport: URLSessionTransport(),
            middlewares: [AuthenticationMiddleware(authorizationHeaderFieldValue: Resources.apiKey)]
        )
    }
}

extension NetworkService {
    func getNearestStations() {
        let service = NearestStationsService(client: client)
        Task {
            do {
                let response = try await service.getNearestStations(lat: 59.864177, lng: 30.319163, distance: 50)
                guard
                    let stations = response.stations,
                    let total = response.pagination?.total,
                    let limit = response.pagination?.limit else { return }
                print(
                    stations,
                    "\n pagination.total:",
                    total,
                    "\n pagination.limit:",
                    limit,
                    "\n stations.count:",
                    stations.count
                )
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func getCopyright() {
        let service = CopyrightService(client: client)
        Task {
            do {
                let response = try await service.getCopyright()
                print(response)
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func getSchedules() {
        let service = SchedulesService(client: client)
        Task {
            do {
                let response = try await service.getSchedules(station: "s9600213", date: nil)
                guard
                    let schedules = response.schedule,
                    let total = response.pagination?.total,
                    let limit = response.pagination?.limit else { return }
                print(
                    response,
                    "\n pagination.total:",
                    total,
                    "\n pagination.limit:",
                    limit,
                    "\n schedules.count:",
                    schedules.count
                )
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func getSearches() {
        let service = SearchService(client: client)
        Task {
            do {
                let response = try await service.getSearches(from: "s9623561", to: "s9600213", with: false)
                guard
                    let segments = response.segments,
                    let intervalSegments = response.interval_segments,
                    let total = response.pagination?.total,
                    let limit = response.pagination?.limit else { return }
                print(
                    response,
                    "\n pagination.total:",
                    total,
                    "\n pagination.limit:",
                    limit,
                    "\n segments.count:",
                    segments.count,
                    "\n intervalSegments.count:",
                    intervalSegments.count
                )
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func getThreads() {
        let service = ThreadService(client: client)
        Task {
            do {
                let response = try await service.getThread(uid: "UJ-615_240316_c1764_12")
                print(response)
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func getNearestSettlement() {
        let service = NearestSettlementService(client: client)
        Task {
            do {
                let response = try await service.getNearestSettlement(lat: 59.864177, lng: 30.319163, distance: 50)
                print(response)
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func getCarriers() {
        let service = CarriersService(client: client)
        Task {
            do {
                let response = try await service.getCarriers(code: 129)
//                let response = try await service.getCarriers(code: "SU", system: .iata)
                print(response)
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func getStationsList() {
        let service = StationsListService(client: client)
        Task {
            do {
                let stations = try await service.getStationsList()
                guard let countries = stations.countries else { return }
                print("Total countries at the list:", countries.count)

                var totalStations = 0
                countries.forEach {
                    $0.regions?.forEach {
                        $0.settlements?.forEach {
                            $0.stations?.forEach { _ in totalStations += 1 }
                        }
                    }
                }
                print("Total stations: \(totalStations)")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
