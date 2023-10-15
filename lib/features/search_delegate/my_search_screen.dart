import 'package:ecommerce_major_project/features/home/providers/search_provider.dart';
import 'package:ecommerce_major_project/features/home/services/home_services.dart';
import 'package:ecommerce_major_project/main.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_major_project/features/search/screens/search_screen.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class MySearchScreen extends StatefulWidget {
  final String? searchQueryAlready;
  const MySearchScreen({this.searchQueryAlready, super.key});

  @override
  State<MySearchScreen> createState() => _MySearchScreenState();
}

/* 
Cases : 

historyList    : based on user searches
suggestionList : all product names list


Case - I : user types and submits value
Response : onFieldSubmitted -> navigateToSearchScreen

Case - II: user clicks directly on a suggestion without typing
Response :  onChanged - false, onTap() ListTile, rank higher in historyList, by removing and adding again

Case - III: user types and clicks on suggestion
Response  :  onChanged - true, show suggestionList filter real time using provider, onTap() ListTile -> add to historyList



*/

class _MySearchScreenState extends State<MySearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  HomeServices homeServices = HomeServices();
  List<String> allProductsList = [];
  List<String>? historyList = [];
  bool isUserTyping = false;

  // maximum 10 items stored in history
  int maxLength = 10;

  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  makeSuggestionList() async {
    allProductsList = await homeServices.fetchAllProductsNames(context);
    setState(() {});
  }

  fetchSearchHistory() async {
    historyList = await homeServices.fetchSearchHistory(context);
    setState(() {});
  }

  deleteSearchHistoryItem(String deleteQuery,int index) async {
    historyList!.removeAt(historyList!.length-index-1);
    homeServices.deleteSearchHistoryItem(
        context: context, deleteQuery: deleteQuery);
    setState(() {});
  }

  addToHistory(String searchQuery) async {
    homeServices.addToHistory(context: context, searchQuery: searchQuery);
    setState(() {});
  }

  searchViaApi(String searchQuery) async {
    return await homeServices.searchProducts(context, searchQuery);
  }

  @override
  void initState() {
    super.initState();
    // adds all product names to suggestionList
    makeSuggestionList();

    // add all searchHistory to the historyList
    fetchSearchHistory();
    _initSpeech();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void navigateToSearchScreen(String query) {
    //make sure to pass the arguments here!
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
      _searchController.text = _lastWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<UserProvider>(context).user;
    final searchProvider = Provider.of<SearchProvider>(context, listen: true);
    // add and remove from buildSuggestionsList according to the search query in onChange
    List<String>? buildSuggestionsList = searchProvider.getSuggetions;
    // final searchProvider = Provider.of<SearchProvider>(context, listen: true);
    return GestureDetector(
      onTap: () {},
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 2,
          backgroundColor: Colors.white,
          leadingWidth: mq.width * .075,
          title: Container(
            margin: EdgeInsets.only(left: mq.width * .03),
            child: Material(
              borderRadius: BorderRadius.circular(mq.width * .025),
              elevation: 1,
              child: TextFormField(
                controller: _searchController,
                onChanged: (val) async{
                  // user is typing something
                  if (val.isNotEmpty) {
                    setState(() {
                      isUserTyping = true;
                    });
                    List<String> searchResults = await searchViaApi(val.toLowerCase());
                    // show relevant suggestions if they match the value user is typing is matching
                    // character by character from the start [using startsWith()]
                    // if they dont match or stop matching after a certain length of query
                    // remove them from the list
                    // Example :  val : pum,    suggestion : Puma Shoes
                    //            val : pumxyz, suggestion : empty
                    searchProvider.addListToSuggestions(searchResults);
                  }

                  // user is not typing OR user has cleared the search bar
                  else {
                    setState(() {
                      isUserTyping = false;
                    });
                  }
                },
                // when the search field is submitted
                // redirect to search screen, i.e. to the screen
                // with the relevant search query results

                // textInputAction: TextInputAction.done,
                onFieldSubmitted: (val) {
                  // add the item to historyList
                  // searchProvider.addToSuggestions(val);
                  if (val.trim().isNotEmpty) {
                    // if historyList has NOT reached maxLength
                    if (!historyList!.contains(val.toLowerCase())) {
                      addToHistory(val.toLowerCase().trim());
                    }

                    // when historyList reaches maxLength
                    // if (historyList!.length == maxLength) {
                    // deleteSearchHistoryItem(historyList![0]);
                    // addToHistory(val.toLowerCase().trim());
                    // }

                    _searchController.clear();
                    navigateToSearchScreen(val.trim());
                  }

                  debugPrint("\n\n\nHistory now  -----------> :  $historyList");
                },
                autofocus: true,
                // enabled: true,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.only(top: mq.width * .03),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(mq.width * .025),
                      borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(mq.width * .025),
                      borderSide:
                          const BorderSide(color: Colors.black38, width: 1)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(mq.width * .025),
                      borderSide:
                          const BorderSide(color: Colors.black38, width: 0.4)),
                  // border: null,
                  hintText: "Search",
                  hintStyle: const TextStyle(fontWeight: FontWeight.w400),
                  prefixIcon: InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: EdgeInsets.only(left: mq.width * 0.02),
                      child: const Icon(Icons.search, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: mq.width * 0.035),
              child: SizedBox(
                height: 40,
                width: 40,
                child: FloatingActionButton(
                  elevation: 0,
                  backgroundColor: const Color.fromARGB(255, 43, 6, 103),
                  onPressed:
                      // If not yet listening for speech start, otherwise stop
                      _speechToText.isNotListening
                          ? _startListening
                          : _stopListening,
                  tooltip: 'Listen',
                  child: Icon(
                      _speechToText.isNotListening ? Icons.mic_off : Icons.mic,
                      color: Colors.white),
                ),
              ),
            ),
            // Padding(

            //   padding: EdgeInsets.only(right: mq.width * 0.35),
            //   child: InkWell(
            //     onTap: () {
            //       // Scaffold.of(context).openDrawer();
            //       // _scaffoldKey.currentState!.openEndDrawer();
            //       _speechToText.isNotListening
            //           ? _startListening
            //           : _stopListening;
            //       // Navigator.of(context).push(
            //       //     MaterialPageRoute(builder: (_) => SpeechExample()));
            //     },
            //     child: Icon(
            //         _speechToText.isNotListening
            //             ? Icons.mic_off
            //             : Icons.mic,
            //         size: 30),
            //   ),
            // ),
          ],
        ),
        body: Center(
          child: historyList == null
              ? ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: allProductsList.length,
                  itemBuilder: (context, index) {
                    String listTitle = allProductsList[index].trim();
                    // searchProvider.getSugggetions!.toList()[index].trim();
                    return ListTile(
                      onTap: () {
                        if (!historyList!.contains(listTitle.toLowerCase())) {
                          addToHistory(listTitle.toLowerCase());
                        }

                        // when historyList reaches maxLength
                        // if (!historyList!.contains(listTitle.toLowerCase())) {
                        //   deleteSearchHistoryItem(historyList![0]);
                        //   addToHistory(listTitle.toLowerCase());
                        // }

                        navigateToSearchScreen(listTitle);

                        /*
                        // print(
                        //     "\nQuery to be searched ====>  ${searchHistoryList![index]}");
                        // navigateToSearchScreen(listTitle);
//complete this duplicate entries are also coming
//moreover when the search item from productNames list is clicked add it to history

// trim() every query!

                        // if (!searchHistoryList!
                        //     .contains(
                        //         searchController
                        //             .text
                        //             .trim())) {
                        //   homeServices
                        //       .setSearchHistory(
                        //     context: context,
                        //     searchQuery:
                        // searchController
                        //     .text
                        //     .trim(),
                        //   );
                        // }

                        // if (searchHistoryList!.length < maxLength) {
                        //   homeServices.setSearchHistory(
                        //     context: context,
                        //     searchQuery: listTitle,
                        //   );
                        // } else if (searchHistoryList!.length == maxLength) {
                        //   print("\n\n====> max length reached...");
                        //   setState(() {
                        //     homeServices.deleteSearchHistoryItem(
                        //         context: context, deleteQuery: searchHistoryList![0]);
                        //     // searchHistoryList!.removeAt(0);
                        //     homeServices.setSearchHistory(
                        //         context: context, searchQuery: listTitle);
                        //     // searchHistoryList!
                        //     //     .add(query.trim());
                        //   });
                        // }

                        // isSearchOn = false;
                        // searchController.clear();
                        */
                      },
                      title: Text(listTitle,
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                      // contentPadding: EdgeInsets.zero,
                      leading: const Icon(
                        Icons.trending_up_rounded,
                        color: Colors.grey,
                        shadows: [Shadow(blurRadius: 0.4)],
                      ),
                      tileColor: Colors.grey.shade100,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(18)),
                      ),
                    );
                  },
                )
              : isUserTyping
                  ? buildSuggestionsList == null || buildSuggestionsList.isEmpty
                      ? const SizedBox()
                      : ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: buildSuggestionsList.length,
                          itemBuilder: (context, index) {
                            String listTitle =
                                buildSuggestionsList[index].trim();
                            // searchProvider.getSugggetions!.toList()[index].trim();
                            return ListTile(
                              onTap: () {
                                if (!historyList!
                                    .contains(listTitle.toLowerCase())) {
                                  addToHistory(listTitle.toLowerCase());
                                }

                                // // when historyList reaches maxLength
                                // if (!historyList!
                                //     .contains(listTitle.toLowerCase())) {
                                //   homeServices.deleteSearchHistoryItem(
                                //       context: context,
                                //       deleteQuery: historyList![0]);
                                //   addToHistory(listTitle.toLowerCase());
                                // }

                                navigateToSearchScreen(listTitle);

                                /*
                        // print(
                        //     "\nQuery to be searched ====>  ${searchHistoryList![index]}");
                        // navigateToSearchScreen(listTitle);
//complete this duplicate entries are also coming
//moreover when the search item from productNames list is clicked add it to history

// trim() every query!

                        // if (!searchHistoryList!
                        //     .contains(
                        //         searchController
                        //             .text
                        //             .trim())) {
                        //   homeServices
                        //       .setSearchHistory(
                        //     context: context,
                        //     searchQuery:
                        // searchController
                        //     .text
                        //     .trim(),
                        //   );
                        // }

                        // if (searchHistoryList!.length < maxLength) {
                        //   homeServices.setSearchHistory(
                        //     context: context,
                        //     searchQuery: listTitle,
                        //   );
                        // } else if (searchHistoryList!.length == maxLength) {
                        //   print("\n\n====> max length reached...");
                        //   setState(() {
                        //     homeServices.deleteSearchHistoryItem(
                        //         context: context, deleteQuery: searchHistoryList![0]);
                        //     // searchHistoryList!.removeAt(0);
                        //     homeServices.setSearchHistory(
                        //         context: context, searchQuery: listTitle);
                        //     // searchHistoryList!
                        //     //     .add(query.trim());
                        //   });
                        // }

                        // isSearchOn = false;
                        // searchController.clear();
                        */
                              },
                              title: Text(listTitle,
                                  maxLines: 1, overflow: TextOverflow.ellipsis),
                              // contentPadding: EdgeInsets.zero,
                              leading: const Icon(
                                Icons.trending_up_rounded,
                                color: Colors.grey,
                                shadows: [Shadow(blurRadius: 0.4)],
                              ),
                              tileColor: Colors.grey.shade100,
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(18)),
                              ),
                            );
                          },
                        )
                  :
                  // historyList
                  ListView.builder(
                      key: UniqueKey(),
                      padding: EdgeInsets.zero,
                      itemCount: historyList!.length,
                      itemBuilder: (context, index) {
                        // List<String>? historyView =
                        //     historyList!.reversed as List<String>?;
                        String listTitle =
                            historyList!.reversed.toList()[index].trim();
                        // searchProvider.getSugggetions!.toList()[index].trim();
                        return ListTile(
                          onTap: () {
                            // if (!historyList!
                            //         .contains(listTitle.toLowerCase()) &&
                            //     historyList!.length < maxLength) {
                            //   addToHistory(listTitle.toLowerCase());
                            // }

                            // // when historyList reaches maxLength
                            // if (!historyList!
                            //         .contains(listTitle.toLowerCase()) &&
                            //     historyList!.length == maxLength) {
                            //   homeServices.deleteSearchHistoryItem(
                            //       context: context,
                            //       deleteQuery: historyList![0]);
                            //   addToHistory(listTitle.toLowerCase());
                            // }

                            // if (historyList!
                            //     .contains(listTitle.toLowerCase())) {
                            //   String deleteQuery = listTitle;
                            //   deleteSearchHistoryItem(deleteQuery);
                            //   addToHistory(deleteQuery);
                            // }

                            navigateToSearchScreen(listTitle);

                            /*
                        // print(
                        //     "\nQuery to be searched ====>  ${searchHistoryList![index]}");
                        // navigateToSearchScreen(listTitle);
//complete this duplicate entries are also coming
//moreover when the search item from productNames list is clicked add it to history

// trim() every query!

                        // if (!searchHistoryList!
                        //     .contains(
                        //         searchController
                        //             .text
                        //             .trim())) {
                        //   homeServices
                        //       .setSearchHistory(
                        //     context: context,
                        //     searchQuery:
                        // searchController
                        //     .text
                        //     .trim(),
                        //   );
                        // }

                        // if (searchHistoryList!.length < maxLength) {
                        //   homeServices.setSearchHistory(
                        //     context: context,
                        //     searchQuery: listTitle,
                        //   );
                        // } else if (searchHistoryList!.length == maxLength) {
                        //   print("\n\n====> max length reached...");
                        //   setState(() {
                        //     homeServices.deleteSearchHistoryItem(
                        //         context: context, deleteQuery: searchHistoryList![0]);
                        //     // searchHistoryList!.removeAt(0);
                        //     homeServices.setSearchHistory(
                        //         context: context, searchQuery: listTitle);
                        //     // searchHistoryList!
                        //     //     .add(query.trim());
                        //   });
                        // }

                        // isSearchOn = false;
                        // searchController.clear();
                        */
                          },
                          title: Text(listTitle,
                              maxLines: 1, overflow: TextOverflow.ellipsis),
                          // contentPadding: EdgeInsets.zero,
                          leading: const Icon(
                            Icons.history,
                            color: Colors.grey,
                            shadows: [Shadow(blurRadius: 0.4)],
                          ),

                          // delete search history item
                          trailing: IconButton(
                            onPressed: () {
                              deleteSearchHistoryItem(
                                  listTitle,index);
                            },
                            icon: const Icon(Icons.cancel),
                          ),
                          tileColor: Colors.grey.shade100,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                          ),
                        );
                      },
                    ),
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        // floatingActionButton:
      ),
    );
  }
}

