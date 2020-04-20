import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/abstract/saveable.dart';
import 'package:budgetflow/model/abstract/service.dart';
import 'package:budgetflow/model/data_types/account.dart';
import 'package:budgetflow/model/data_types/account_list.dart';
import 'package:budgetflow/model/data_types/payment_method.dart';
import 'package:budgetflow/model/implementations/services/service_dispatcher.dart';
import 'package:budgetflow/model/utils/serializer.dart';

class AccountService implements Service, Saveable {
  ServiceDispatcher _dispatcher;
  AccountList _accounts;
  List<PaymentMethod> _paymentMethods;

  AccountList get accounts => _accounts;

  List<PaymentMethod> get paymentMethods => _paymentMethods;

  AccountService(this._dispatcher);

  Future start() async {
    if (await _filesExist()) {
      String content = await _dispatcher
          .getFileService()
          .readAndDecryptFile(accountsFilepath);
      _accounts = (Serializer.unserialize(accountListKey, content));
    } else {
      _accounts = AccountList();
    }
    _initializePaymentMethods();
  }

  Future<bool> _filesExist() {
    return _dispatcher.getFileService().fileExists(accountsFilepath);
  }

  void _initializePaymentMethods() {
    _paymentMethods.add(PaymentMethod.cash);
    for (Account account in _accounts) {
      _paymentMethods.add(account);
    }
  }

  Future stop() async {
    await save();
  }

  Future save() async {
    String content = _accounts.serialize;
    await _dispatcher
        .getFileService()
        .encryptAndWriteFile(accountsFilepath, content);
  }

  void addAccount(Account account) {
    if (!_accounts.contains(account)) _accounts.add(account);
  }

  bool removeAccount(Account account) {
    return _accounts.remove(account);
  }
}
