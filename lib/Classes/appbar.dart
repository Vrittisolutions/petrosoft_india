import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'colors.dart';
import 'dimension.dart';



class CustomAppBar extends StatefulWidget with PreferredSizeWidget {
  final String title;
  final String? enableSearchBar;
  final String specifyClickFromPage;
  final dynamic objPage;


  const CustomAppBar({required this.title,
    this.enableSearchBar,
    required this.specifyClickFromPage,
    this.objPage,
  });

  @override
  State<StatefulWidget> createState() => _CustomAppBar(
      title,
      enableSearchBar!,
      specifyClickFromPage,
      objPage
    );
  @override
  Size get preferredSize =>
      Size.fromHeight(DimensionsForApp.app_bar_size);
}
class _CustomAppBar extends State {
  @override
  final Size preferredSize;
  final String title;
  final String enableSearchBar;
  final dynamic objPage;
  final String specifyClickFromPage;


  Widget appBarTitle = Text("title",style:  StyleForApp.text_style_bold_14_white);

  Icon actionIcon = const Icon(
    Icons.search,
    color: Colors.white,
    size: 20,
  );


  _CustomAppBar(
      this.title,
      this.enableSearchBar,
      this.specifyClickFromPage,
      this.objPage,
     ) : preferredSize = const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    /*enableRefreshButton == "ENB_addtp"
        ? actionIcon2 = Icon(
      Icons.add,
      size: DimensionsForApp.app_icon_size,
    ) :enableRefreshButton == "ENB_forward_arrow"
        ? actionIcon2 = Icon(
      Icons.arrow_forward,
      size: DimensionsForApp.app_icon_size,
    )
        : enableRefreshButton == "ENB-add"
        ? actionIcon2 = Icon(
      Icons.add,
      size: DimensionsForApp.app_icon_size,
    )
        : enableRefreshButton == "ENB-tick"
        ? actionIcon2 = Icon(
      Icons.done_rounded,
      size: DimensionsForApp.app_icon_size,
    )
        : enableRefreshButton == "ENB-mic"
        ? actionIcon2 = Icon(
      Icons.mic,
      size: DimensionsForApp.app_icon_size,
    )
        : enableRefreshButton == "ENB-loc"
        ? actionIcon2 = Icon(
      Icons.location_on_rounded,
      size: DimensionsForApp.app_icon_size,
    )
        : enableRefreshButton == "ENB_3dotscrm"
        ? actionIcon2 = Icon(
      Icons.more_vert_rounded,
      size: DimensionsForApp.app_icon_size,
    )
        : actionIcon2 = Icon(
      Icons.autorenew_rounded,
      size: DimensionsForApp.app_icon_size,
    );*/
   // appBarTitle = Text(title,style:  StyleForApp.text_style_bold_14_white);
    return AppBar(
        backgroundColor: ColorsForApp.appThemeColorAdatOwner,
        leading: this.actionIcon.icon == Icons.search
            ? InkWell(
          child: Padding(
            padding: const EdgeInsets.only(left: 5, right: 2),
            child: Container(
              alignment: Alignment.centerLeft,
              child: Icon(
                Icons.arrow_back_outlined,
                color: Colors.white,
                size: DimensionsForApp.app_icon_size,
              ),
            ),
          ),
          onTap: () async {
            Navigator.pop(context);
          },
        )
            :  const SizedBox(
          height: 0,
          width: 0,
        ),
      actions: <Widget>[
          enableSearchBar == 'ENB'
              ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 30,
                    child: IconButton(
                      icon: actionIcon,
                      onPressed: () {
                        setState(() {
                          if (actionIcon.icon == Icons.search) {
                            actionIcon = Icon(
                              Icons.close,
                              color: Colors.white,
                              size: DimensionsForApp.app_icon_size,
                            );
                            appBarTitle = TextField(
                              autofocus: true,
                              onChanged: (text) {
                                callSearch(text, "SEARCH");
                                objPage.onSearchTextChanged("");
                              },
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: Colors.white,
                                    size: DimensionsForApp.app_icon_size,
                                  ),
                                  hintText: " Search",
                                  hintStyle:
                                  const TextStyle(color: Colors.white)),
                            );
                          } else {
                            print("CLOSEDSEARCHBAR-1");
                            actionIcon = Icon(
                              Icons.search,
                              color: Colors.white,
                              size: DimensionsForApp.app_icon_size,
                            );
                            appBarTitle = Text(title,style:  StyleForApp.text_style_bold_14_white);

                          }
                        });
                      },
                    ),
                  ),
                ],
              ) : Container(),
        ],
        title:  actionIcon.icon == Icons.search
              ?Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: Container(
                 child: Transform(
    transform: Matrix4.translationValues(-52.0, 0.0, 0.0),
    child: Row(
    children: <Widget>[
    const SizedBox(
    width: 7,
    ),
    Flexible(
    child: Container(
    width: MediaQuery.of(context).size.width - 100,
    padding: const EdgeInsets.only(right: 3.0),
    child: Text(
    title,
    overflow: TextOverflow.ellipsis,
    style:StyleForApp.text_style_bold_14_white,
    ),
    ),
    ),
    ],
    ))),
              )
            : Container(
            alignment: Alignment.center,
            child: Transform(
              transform: Matrix4.translationValues(-75.0, 0, 0),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 5, right: 5, top: 5, bottom: 0),
                child: TextField(
                  autofocus: true,
                  onChanged: (text) {
                    callSearch(text, "SEARCH");
                  },
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.white,
                        size: DimensionsForApp.app_icon_size,
                      ),
                      hintText: "Search",
                      hintStyle: const TextStyle(color: Colors.white)),
                ),
              ),
            ))

    );
  }





  void callSearch(String text, String callStatus) {
    switch (specifyClickFromPage) {
      case "CustomerLedger":
        print("CustomerLedgerList");
        objPage.onSearchTextChanged(text);
        break;
      case "SupplierLedger":
        print("SupplierLedgerList");

        objPage.onSearchTextChanged(text);

        break;
      case "OTHER":
        break;
      default:
        break;
    }
  }



  void forwardArrowClick() async {
    switch(specifyClickFromPage){
      case "FollowUpDateTime":
        print("Followup date time");
        objPage.routePage("Followup Action");

        break;

    // Navigator.of(context).push(_createRoute());
    // break;
      default:
        break;
    }

  }
}

class CustomAppBarWithoutTrailing extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final GestureTapCallback onPressed;
  final Color backgroundColor;
  const CustomAppBarWithoutTrailing({Key? key, required this.title, required this.onPressed , required this.backgroundColor}) : preferredSize = const Size.fromHeight(60.0), super(key: key);

  @override
  final Size preferredSize;

  @override
  _CustomAppBarState createState() => _CustomAppBarState(
    title,onPressed,backgroundColor
  );
}

class _CustomAppBarState extends State<CustomAppBarWithoutTrailing>{
  final String title;
  final GestureTapCallback onPressed;
  final Color backgroundColor;
  _CustomAppBarState(this.title,this.onPressed,this.backgroundColor);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title:  Text(title,style:  StyleForApp.text_style_bold_14_white),
      iconTheme: StyleForApp.iconThemeData,
      backgroundColor: backgroundColor,
      titleSpacing: 0.0,
      leading: IconButton(
        highlightColor: Colors.white,
        onPressed: onPressed,
        icon: const Icon(Icons.arrow_back),
      ),
    );
  }
}








