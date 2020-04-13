import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/abstract/io.dart';
import 'package:budgetflow/model/data_types/history.dart';
import 'package:budgetflow/model/data_types/month.dart';
import 'package:budgetflow/model/implementations/io/month_io.dart';
import 'package:budgetflow/model/implementations/services/file_service.dart';

class HistoryIO implements IO {
  FileService _fileService;
  History _history;

  HistoryIO(this._fileService);

  HistoryIO.fromHistory(this._history, this._fileService);

  @override
  Future<History> load() {
    // TODO: implement load
    return null;
  }

  Future save() {
    _saveMonths();
    String content = _history.serialize;
    _fileService.encryptAndWriteFile(historyFilepath, content);
  }

  void _saveMonths() {
    for (Month month in _history) {
      var monthIO = MonthIO(month, _fileService);
      monthIO.save();
    }
  }
}
