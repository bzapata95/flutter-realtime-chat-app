import 'package:chat_app/services/users_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/models/user.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final userService = UsersService();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List<User> users = [];

  @override
  void initState() {
    _reloadUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
          title: Text(authService.user.name,
              style: const TextStyle(color: Colors.black87)),
          elevation: 1,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.black87),
            onPressed: () {
              Navigator.pushReplacementNamed(context, 'login');
              socketService.disconnect();
              AuthService.deleteToken();
            },
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: (socketService.serverStatus == ServerStatus.online)
                  ? Icon(Icons.check_circle, color: Colors.green[400])
                  : Icon(Icons.offline_bolt, color: Colors.red[400]),
            )
          ]),
      body: SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          onRefresh: _reloadUsers,
          header: WaterDropHeader(
            complete: Icon(Icons.check, color: Colors.blue[400]),
            waterDropColor: Colors.blue.shade400,
          ),
          child: _listViewUsers()),
    );
  }

  ListView _listViewUsers() {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemBuilder: (_, i) => _usersListTile(users[i]),
      separatorBuilder: (_, i) => const Divider(),
      itemCount: users.length,
    );
  }

  ListTile _usersListTile(User user) {
    return ListTile(
      title: Text(user.name),
      subtitle: Text(user.email),
      leading: CircleAvatar(
        child: Text(user.name.substring(0, 2)),
        backgroundColor: Colors.blue[100],
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: user.online ? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(5)),
      ),
    );
  }

  _reloadUsers() async {
    users = await userService.getUsers();
    setState(() {});
    // monitor network fetch
    //  await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }
}
