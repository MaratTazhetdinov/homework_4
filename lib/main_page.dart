import 'package:flutter/material.dart';
import 'info_widget.dart';

class MainPage extends StatelessWidget{

  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children: [
          const Expanded(
            child: InfoWidget(),
          ),
          Expanded(
              child: Container(
                color:Colors.yellow,
                child:Center(
                  child: TextButton(
                    onPressed: () {
                      if (infoState.checkTextField()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Text Field is Empty!')
                            )
                        );
                      } else {
                        infoState.loadData();

                      }
                      },
                    child: const Text('Push me'),
                  ),
                )
              )
          ),
        ]
      )
    );
  }

}