import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chats',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(left: 16.0, right: 8),
            child: Icon(Icons.qr_code_scanner),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.0, right: 8),
            child: Icon(Icons.camera_alt_outlined),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Icon(Icons.more_vert),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, 50),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              height: 50,
              child: SearchBar(
                hintText: 'search',
                trailing: Iterable.generate(
                  1,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Icon(Icons.search),
                  ),
                ),
                hintStyle: WidgetStatePropertyAll(
                    TextStyle(color: Colors.grey.shade400, fontSize: 19)),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListView.builder(
          itemCount: 16,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              leading: CircleAvatar(
                radius: 30,
              ),
              title: Text(index.toString()),
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 12.0,right: 14),
        child: FloatingActionButton(onPressed: () {

        },
          backgroundColor: Colors.green.shade500,
          child: Icon(Icons.add_comment),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: CurvedNavigationBar(
          backgroundColor: Colors.green.shade200,
          items: [
            Icon(Icons.chat_sharp),
            Icon(Icons.update),
            Icon(Icons.groups_2_outlined),
            Icon(Icons.call),
          ],
        ),
      ),
    );
  }
}
