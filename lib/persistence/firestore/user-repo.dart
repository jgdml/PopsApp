// ignore_for_file: constant_identifier_names, file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pops_app/core/model/gender-enum.dart';
import 'package:pops_app/core/model/role-enum.dart';
import 'package:pops_app/core/model/user.dart';

class UserRepo {
    late CollectionReference userCollection;

    UserRepo() {
        userCollection = FirebaseFirestore.instance.collection('user');
    }

    Future<List<User>> find() async {
        var res = await userCollection.get();

        var lista = res.docs.map((doc) => User(
                    id: doc.reference.id.toString(),
                    active: doc[User.ACTIVE],
                    name: doc[User.NAME],
                    username: doc[User.USERNAME],
                    gender: GenderEnumExtension.fromRaw(doc[User.GENDER]),
                    password: doc[User.PASSWORD],
                    urlPhoto: doc[User.URL_PHOTO],
                    email: doc[User.EMAIL],
                    phoneNumber: doc[User.PHONE_NUMBER],
                    role: RoleEnumEnumExtension.fromRaw(doc[User.ROLE]),
                ));
        return lista.toList();
    }

    Future<User> findByEmail(String email) async {
        var res = await userCollection.where('email', isEqualTo: email).get();
        var doc = res.docs[0];

        return User(
            id: doc.reference.id.toString(),
            active: doc[User.ACTIVE],
            name: doc[User.NAME],
            username: doc[User.USERNAME],
            gender: GenderEnumExtension.fromRaw(doc[User.GENDER]),
            password: doc[User.PASSWORD],
            urlPhoto: doc[User.URL_PHOTO],
            email: doc[User.EMAIL],
            phoneNumber: doc[User.PHONE_NUMBER],
            role: RoleEnumEnumExtension.fromRaw(doc[User.ROLE]),
        );
    }

    delete(id) async {
        await userCollection.doc(id).set({'ACTIVE': false});
    }

    saveOrUpdate(User user) async {
        if (user.id.toString().isEmpty || user.id.toString() == 'null') {
            await userCollection.doc().set(user.toJson());
        } else {
            await userCollection.doc(user.id.toString()).set(user.toJson());
        }
    }
}
