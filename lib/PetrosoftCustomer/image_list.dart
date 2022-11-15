import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:petrosoft_india/common/widgets/custom_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'accept_request.dart';

class ImageList extends StatefulWidget {
  final String credVou;

  const ImageList(this.credVou);
  @override
  _ImageListState createState() => _ImageListState(credVou);
}

class _ImageListState extends State<ImageList> {
  final String path;

  _ImageListState(this.path);
  dynamic vehicleNoImagePath;
  dynamic startMeterImagePath;
  dynamic endMeterImagePath;
  dynamic otherImage1Path;
  dynamic otherImage2ImagePath;
  dynamic imageListData;
  dynamic api;
  List imgTitle=[
    "Vehicle No",
    "Start Meter",
    "End Meter",
    "Other1",
    "Other2"
  ];
  getData() async {
    var _url = UT.APIURL! +
        "api/Image/Get?id=crsl${widget.credVou}&yr=${UT.curyear}&shop=${UT.shop_no}";

    imageListData = await UT.apiDt(_url);

    return imageListData;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    api=getData();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: FutureBuilder(
            future: api,
            builder: (context,snapshot){
              if(snapshot.hasData){
               return imageListData.length!=0?
                 Column(
                  children: [
                    const SizedBox(height: 20,),
                        Expanded(
                           // height: MediaQuery.of(context).size.height,
                    child: GridView.builder(
                      // physics: NeverScrollableScrollPhysics(),
                        itemCount: imageListData.length,
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                          childAspectRatio: 3 / 2,
                          // crossAxisCount: 2,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 20,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return  Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SingleChildScrollView(
                                child: Column(
                                  children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: Colors.grey.shade300),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.shade100,
                                          blurRadius: 1.0,
                                          spreadRadius: 1.0, //extend the shadow
                                          offset: const Offset(
                                            3.0, // Move to right 10  horizontally
                                            3.0, // Move to bottom 5 Vertically
                                          ),
                                        ),
                                      ],
                                      color: Colors.white,
                                    ),
                                    child: SizedBox(
                                        width: 140,
                                        height: 100,
                                        child:Image.network(
                                          "${UT.APIURL!}"+"/CamImages/"+imageListData[index]["imageid"]+".jpeg",fit: BoxFit.cover,
                                        )
                                    ),
                                  ),
                                  Text(
                                    imgTitle[index],
                                  ),
                                ],
                                ),
                              ),
                            ],
                          );
                        }
                    )
              ),
                           Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 60,
                width: 250,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0),
                  child: CommonButtonForAllApp(onPressed: () async {
              DialogBuilder(context).showLoadingIndicator('');
              var crhdData= Map();
              crhdData["cred_vou"]=widget.credVou;
              crhdData["isapprove"]="Y";
              crhdData["approvedby"]=UT.userName!;
              List crhdDataList=[];
              crhdDataList.add(crhdData);
              var _url = UT.APIURL! +
              "api/PostData/Post?tblname=crhd" +
              UT.curyear! +
              UT.shop_no!;
              _url += "&Unique=cred_vou";
              var Result = await UT.save2Db(_url, crhdDataList);

              if(Result=="ok"){
              DialogBuilder(context).hideOpenDialog();
              Navigator.of(context)
                  .push(CupertinoPageRoute<bool>(builder: (BuildContext context) {
              return const AcceptRequest();
              }));
              }
              }, title: "Approve",backgroundColor: ColorsForApp.appThemeColorPetroCustomer,)



                ),
              )
            ],

          )
         ],
                )
                    : Center(child:Text("No Images found!! ",style: UT.PetrosoftCustomerNoDataStyle,));
              }
              return Center(child: CommonWidget.circularIndicator());
            }

         ),
        ),
      )
    );
  }

}