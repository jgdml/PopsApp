// ignore_for_file: constant_identifier_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pops_app/core/model/status-enum.dart';
import 'package:pops_app/core/model/user.dart';

class UserRepo{

    late CollectionReference userCollection;

    UserRepo(){
        userCollection = FirebaseFirestore.instance.collection('user');
    }

    Future<List<User>> find() async {
        var res = await userCollection.get();

        var lista = res.docs.map(
            (doc) => User(
              id: doc.reference.id.toString(),
              active: doc['ACTIVE'],
              name: doc['NAME'],
              username: doc['USERNAME'],
              gender: doc['GENDER'],
              password: doc['PASSWORD'],
              urlPhoto: doc['URLPHOTO'],
              email: doc['EMAIL'],
              phoneNumber: doc['PHONENUMBER'],
            )
        );
        return lista.toList();
    }

    delete(id) async {
        await userCollection.doc(id).set({
            'ACTIVE': false
        });
    }

    saveOrUpdate(User user) async {
        await userCollection.doc(user.id.toString()).set(user.toJson());
    }
}