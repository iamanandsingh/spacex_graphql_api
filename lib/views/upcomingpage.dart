import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';

class UpcomingPage extends StatelessWidget {
  final DateFormat _dateFormat = DateFormat("dd-MM-yyyy");

  final String _query = """
  query launchUpcoming {
      launchesUpcoming {
        mission_name 
        launch_date_utc
        rocket {
          rocket_name
          rocket_type
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

        final List launches = result.data["launchesUpcoming"];

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
                SizedBox(height: 70),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Center(
                    child: Text(
                      "Upcoming Launches",
                      style: GoogleFonts.orbitron().copyWith(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: launches.length,
                  padding: const EdgeInsets.all(24),
                  itemBuilder: (context, index) {
                    final launch = launches[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 25),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 10),
                            color: Colors.grey,
                            blurRadius: 30,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Center(
                            child: Text(
                              launch['mission_name'],
                              textAlign: TextAlign.center,
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
                            style: TextStyle(fontSize: 17, color: Colors.grey),
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
                              fontSize: 10,
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

  Widget navigateOption() {
    return Row(
      children: [
        Text(
          "Upcoming",
          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 50,
        ),
        Text(
          "Past",
          style: TextStyle(
              fontSize: 35, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
      ],
    );
  }
}
