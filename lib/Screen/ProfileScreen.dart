
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:memorymate/Screen/LoginScreen.dart';
import 'package:memorymate/resources/auth_methods.dart';
import 'package:memorymate/utils/utils.dart';
import 'package:memorymate/widgets/follow.dart';
import 'package:flutter_social_button/flutter_social_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};

  var classData = {};
  int postLen = 0;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('student')
          .doc(widget.uid)
          .get();

      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      postLen = postSnap.docs.length;
      userData = userSnap.data()!;

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : SafeArea(
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Color.fromARGB(255, 252, 69, 104),
                title: Text(
                  'STUDENT PROFILE',
                  style: TextStyle(color: Colors.white),
                ),
                centerTitle: true,
                elevation: 0.0,
              ),
              body: Container(
                color: Colors.white,
                child: ListView(children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: Color.fromARGB(255, 255, 206, 225),
                            backgroundImage: NetworkImage(userData['photoUrl']),
                            radius: 60,
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(top: 15),
                        //color: Colors.pink,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Contact',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                color: Color.fromARGB(255, 252, 69, 104),
                                shadows: [
                                  Shadow(
                                    color: Color.fromARGB(255, 150, 149, 149),
                                    offset: Offset(0,2.5) ,
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Name:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                            Text(' ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                )),
                            Text(userData['firstName'],
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 20,
                                )),
                            Text(' ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 20,
                                )),
                            Text(userData['secondName'],
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 20,
                                )),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(top: 2),
                        child: Row(
                          children: [
                            Text(
                              'Email:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color:  Colors.black,
                              ),
                            ),
                            Text(' ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                )),
                            Text(userData['email'],
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 20,
                                )),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(top: 2),
                        child: Row(
                          children: [
                            Text(
                              'Phone:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color:  Colors.black,
                              ),
                            ),
                            Text(' ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                )),
                            Text(userData['phone'],
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 20,
                                )),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(top: 2),
                        child: Row(
                          children: [
                            Text(
                              'Sem:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color:  Colors.black,
                              ),
                            ),
                            Text(' ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                )),
                            Text(userData['sem'],
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 20,
                                )),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(top: 2),
                        child: Row(
                          children: [
                            Text(
                              'Class:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color:  Colors.black,
                              ),
                            ),
                            Text(' ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                )),
                            Text(userData['Class'],
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 20,
                                )),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(top: 2),
                        child: Row(
                          children: [
                            Text(
                              'Division:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color:  Colors.black,
                              ),
                            ),
                            Text(' ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                )),
                            Text(userData['Division'],
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 20,
                                )),
                          ],
                        ),
                      ),
                      const Divider(),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(top: 10),
                        //color: Color.fromARGB(255, 251, 255, 220),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Skills',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Color.fromARGB(255, 252, 69, 104),
                                shadows: [
                                  Shadow(
                                    color: Color.fromARGB(255, 150, 149, 149),
                                    offset: Offset(0,2.5) ,
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(userData['skill'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            )),
                      ),
                      const Divider(),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(top: 15),
                        //color: Color.fromARGB(255, 251, 255, 220),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Connect With Me',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Color.fromARGB(255, 252, 69, 104),
                                shadows: [
                                  Shadow(
                                    color: Color.fromARGB(255, 150, 149, 149),
                                    offset: Offset(0,2.5) ,
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                        
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                        
                        ],
                      ),
                      Container(
                          height:45,
                          width: 180,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: Color.fromARGB(255, 252, 69, 104),
                              width: 3,
                            ),
                          ),
                          //color: Colors.blue[100],
                          margin: EdgeInsets.symmetric(vertical: 40),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(top: 0.5),
                          child: Row(
                            // mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FollowButton(
                                backgroundColor:
                                    Colors.white,
                                borderColor: Colors.white,
                                text: 'Sign Out',
                                textColor: Colors.black,
                                function: () async {
                                  await AuthMethods().signOut();
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(),
                                    ),
                                  );
                                },
                              )
                            ],
                          )),
                    ]),
                  ),
                  FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('posts')
                          .where('uid', isEqualTo: widget.uid)
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 1.5,
                                  childAspectRatio: 1),
                          shrinkWrap: true,
                          itemCount: (snapshot.data! as dynamic).docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot snap =
                                (snapshot.data! as dynamic).docs[index];

                            return Container(
                              child: Image(
                                  image: NetworkImage(
                                snap['postUrl'],
                              )),
                            );
                          },
                        );
                      })
                ]),
              ),
            ),
          );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        )
      ],
    );
  }

  
}
