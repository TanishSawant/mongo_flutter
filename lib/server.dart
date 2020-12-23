import 'package:mongo_dart/mongo_dart.dart';
import 'package:sevr/sevr.dart';

void start() async{
  print('opening db....');
  final db = await Db.create("mongodb+srv://pablo:pablo@cluster0.kwsbg.mongodb.net/contacts?retryWrites=true&w=majority");
  await db.open();
  print('db open!!');
  final coll = db.collection('contacts');
  print(await coll.find().toList());
  coll.insert({'name' : 'Arturo Iglesias'});
  const port = 8081;
  final serv = Sevr();

   serv.get('/', [
    (ServRequest req, ServResponse res) async {
      final contacts = await coll.find().toList();
      return res.status(200).json({'contacts': contacts});
    }
  ]);

  serv.listen(port, callback: (){
    print('Listening to port : $port');
  });
}