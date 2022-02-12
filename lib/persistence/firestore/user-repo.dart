// ignore_for_file: constant_identifier_names, file_names
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
              active: doc[User.ACTIVE],
              name: doc[User.NAME],
              username: doc[User.USERNAME],
              gender: doc[User.GENDER],
              password: doc[User.PASSWORD],
              urlPhoto: doc[User.URL_PHOTO],
              email: doc[User.EMAIL],
              phoneNumber: doc[User.PHONE_NUMBER],
              role: doc[User.ROLE]
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
      if (user.id.toString().isEmpty || user.id.toString() == 'null'){
        await userCollection.doc().set(user.toJson());
      }
      else{
        await userCollection.doc(user.id.toString()).set(user.toJson());
      }
        
    }
}