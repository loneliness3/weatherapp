import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/network/api.dart';
import 'package:weather_app/components.dart/background_gradiantcolor.dart';
import 'package:weather_app/components.dart/textstyle.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var country = 'Get the information up to second!';
  var state = '';
  double temp = 19;
  var txt = '';
  var ico = 'http://openweathermap.org/img/wn/50d@4x.png';
  TextEditingController cityname = TextEditingController();

  changeBgColor() {
    if (temp < 20) {
      return Gradientbg(Colors.blueGrey);
    } else if (20 < temp && temp < 22) {
      return Gradientbg(Colors.blue);
    } else {
      return Gradientbg(Colors.yellow.shade700);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shall I drink coffee or have ice_cream today?',
          style: GoogleFonts.alegreya(),
        ),
        centerTitle: true,
        shadowColor: Colors.black,
        backgroundColor: Colors.blue.shade300,
      ),
      body: Stack(
        children: [
          changeBgColor(),
          SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: cityname,
                  decoration: InputDecoration(
                    hintText: 'Enter the city name you want to search',
                    border: OutlineInputBorder(),
                    fillColor: Colors.grey,
                    prefixIcon: Icon(Icons.location_city),
                  ),
                  onSubmitted: ((value) {
                    cityname.text = value;
                  }),
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                        onTap: () {
                          API().getOverAll(cityname.text.toLowerCase()).then(
                            (value) {
                              setState(() {
                                country = 'Alpha2Code:   ' +
                                    value!.sys!.country.toString();
                                temp = value!.main!.temp!.toDouble();
                                ico =
                                    logo_url + '${value!.weather![0].icon}@4x.png';
                                txt = 'Temperature in °C: ' +
                                    value.main!.temp.toString() +
                                    'Celcius';
                                state = 'State:   ' +
                                    value.weather![0].description.toString();
                              });
                            },
                          );
                        },
                        highlightColor: Colors.black,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.transparent.withOpacity(0.2),
                          ),
                          
                          child: Row(
                            children: [
                              Icon(
                            Icons.search,
                            size: 50,
                          ),
                          Text('Search City',)
                            ],
                          ),
                        )),
                         InkWell(
                  onTap: () {
                    API().determinePosition().then(
                      (value) {
                        setState(() {
                          country =
                              'Alpha2Code:   ' + value!.sys!.country.toString();
                          temp = value.main!.temp!.toDouble();
                          ico = logo_url + '${value!.weather![0].icon}@4x.png';
                          txt = 'Temperature in °C:' +
                              value.main!.temp.toString() +
                              'Celcius';
                          state = 'State:   ' +
                              value.weather![0].description.toString();
                          cityname.text = '';
                        });
                      },
                    );
                  },
                  child: Icon(
                    Icons.gps_fixed,
                    size: 50,
                    color: Colors.blue.shade900,
                    ),
                ),
                  ],
                ),
               
                Image.network(ico),
                Text(country, style: TextStyle(fontSize: 25)),
                SizedBox(height: 10,),
                Text(txt, style: TextStyle(fontSize: 25)),
                SizedBox(height: 10,),
                Text(
                  state,
                  style: TextStyle(fontSize: 25),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
