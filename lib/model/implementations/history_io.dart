import 'package:budgetflow/model/abstract/io.dart';
import 'package:budgetflow/model/implementations/services/file_service.dart';

class HistoryIO implements io {
  FileService _fileService;

  HistoryIO(this._fileService);

  @override
  Future<Object> load() {
    // TODO: implement load
    return null;
  }

  @override
  Future save() {
    // TODO: implement save
    return null;
  }
}
