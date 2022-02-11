// ignore_for_file: constant_identifier_names
import 'package:cloud_firestore/cloud_firestore.dart';
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
              active: doc['active'],
              name: doc['name'],
              username: doc['username'],
              gender: doc['gender'],
              password: doc['password'],
              urlPhoto: doc['urlPhoto'],
              email: doc['email'],
              phoneNumber: doc['phoneNumber'],
              status: doc['status'],
            )
        );
        return lista.toList();
    }

    delete(id) async {

        // mudar para remover logico
        await userCollection.doc(id).set({
            'status': ''
        });
    }

    saveOrUpdate(User user) async {
        await userCollection.doc(user.id.toString()).set({
            
        });
    }
}