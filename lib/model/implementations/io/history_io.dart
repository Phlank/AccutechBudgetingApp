import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/abstract/io.dart';
import 'package:budgetflow/model/data_types/history.dart';
import 'package:budgetflow/model/data_types/month.dart';
import 'package:budgetflow/model/implementations/io/month_io.dart';
import 'package:budgetflow/model/implementations/services/file_service.dart';
import 'package:budgetflow/model/utils/serializer.dart';

class HistoryIO implements IO {
  FileService _fileService;
  History _history;

  HistoryIO(this._fileService);

  HistoryIO.fromHistory(this._history, this._fileService);

  @override
  Future<History> load() async {
    String content = await _fileService.readAndDecryptFile(historyFilepath);
    _history = Serializer.unserialize(historyKey, content);
    return _history;
  }

  Future save() {
    // History must be initialized. If it isn't, throw an error.
    if (_history == null) throw new _HistoryNotInitializedError();
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

class _HistoryNotInitializedError extends Error {
  @override
  String toString() {
    return "HistoryNotInitializedError: You can't save a history that doesn't exist. Did you mean to instantiate your HistoryIO object with HistoryIO.fromHistory?";
  }
}
