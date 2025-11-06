import 'package:features/core/data_source/data_source.dart';
import '../domain/model/break_down_model.dart';
import '../domain/model/spend_model.dart';
import '../domain/repository/repository.dart' show Repository;

class WalletRepositoryImpl implements Repository {
  late final _accountApi = ApiFactory
      .create()
      .accountApi;

  @override
  Future<List<BreakdownModel>> readBreakDownData() async {
    final entities = await _accountApi.readBreakDownsOrThrow();
    return entities.map((entity) =>
        BreakdownModel(label: entity.label, percentage: entity.percentage))
        .toList();
  }

  @override
  Future<SpendModel> readSpendData() async {
    final entity = await _accountApi.readSpendOrThrow();
    final spend = SpendModel(
        period: entity.period, currency: entity.currency,
        spend: SpendItemModel(
            data: entity.spend.map((entity) =>
                ScheduleModel(
                    firstSchedule: entity.firstSchedule,
                    secondSchedule: entity.secondSchedule,
                    thirdSchedule: entity.thirdSchedule,
                    fourthSchedule: entity.fourthSchedule,
                    fifthSchedule: entity.fifthSchedule
                )
            ).toList()
        ));
    return spend;
  }
}