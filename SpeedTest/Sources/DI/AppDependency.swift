import CoreInterface
import Servers

final class AppDependency {
    let apiClient: APIClient = APIClientImpl()

    lazy var serversRepository = createServersRepository(apiClient: apiClient)
}

