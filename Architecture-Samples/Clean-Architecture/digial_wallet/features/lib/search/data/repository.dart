import 'package:features/core/core_language.dart';
import 'package:features/core/data_source/data_source.dart';
import '../domain/model/chart_data_model.dart';
import '../domain/model/product_model.dart';
import '../domain/repository/repository.dart';

class SearchRepositoryImpl implements Repository {
  late final _productApi = ApiFactory.create().productApi;
  late final _accountApi = ApiFactory.create().accountApi;

  @override
  Future<SpendSummaryModel?> readChartData() async {
    final entity = await _accountApi.readSpendSummaryOrThrow();
    final mappedData = entity.data.map(
      (key, value) => MapEntry(
        key,
        TimePeriodModel(
          xAxisData: value.xAxisData,
          yAxisData: value.yAxisData,
        ),
      ),
    );
    return SpendSummaryModel(
      data: mappedData,
      timePeriods: List<String>.from(entity.timePeriods),
      selectedTimePeriod: entity.selectedTimePeriod,
    );
  }

  @override
  Future<List<ProductModel>> readRecentProducts() async {
    final entities = await _productApi.readOrThrow();
    Logger.on("readRecentProducts", "$entities");
    return entities.map((e) {
      return ProductModel(
        id: e.id,
        title: e.title,
        price: e.price,
        description: e.description,
        category: e.category,
        image: e.image,
        rating: RatingModel(
          rate: e.rating.rate,
          count: e.rating.count,
        ),
      );
    }).toList();
  }
}

extension SpendSummaryMapper on SpendSummaryEntity {
  SpendSummaryModel toModel() {
    final mappedData = data.map(
      (key, value) => MapEntry(
        key,
        TimePeriodModel(
          xAxisData: value.xAxisData,
          yAxisData: value.yAxisData,
        ),
      ),
    );

    return SpendSummaryModel(
      data: mappedData,
      timePeriods: List<String>.from(timePeriods),
      selectedTimePeriod: selectedTimePeriod,
    );
  }
}

