import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatelessWidget {
  final DateFormat _dateFormat = DateFormat("dd-MM-yyyy");

  final String _query = """
  query launchHistory {
      launchesPast(limit: 50) {
        mission_name 
        launch_date_utc
        rocket {
          rocket_name
          rocket_type
        }
        links {
          flickr_images
        }
      }
    }
""";

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(documentNode: gql(_query)),
      builder: (
        QueryResult result, {
        VoidCallback refetch,
        FetchMore fetchMore,
      }) {
        if (result.loading) {
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final List launches = result.data["launchesPast"];

        if (launches == null || launches.isEmpty) {
          return Column(
            children: [
              navigateOption(),
              SizedBox(height: 50),
              Container(
                child: Center(
                  child: Text("No items found"),
                ),
              ),
            ],
          );
        } else {
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                navigateOption(),
                SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Center(
                    child: Text(
                      "Past launches",
                      style: GoogleFonts.orbitron().copyWith(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: launches.length,
                  padding: const EdgeInsets.all(20),
                  itemBuilder: (context, index) {
                    final launch = launches[index];
                    final List<dynamic> images =
                        launch['links']['flickr_images'];

                    return Stack(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(
                            bottom: 25,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 10),
                                color: Colors.grey,
                                blurRadius: 30,
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      margin: const EdgeInsets.only(right: 100),
                                      child: Text(
                                        launch['mission_name'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      "Rocket",
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      "${launch['rocket']['rocket_name']}",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      "Rocket Type",
                                      style: TextStyle(
                                          fontSize: 17, color: Colors.grey),
                                    ),
                                    Text(
                                      "${launch['rocket']['rocket_type']}",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      "Launch date",
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    launch['launch_date_utc'] != null
                                        ? Text(
                                            "${_dateFormat.format(DateTime.parse(launch['launch_date_utc']))}",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        : Text(
                                            "Not Decided",
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        images.length > 0
                            ? Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  margin: const EdgeInsets.only(top: 50),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: SizedBox(
                                        height: 100,
                                        width: 120,
                                        child: Image.network(
                                          images.last,
                                          fit: BoxFit.cover,
                                        ),
                                      )),
                                ),
                              )
                            : Container(),
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        }
      },
    );
  }

  navigateOption() {
    return Row(
      children: [
        Text(
          "Upcoming",
          style: TextStyle(
              fontSize: 35, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        SizedBox(
          width: 50,
        ),
        Text(
          "Past",
          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
