import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/abstract/io.dart';
import 'package:budgetflow/model/data_types/month.dart';
import 'package:budgetflow/model/implementations/services/file_service.dart';
import 'package:budgetflow/model/utils/serializer.dart';

class MonthIO implements IO {
  FileService _fileService;
  DateTime _time;
  Month _month;

  MonthIO(this._month, this._fileService) {
    _time = _month.time;
  }

  MonthIO.ofTime(this._time, this._fileService);

  Future<Month> load() async {
    String filepath = _time.millisecondsSinceEpoch.toString();
    String content = await _fileService.readAndDecryptFile(filepath);
    return Serializer.unserialize(monthKey, content);
  }

  Future save() async {
    String filepath = _time.millisecondsSinceEpoch.toString();
    String content = _month.serialize;
    _fileService.encryptAndWriteFile(filepath, content);
  }
}
