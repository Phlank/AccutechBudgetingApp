import 'package:budgetflow/model/abstract/io.dart';
import 'package:budgetflow/model/data_types/history.dart';
import 'package:budgetflow/model/implementations/services/file_service.dart';

class HistoryIO implements IO {
  FileService _fileService;

  HistoryIO(this._fileService);

  @override
  Future<History> load() {
    // TODO: implement load
    return null;
  }

  @override
  Future save() {
    // TODO: implement save
    return null;
  }
}
