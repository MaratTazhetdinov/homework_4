import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

final infoState = InfoWidgetState();

class InfoWidget extends StatefulWidget {

  const InfoWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return infoState;
  }
}

class InfoWidgetState extends State{
  final TextEditingController _controller = TextEditingController();
  late MainPageState state;

  @override
  void initState() {
    state = DefaultState();
    super.initState();
  }

  Widget buildBody(){

    if(state.runtimeType == DefaultState) {
      return getDefaultState();
    }

    if(state.runtimeType == LoadingState) {
      return getLoadingState();
    }

    if(state.runtimeType == LoadedState) {
      return getLoadedState();
    }

    if(state.runtimeType == BadInternetConnection) {
      return badInternetConnection();
    }

    return const Placeholder();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.blue,
      child: Center (
        child: buildBody(),
      ),
    );
  }

  Widget getDefaultState() {
    return TextField(
      controller: _controller,
      decoration:  const InputDecoration(
        hintText: 'Input name',
      ),
    );
  }

  Widget getLoadingState() {
    return const CircularProgressIndicator(
      color: Colors.yellow,
    );
  }

  Widget getLoadedState() {
    final data = (state as LoadedState).info;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(data),
        const SizedBox(height: 30),
        FloatingActionButton(onPressed: () {
          setState(() {
            _controller.text = '';
            state = DefaultState();
          });
        },
          backgroundColor: Colors.red,
          child: const Icon(Icons.refresh),
        ),
      ],
    );
  }

  Widget badInternetConnection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('No Internet connection'),
        const SizedBox(height: 30),
        FloatingActionButton(onPressed: () {
          setState(() {
            _controller.text = '';
            state = DefaultState();
          });
        },
          backgroundColor: Colors.red,
          child: const Icon(Icons.refresh),
        ),
      ],
    );
  }

  void loadData() async {

    setState(() {
      state = LoadingState();
    });

    try {
      final response = await http.get(Uri.parse('https://api.agify.io/?name=${_controller.text}'));
      setState(() {
        var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
        var info = jsonResponse['age'].toString();
        if (info == 'null') {
          state = LoadedState('No information about this name');
        } else {
          state = LoadedState(info);
        }
      });
    }
    catch (e){
      setState(() {
        state = BadInternetConnection();
      });
    }
  }

  bool checkTextField() => _controller.text.isEmpty;

}

class MainPageState{

}

class DefaultState extends MainPageState {

}

class LoadingState extends MainPageState {

}

class LoadedState extends MainPageState {
  String info;
  LoadedState(this.info);
}

class BadInternetConnection extends MainPageState{

}