// ignore_for_file: constant_identifier_names, file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pops_app/core/model/call.dart';

class CallRepo{

    late CollectionReference callCollection;

    CallRepo(){
        callCollection = FirebaseFirestore.instance.collection('call');
    }

    Future<List<Call>> find() async {
        var res = await callCollection.get();

        var lista = res.docs.map(
            (doc) => Call(
              id: doc.reference.id.toString(),
              active: doc[Call.ACTIVE],
              receiver: doc[Call.RECEIVER],
              caller: doc[Call.CALLER],
              startTime: doc[Call.START_TIME],
              endTime: doc[Call.END_TIME],
              status: doc[Call.STATUS],
            )
        );
        return lista.toList();
    }

    delete(id) async {
        await callCollection.doc(id).set({
            Call.ACTIVE: false
        });
    }

    saveOrUpdate(Call call) async {
      if (call.id.toString().isEmpty || call.id.toString() == 'null'){
        await callCollection.doc().set(call.toJson());
      }
      else{
        await callCollection.doc(call.id.toString()).set(call.toJson());
      }
    }
}