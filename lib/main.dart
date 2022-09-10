import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CountryPage(),
    );
  }
}

class CountryPage extends StatefulWidget {
  const CountryPage({Key? key}) : super(key: key);

  @override
  State<CountryPage> createState() => _CountryPageState();
}

class _CountryPageState extends State<CountryPage> {
  final _bloc = CountryBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MyApp"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(width: 1.2, color: Colors.grey)),
          child: CountryDropDown(bloc: _bloc),
        ),
      ),
    );
  }
}

class CountryDropDown extends StatelessWidget {
  const CountryDropDown({
    Key? key,
    required CountryBloc bloc,
  })  : _bloc = bloc,
        super(key: key);

  final CountryBloc _bloc;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _bloc.streamReference,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();
        return DropdownButton(
          isExpanded: true,
          hint: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("${_bloc.getCountry.name}"),
          ),
          underline: const SizedBox(),
          icon: const Icon(Icons.keyboard_arrow_down, size: 32.0),
          items: _bloc.countries.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Directionality(
                textDirection: Directionality.of(context).index == 0
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 4.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(width: 1.2, color: Colors.grey)),
                  child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text("${item.name}"),
                      )),
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            _bloc.selectCountry(value as ObjectModel);
          },
        );
      },
    );
  }
}

class CountryBloc {
  List<ObjectModel> countries = [
    ObjectModel(id: "0", name: 'USA'),
    ObjectModel(id: "1", name: 'CHINA'),
    ObjectModel(id: "2", name: 'INDIA'),
    ObjectModel(id: "3", name: 'BRAZIL'),
  ];

  final _country = BehaviorSubject<ObjectModel>.seeded(
      ObjectModel(id: "-1", name: "Select Country Name.."));

  Stream<ObjectModel> get streamReference => _country.stream;

  Function(ObjectModel) get selectCountry => _country.sink.add;

  ObjectModel get getCountry => _country.value;

  void setCountry(ObjectModel country) {
    _country.value = country;
  }
}

class ObjectModel {
  String? id;
  String? name;

  ObjectModel({this.id, this.name});

  ObjectModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
