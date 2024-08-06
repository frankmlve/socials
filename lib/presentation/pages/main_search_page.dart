import 'package:flutter/material.dart';
import 'package:socials/domain/model/user.dart';
import 'package:socials/domain/repository/user_repository.dart';
import 'package:socials/presentation/pages/profile_page.dart';
import 'package:socials/presentation/widgets/avatar.dart';

class MainSearchPage extends StatefulWidget {
  const MainSearchPage({Key? key}) : super(key: key);

  @override
  State<MainSearchPage> createState() => _MainSearchPageState();
}

class _MainSearchPageState extends State<MainSearchPage> {
    final TextEditingController _searchController = TextEditingController();
    final UserRepository _userRepository = UserRepository();
    final List<User> _users = [];
    final List<User> _usersFiltered = [];

    void filterUserList(String query) {
      if (query.isEmpty) {
        setState(() {
          _usersFiltered.clear();
          _usersFiltered.addAll(_users);
        });
      }
      final users = _users.where((user) {
        final userLower = user.name.toLowerCase();
        final queryLower = query.toLowerCase();
        return userLower.contains(queryLower);
      }).toList();
      setState(() {
        _usersFiltered.clear();
        _usersFiltered.addAll(users);
      });
    }
  @override
  void initState() {
    super.initState();
    _userRepository.fetchAllUsers().then((users) {
      setState(() {
        _users.addAll(users);
        _usersFiltered.addAll(users);
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          ListTile(
            title: TextField(
              controller: _searchController,
              decoration: InputDecoration(labelText: 'Search'),
              onChanged: (text) => filterUserList(text),
            ),
          ),
          ListView(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(vertical: 10),
            children: _usersFiltered.map((user) {
              return Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.5),
                  child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfilePage(
                                  userId: user.id,
                                )));
                      },
                      child: Avatar(
                        user: user,
                        size: 20,
                      )));
            }).toList(),
          )
        ],
      ),
    )
    );
  }
}