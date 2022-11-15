import '../Model/HomePageModel.dart';
import 'home_service.dart';

class HomeRepositoryImpl implements HomeRepository {

  DataBaseService service = DataBaseService();

  @override
  Future<List<HomePageClass>> fetchData() {
    return service.fetchData();
  }

}

abstract class HomeRepository {
  Future<List<HomePageClass>> fetchData();
}